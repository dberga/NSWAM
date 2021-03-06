//#include "multires.hpp"
#include "image.hpp"
#include "util.hpp"

#include "layer.hpp"
#include "cortical_magnification.hpp"
#include <video.hpp>

#include <matrix.h>
#include <math.h>
#include "conversion.hpp"



/******************************************************************


[iFactor_single, iFactor, x_on, x_off, y_on, y_off]=NCZLd_periter_mex(w_in, struct, x_on, x_off, y_on, y_off)

 	Parameters:
		- w_in: Input multiresolution coefficients (1 channel, i.e. non-color)

				Cell array being (Laplacian Pyramid)
               w{s}(:,:,1): i-th wavelet plane, horizontal details
               w{s}(:,:,2): i-th wavelet plane, vertical details
               w{s}(:,:,3): i-th wavelet plane, diagonal details

               where 's' is the spatial scale

        - x_on: Input multiresolution excitatory ON membrane potential, same format as w_in
        - x_off: Input multiresolution excitatory OFF membrane potential, same format as w_in
        - y_on: Input multiresolution inhibitory ON membrane potential, same format as w_in
        - y_off: Input multiresolution inhibitory OFF membrane potential, same format as w_in

		- struct: model parameters, including zli, wave, ...

		- iFactor_single: Last iteration iFactor, the same format as w_in

		- iFactor: iFactor per iter and n_membr




 ******************************************************************/


	template<typename TYPE>
void mxArray2LGN(T_MULTIRES_IMG<TYPE> *LGN_out,const mxArray *array_in,const int nScales, const int nOrient)
{

    LGN_out->Alloc(nScales);


    for(int s=0;s<nScales;++s)
	{
			// Get cell matrix

		mxArray *pTemp;
		pTemp = mxGetCell(array_in,s);

		if  ( !mxIsNumeric(pTemp) || mxIsComplex(pTemp) )
			mexErrMsgTxt("First parameter should be a cell of matrixes");

			// Convert matrix to an IMG array

		IMG<TYPE> *pTmpImg;
		int canals;

		pTmpImg = Matlab2IMAGE<TYPE>::func(pTemp, &canals);

		if(canals!=nOrient)
			throw;

			// Copy IMG array to T_MULTIRES<> format

		(*LGN_out)[s].Alloc(nOrient);

		for(int o=0;o<nOrient;++o)
			(*LGN_out)[s][o] = pTmpImg[o];

		delete [] pTmpImg;	// delete data allocated by Matlab2IMAGE
	}


}
	template<typename TYPE>
void LGN2mxArray(const T_MULTIRES_IMG<TYPE> *LGN_in, mxArray *array_out,const int nScales, const int nOrient)
{
    long unsigned int lnScales[1];

	lnScales[0] = nScales;

	//array_out = mxCreateCellArray(1,lnScales);

	IMG<TYPE> *pTmpImg;

	pTmpImg = new IMG<TYPE> [nOrient];

	for(int s=0;s<nScales;++s)
	{

			// Copy  T_MULTIRES<> format to IMG array

		for(int o=0;o<nOrient;++o)
			pTmpImg[o] = (*LGN_in)[s][o];


			// Copy IMG array to Cell matrix

		mxSetCell(array_out,s,IMAGE2Matlab(pTmpImg,nOrient));

	}

	delete [] pTmpImg;	// delete allocated data

}

	template<typename TYPE>
void dynamic_LGN2mxArray(const ARRAY<ARRAY<T_MULTIRES_IMG<TYPE>>> *LGN_in,mxArray *array_out,const int nScales, const int nOrient, const int n_membr, const int nIter)
{

    long unsigned int lndims5[1];
	lndims5[0] = nScales;

	long unsigned int lndims6[2];
	lndims6[0] = nIter;
	lndims6[1] = nScales;

	long unsigned int lndims7[3];
	lndims7[0] = n_membr;
	lndims7[1] = nIter;
	lndims7[2] = nScales;

	//array_out = mxCreateCellArray(3,lndims7);

	IMG<TYPE> *pTmpImg2;
	pTmpImg2 = new IMG<TYPE> [nOrient];

	for(int membrt=0;membrt<n_membr;++membrt)
	{

		mxArray *cell_iter;
		cell_iter = mxCreateCellArray(2,lndims6);

		for(int iter=0;iter<nIter;++iter){

			mxArray *cell_scales;
			cell_scales = mxCreateCellArray(1,lndims5);
			for (int s=0; s<nScales; ++s){
				for (int o=0; o<nOrient; ++o){
					pTmpImg2[o]= (*LGN_in)[membrt][iter][s][o];

				}
				mxSetCell(cell_scales,s,IMAGE2Matlab(pTmpImg2,nOrient));
			}
			mxSetCell(cell_iter,iter,cell_scales);
		}
		mxSetCell(array_out,membrt,cell_iter);


	}
    delete [] pTmpImg2;
}


void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
mexPrintf("Going into mex NCZLd_mex routine ... \n");

	typedef double TYPE;

	if(nrhs<1)
		mexErrMsgTxt("Too few parameters.");


    //////SET PARAMETERS

    strParam_LAYER<TYPE> strParam;
    strParam_Cortex<TYPE> strParamCX;
    strParam_Gaze<TYPE> strParamGZ;


    //CONSTANTS
     int nScales;
     int nOrient;
     int mida_min;
    //nScales = mxGetNumberOfElements(prhs[0]);
    //nOrient = mxGetNumberOfElements(mxGetCell(prhs[0],0));
     int n_membr;
     int nIter;
     int n_membr_ini_mean;

    //BOOLS
    bool foveate;
    bool redistort_periter;
    bool ior;
    bool rest; int n_membr_rest = 3;



//////////////////////////READ MATLAB STRUCT

        mxArray *fPtr;
        mxArray *fPtr2;


        //types of vars to retrieve
        double *double_realPtr2;
        int *int_realPtr2;
        char *char_realPtr2;
        bool bool_realPtr2;

        fPtr = mxGetField(prhs[1],0,"zli_params");
                fPtr2 = mxGetField(fPtr,0,"n_membr"); double_realPtr2 = (double *) mxGetPr(fPtr2); n_membr = double_realPtr2[0]; //mexPrintf("n_membr=%d\n",n_membr);
                fPtr2 = mxGetField(fPtr,0,"n_iter"); double_realPtr2 = (double *) mxGetPr(fPtr2); nIter = double_realPtr2[0]; strParam.strParamZLiNetwork.strParamComputation.nIterPerMembrTime = nIter; //mexPrintf("nIter=%d\n",strParam.strParamZLiNetwork.strParamComputation.nIterPerMembrTime );
                fPtr2 = mxGetField(fPtr,0,"n_frames_promig"); double_realPtr2 = (double *) mxGetPr(fPtr2); n_membr_ini_mean = n_membr-double_realPtr2[0]; //mexPrintf("n_membr_ini_mean=%d\n",n_membr_ini_mean);
                fPtr2 = mxGetField(fPtr,0,"dist_type"); char_realPtr2 = (char *) mxGetPr(fPtr2); if(strcmp(char_realPtr2, "manh")) strParam.strParamZLiNetwork.strParamZLiExcInh.tDist = MANH_DIST; else strParam.strParamZLiNetwork.strParamZLiExcInh.tDist = EUCL_DIST; //mexPrintf("tDist=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.tDist);
                fPtr2 = mxGetField(fPtr,0,"normal_type"); char_realPtr2 = (char *) mxGetPr(fPtr2); if(strcmp(char_realPtr2, "scale")) strParam.strParamZLiNetwork.strParamZLiExcInh.tNormalization = SCALE_NORM; else SCALE_NORM; //mexPrintf("tNormalization=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.tNormalization);// {NONE_NORM,ABSOLUTE_NORM, ALL_NORM, SCALE_NORM, SCALE_ORIENT_NORM} eNormalization;
                fPtr2 = mxGetField(fPtr,0,"scale2size_epsilon"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.Scale2Size_epsilon = double_realPtr2[0]; //mexPrintf("Scale2Size_epsilon=%f\n",strParam.strParamZLiNetwork.strParamZLiExcInh.Scale2Size_epsilon);
                fPtr2 = mxGetField(fPtr,0,"alphax"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.alpha_exc = double_realPtr2[0]; //mexPrintf("alpha_exc=%f\n",strParam.strParamZLiNetwork.strParamZLiExcInh.alpha_exc );
                fPtr2 = mxGetField(fPtr,0,"alphay"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.alpha_inh = double_realPtr2[0]; //mexPrintf("alpha_inh=%f\n",strParam.strParamZLiNetwork.strParamZLiExcInh.alpha_inh);
                fPtr2 = mxGetField(fPtr,0,"normal_input"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.input_normalization_value = double_realPtr2[0]; //mexPrintf("input_normalization_value=%f\n",strParam.strParamZLiNetwork.strParamZLiExcInh.input_normalization_value);
                //fPtr2 = mxGetField(fPtr,0,"normal_output"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.output_normalization_value = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"Delta"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.iDelta = double_realPtr2[0]; //mexPrintf("iDelta=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.iDelta);
                fPtr2 = mxGetField(fPtr,0,"kappax"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.kappa_J = double_realPtr2[0]; //mexPrintf("kappa_J=%f\n",strParam.strParamZLiNetwork.strParamZLiExcInh.kappa_J);
                fPtr2 = mxGetField(fPtr,0,"kappay"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.kappa_W = double_realPtr2[0]; //mexPrintf("kappa_W=%f\n", strParam.strParamZLiNetwork.strParamZLiExcInh.kappa_W);
                fPtr2 = mxGetField(fPtr,0,"normalization_power"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.normalization_power = double_realPtr2[0]; //mexPrintf("normalization_power=%f\n",strParam.strParamZLiNetwork.strParamZLiExcInh.normalization_power);
                fPtr2 = mxGetField(fPtr,0,"scale_interaction"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.bScaleInteraction = double_realPtr2[0]; //mexPrintf("bScaleInteraction=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.bScaleInteraction);
                fPtr2 = mxGetField(fPtr,0,"orient_interaction"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.bOrientInteraction = double_realPtr2[0]; //mexPrintf("bOrientInteraction=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.bOrientInteraction);
                fPtr2 = mxGetField(fPtr,0,"bScaleDelta"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.bScaleDelta = double_realPtr2[0]; //mexPrintf("bScaleDelta=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.bScaleDelta);
                fPtr2 = mxGetField(fPtr,0,"ON_OFF"); int_realPtr2 = (int *) mxGetPr(fPtr2); switch (int_realPtr2[0]) {case 0: strParam.tONOFF = SEPARATE_ONOFF;break; case 1: strParam.tONOFF=ABS_ONOFF;break; case 2: strParam.tONOFF = SQUARE_ONOFF;break;case 3: strParam.tONOFF=ABS_ONOFF;break; default: strParam.tONOFF = SEPARATE_ONOFF;break;}

            fPtr = mxGetField(prhs[1],0,"wave_params");
                fPtr2 = mxGetField(fPtr,0,"ini_scale");  double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.initial_scale = double_realPtr2[0]-1; //mexPrintf("initial_scale=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.initial_scale);
                fPtr2 = mxGetField(fPtr,0,"n_scales");  double_realPtr2 = (double *) mxGetPr(fPtr2); nScales = double_realPtr2[0]-1; //mexPrintf("nScales=%d\n",nScales);
                fPtr2 = mxGetField(fPtr,0,"n_orient");  double_realPtr2 = (double *) mxGetPr(fPtr2); nOrient = double_realPtr2[0]; //mexPrintf("nOrient=%d\n",nOrient);
                fPtr2 = mxGetField(fPtr,0,"mida_min");  double_realPtr2 = (double *) mxGetPr(fPtr2); mida_min = double_realPtr2[0]; //mexPrintf("mida_min=%d\n",mida_min);

            fPtr = mxGetField(prhs[1],0,"gaze_params");
                fPtr2 = mxGetField(fPtr,0,"foveate");  bool_realPtr2 = (bool ) mxGetPr(fPtr2); foveate = bool_realPtr2;
                fPtr2 = mxGetField(fPtr,0,"redistort_periter");  bool_realPtr2 = (bool ) mxGetPr(fPtr2); redistort_periter = bool_realPtr2;
                fPtr2 = mxGetField(fPtr,0,"orig_width"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.orig_width = (int)double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"orig_height"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.orig_height = (int)double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"fov_x"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.fov_x = (int)double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"fov_y"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.fov_y = (int)double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"img_diag_angle"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.img_diag_angle = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"ior");  bool_realPtr2 = (bool ) mxGetPr(fPtr2); ior = bool_realPtr2;
                fPtr2 = mxGetField(fPtr,0,"ior_factor_ctt"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.ior_factor_ctt = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"ior_angle"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.ior_angle = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"ior_matrix");
                strParamGZ.ior_matrix = IMG<TYPE>(); strParamGZ.ior_matrix.Alloc(mxGetM(fPtr2),mxGetN(fPtr2));
                double_realPtr2 = mxGetPr(fPtr2);
                for (int i=0; i< strParamGZ.ior_matrix.NPix(); i++) strParamGZ.ior_matrix[i]= double_realPtr2[i];
                fPtr2 = mxGetField(fPtr,0,"conserve_dynamics_rest");  bool_realPtr2 = (bool ) mxGetPr(fPtr2); rest = bool_realPtr2;
                strParamGZ.update();

            fPtr = mxGetField(prhs[1],0,"cortex_params");
                fPtr2 = mxGetField(fPtr,0,"cm_method");  char_realPtr2 = (char *) mxGetPr(fPtr2); if ( strcmp(char_realPtr2, "schwartz_monopole") == 0 ) strParamCX.method = SCHWARTZ_MONOPOLE; else if ( strcmp(char_realPtr2, "schwartz_dipole") == 0 ) strParamCX.method = SCHWARTZ_DIPOLE; else strParamCX.method = SCHWARTZ_MONOPOLE;
                fPtr2 = mxGetField(fPtr,0,"mirroring"); bool_realPtr2 = (bool ) mxGetPr(fPtr2); strParamCX.mirroring = bool_realPtr2;
                fPtr2 = mxGetField(fPtr,0,"cortex_width");  double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.cortex_width = (int)double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"a"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.a = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"b"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.b = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"lambda"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.lambda = double_realPtr2[0];
                //fPtr2 = mxGetField(fPtr,0,"isoPolarGrad"); double_realPtr2 = (int *) mxGetPr(fPtr2); strParamCX.isoPolarGrad = double_realPtr2;
                //fPtr2 = mxGetField(fPtr,0,"eccWidth"); double_realPtr2 = (int *) mxGetPr(fPtr2); strParamCX.eccWidth = double_realPtr2;
                fPtr2 = mxGetField(fPtr,0,"cortex_max_elong_mm"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.cortex_max_elong_mm = (int)double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"cortex_max_az_mm"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.cortex_max_az_mm = (int)double_realPtr2[0];
                strParamCX.update();



//         fPtr = mxGetField(prhs[1],0,"csfparams");
//         fPtr = mxGetField(prhs[1],0,"image");
//         fPtr = mxGetField(prhs[1],0,"display_plot");
//         fPtr = mxGetField(prhs[1],0,"compute");



/////////////////PREPARE LGN

    // *** Convert data ***

	T_MULTIRES_IMG<TYPE> vvLGN;
	mxArray2LGN(&vvLGN,prhs[0],nScales,nOrient);


        ATROUS_ORIENT_4<IMG<TYPE>,IMG<TYPE>> ATrousOrient, ATrousOrientNoise;

        ATrousOrient.vvW = vvLGN; //ATrousOrient.setData(&vvLGN);
        ATrousOrient.setMinSize(mida_min);
        ATrousOrient.setScale2Size(POW_2_S_SC2SZ);
        //ATrousOrient.Forward();


        TYPE noise = 0.001;
        TYPE bias = noise*10.0;
        ATrousOrientNoise.vvW = ATrousOrient.vvW * 0. + bias;
        //ATrousOrientNoise.Forward();



    T_LGN<TYPE> LGN = ATrousOrient.vvW ;
    T_LGN<TYPE> LGNNoise = ATrousOrientNoise.vvW ;


    strParam.strParamZLiNetwork.pMultires=&ATrousOrient;


    T_LGN<TYPE> p_INH_Control = LGN * 0.;


/////////////////////PREPARE LAYER and OUTPUTS


	LAYER<TYPE> V1(strParam);
	T_MULTIRES_IMG<TYPE> vvW;
    vvW = ATrousOrient.vvW;
    ARRAY<IMG<TYPE> > vC;
    vC = ATrousOrient.vC;



	CorticalMagnification<TYPE> magnifier = CorticalMagnification<TYPE>(strParamCX,strParamGZ);



	T_LAYER_OUTPUT<TYPE> FiringRate, FiringRate_Mean, FiringRateBuffer;
	ARRAY<ARRAY<T_LAYER_OUTPUT<TYPE>>> FiringRate_periter;
	FiringRate_Mean = LGN; FiringRate_Mean = 0.; //iFactor is FiringRate_mean
    FiringRate = FiringRate_Mean;





	FiringRate_periter.Alloc(n_membr);



	for (int ff=0; ff< n_membr; ff++)
		FiringRate_periter[ff].Alloc(nIter);
	for (int membrt=0; membrt< n_membr; membrt++)
		for (int iter=0; iter< nIter; iter++)
			FiringRate_periter[membrt][iter] = FiringRate_Mean;

V1.Config(&LGN);
V1.setOutput(&FiringRate);



T_LAYER_OUTPUT<TYPE> ExcFiringRate_ON,ExcFiringRate_OFF, InhFiringRate_ON,InhFiringRate_OFF;
T_MULTIRES_IMG<TYPE> ExcMembrPot_ON, ExcMembrPot_OFF, InhMembrPot_ON, InhMembrPot_OFF;
T_LAYER_OUTPUT<TYPE> ExcAdapt_ON, InhAdapt_ON, ExcAdapt_OFF, InhAdapt_OFF;

//VIDEO_MEMORY_PIECEWISE<T_LGN<TYPE> > Video;
//Video.setNFrames(n_membr*nIter);
//Video.setFrames(LGNNoise,0,n_membr*nIter);


//////////////////////////READ input x_on, x_off, y_on, y_off




    if (nrhs > 4) { //leer MembrPot (x_on, x_off, y_on, y_off


        mxArray2LGN(&ExcMembrPot_ON,prhs[2],nScales,nOrient);
        mxArray2LGN(&ExcMembrPot_OFF,prhs[3],nScales,nOrient);
        mxArray2LGN(&InhMembrPot_ON,prhs[4],nScales,nOrient);
        mxArray2LGN(&InhMembrPot_OFF,prhs[5],nScales,nOrient);


        V1.setvvExcMembrPot(&ExcMembrPot_ON,1);
        V1.setvvExcMembrPot(&ExcMembrPot_OFF,-1);
        V1.setvvInhMembrPot(&InhMembrPot_ON,1);
        V1.setvvInhMembrPot(&InhMembrPot_OFF,-1);



    }



////////////////////SOLVE DYNAMICS HERE


				for(int membrt=0;membrt<n_membr;++membrt)
				{
					std::cout << "\t Pos Membr time: " << membrt << std::endl;

					for(int iter=0;iter<nIter;++iter)
					{
						std::cout << "iter: " << iter << std::endl;



                        FiringRateBuffer = FiringRate;
                        //Video.getFrame(&LGN,membrt*nIter+iter);


                        if (ior){
                            //prepare multires from Inhibition from ior
                            TYPE precision = 1./nIter;
                            for(int s=0;s<nScales;++s){
                                for(int o=0;o<nOrient;++o){
                                    p_INH_Control[s][o]=strParamGZ.ior_matrix * exp(precision *log(strParamGZ.ior_factor_ctt));
                                    //std::cout << "inhcontrol" << p_INH_Control[s][o].Height()<< ","<< p_INH_Control[s][o].Width()<<std::endl;

                                }
                            }

                            V1.Solve(&LGN,&p_INH_Control);


						}else{

                            V1.Solve(&LGN);

						}


						//if(membrt >= n_membr_ini_mean)
							FiringRate_Mean+=FiringRate*FiringRate;

						FiringRate_periter[membrt][iter] = FiringRate;



                        //redistort x_on, x_off, y_on, y_off



                        if (redistort_periter) {

                            V1.getvvExcFiringRate(&ExcFiringRate_ON,1);
                            V1.getvvExcFiringRate(&ExcFiringRate_OFF,-1);
                            V1.getvvExcFiringRate(&InhFiringRate_ON,1);
                            V1.getvvExcFiringRate(&InhFiringRate_OFF,-1);
                            V1.getvvExcMembrPot(&ExcMembrPot_ON,1);
                            V1.getvvExcMembrPot(&ExcMembrPot_OFF,-1);
                            V1.getvvInhMembrPot(&InhMembrPot_ON,1);
                            V1.getvvInhMembrPot(&InhMembrPot_OFF,-1);
                            V1.getvvExcAdaptation(&ExcAdapt_ON,1);
                            V1.getvvExcAdaptation(&ExcAdapt_OFF,-1);
                            V1.getvvInhAdaptation(&InhAdapt_ON,1);
                            V1.getvvInhAdaptation(&InhAdapt_OFF,-1);


                            magnifier.lgn_cortex2image(&ExcFiringRate_ON, &ExcFiringRate_ON, nScales, nOrient);
                            magnifier.lgn_image2cortex(&ExcFiringRate_ON, &ExcFiringRate_ON, nScales, nOrient);

                            magnifier.lgn_cortex2image(&ExcFiringRate_OFF, &ExcFiringRate_OFF, nScales, nOrient);
                            magnifier.lgn_image2cortex(&ExcFiringRate_OFF, &ExcFiringRate_OFF, nScales, nOrient);

                            magnifier.lgn_cortex2image(&InhFiringRate_ON, &InhFiringRate_ON, nScales, nOrient);
                            magnifier.lgn_image2cortex(&InhFiringRate_ON, &InhFiringRate_ON, nScales, nOrient);

                            magnifier.lgn_cortex2image(&InhFiringRate_OFF, &InhFiringRate_OFF, nScales, nOrient);
                            magnifier.lgn_image2cortex(&InhFiringRate_OFF, &InhFiringRate_OFF, nScales, nOrient);

                            magnifier.lgn_cortex2image(&ExcMembrPot_ON, &ExcMembrPot_ON, nScales, nOrient);
                            magnifier.lgn_image2cortex(&ExcMembrPot_ON, &ExcMembrPot_ON, nScales, nOrient);

                            magnifier.lgn_cortex2image(&ExcMembrPot_OFF, &ExcMembrPot_OFF, nScales, nOrient);
                            magnifier.lgn_image2cortex(&ExcMembrPot_OFF, &ExcMembrPot_OFF, nScales, nOrient);

                            magnifier.lgn_cortex2image(&InhMembrPot_ON, &InhMembrPot_ON, nScales, nOrient);
                            magnifier.lgn_image2cortex(&InhMembrPot_ON, &InhMembrPot_ON, nScales, nOrient);

                            magnifier.lgn_cortex2image(&InhMembrPot_OFF, &InhMembrPot_OFF, nScales, nOrient);
                            magnifier.lgn_image2cortex(&InhMembrPot_OFF, &InhMembrPot_OFF, nScales, nOrient);

                            magnifier.lgn_cortex2image(&ExcAdapt_ON, &ExcAdapt_ON, nScales, nOrient);
                            magnifier.lgn_image2cortex(&ExcAdapt_ON, &ExcAdapt_ON, nScales, nOrient);

                            magnifier.lgn_cortex2image(&ExcAdapt_OFF, &ExcAdapt_OFF, nScales, nOrient);
                            magnifier.lgn_image2cortex(&ExcAdapt_OFF, &ExcAdapt_OFF, nScales, nOrient);

                            magnifier.lgn_cortex2image(&InhAdapt_ON, &InhAdapt_ON, nScales, nOrient);
                            magnifier.lgn_image2cortex(&InhAdapt_ON, &InhAdapt_ON, nScales, nOrient);

                            magnifier.lgn_cortex2image(&InhAdapt_OFF, &InhAdapt_OFF, nScales, nOrient);
                            magnifier.lgn_image2cortex(&InhAdapt_OFF, &InhAdapt_OFF, nScales, nOrient);

                            V1.setvvExcFiringRate(&ExcFiringRate_ON,1);
                            V1.setvvExcFiringRate(&ExcFiringRate_OFF,-1);
                            V1.setvvExcFiringRate(&InhFiringRate_ON,1);
                            V1.setvvExcFiringRate(&InhFiringRate_OFF,-1);
                            V1.setvvExcMembrPot(&ExcMembrPot_ON,1);
                            V1.setvvExcMembrPot(&ExcMembrPot_OFF,-1);
                            V1.setvvInhMembrPot(&InhMembrPot_ON,1);
                            V1.setvvInhMembrPot(&InhMembrPot_OFF,-1);
                            V1.setvvExcAdaptation(&ExcAdapt_ON,1);
                            V1.setvvExcAdaptation(&ExcAdapt_OFF,-1);
                            V1.setvvInhAdaptation(&InhAdapt_ON,1);
                            V1.setvvInhAdaptation(&InhAdapt_OFF,-1);




						}

					}
				}
				//for(int s=0;s<nScales;++s)
				//	for(int o=0;o<nOrient;++o)
				//		FiringRate_Mean[s][o] /= static_cast<TYPE>((n_membr-n_membr_ini_mean)*nIter);
                FiringRate_Mean /= static_cast<TYPE>(n_membr*nIter);

/////////////////get output x_on, x_off, y_on, y_off



                V1.getvvExcMembrPot(&ExcMembrPot_ON,1);
                V1.getvvExcMembrPot(&ExcMembrPot_OFF,-1);
                V1.getvvInhMembrPot(&InhMembrPot_ON,1);
                V1.getvvInhMembrPot(&InhMembrPot_OFF,-1);






	LGN.DeAlloc();

// *** Convert data ***

		// Set cell matrix


////////////////CONVERT OUTPUTS TO RETURN VALUES

    long unsigned int lndims5[1];
	lndims5[0] = nScales;

	long unsigned int lndims6[2];
	lndims6[0] = nIter;
	lndims6[1] = nScales;

	long unsigned int lndims7[3];
	lndims7[0] = n_membr;
	lndims7[1] = nIter;
	lndims7[2] = nScales;


    plhs[0]=mxCreateCellArray(1,lndims5);
    plhs[1]=mxCreateCellArray(3,lndims7);
    plhs[2]=mxCreateCellArray(1,lndims5);
    plhs[3]=mxCreateCellArray(1,lndims5);
    plhs[4]=mxCreateCellArray(1,lndims5);
    plhs[5]=mxCreateCellArray(1,lndims5);

    LGN2mxArray(&FiringRate_Mean,plhs[0],nScales,nOrient);

    dynamic_LGN2mxArray(&FiringRate_periter,plhs[1],nScales,nOrient,n_membr,nIter);

    LGN2mxArray(&ExcMembrPot_ON,plhs[2],nScales,nOrient);
    LGN2mxArray(&ExcMembrPot_OFF,plhs[3],nScales,nOrient);
    LGN2mxArray(&InhMembrPot_ON,plhs[4],nScales,nOrient);
    LGN2mxArray(&InhMembrPot_OFF,plhs[5],nScales,nOrient);

// **********************************************************



}


