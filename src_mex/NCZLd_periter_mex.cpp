//#include "multires.hpp"
#include "image.hpp"
#include "util.hpp"

#include "layer.hpp"
#include "cortical_magnification.hpp"

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

	array_out = mxCreateCellArray(1,lnScales);


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

	array_out = mxCreateCellArray(3,lndims7);

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
                fPtr2 = mxGetField(fPtr,0,"orig_width"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.orig_width = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"orig_height"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.orig_height = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"fov_x"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.fov_x = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"fov_y"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.fov_y = int_realPtr2[0];
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
                fPtr2 = mxGetField(fPtr,0,"cortex_width");  int_realPtr2 = (int *) mxGetPr(fPtr2); strParamCX.cortex_width = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"a"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.a = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"b"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.b = double_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"lambda"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamCX.lambda = double_realPtr2[0];
                //fPtr2 = mxGetField(fPtr,0,"isoPolarGrad"); double_realPtr2 = (int *) mxGetPr(fPtr2); strParamCX.isoPolarGrad = double_realPtr2;
                //fPtr2 = mxGetField(fPtr,0,"eccWidth"); double_realPtr2 = (int *) mxGetPr(fPtr2); strParamCX.eccWidth = double_realPtr2;
                fPtr2 = mxGetField(fPtr,0,"cortex_max_elong_mm"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamCX.cortex_max_elong_mm = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"cortex_max_az_mm"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamCX.cortex_max_az_mm = int_realPtr2[0];
                strParamCX.update();



//         fPtr = mxGetField(prhs[1],0,"csfparams");
//         fPtr = mxGetField(prhs[1],0,"image");
//         fPtr = mxGetField(prhs[1],0,"display_plot");
//         fPtr = mxGetField(prhs[1],0,"compute");



/////////////////PREPARE LGN

    // *** Convert data ***

	T_MULTIRES_IMG<TYPE> vvLGN;
	mxArray2LGN(&vvLGN,prhs[0],nScales,nOrient);


        ATROUS_ORIENT<IMG<TYPE>,IMG<TYPE>> ATrousOrient;

        ATrousOrient.vvW = vvLGN; //ATrousOrient.setData(&vvLGN);
        ATrousOrient.setMinSize(mida_min);
        //ATrousOrient.Forward();
        ATrousOrient.setScale2Size(POW_2_S_SC2SZ);


    T_LGN<TYPE> LGN = ATrousOrient.vvW ;
    strParam.strParamZLiNetwork.pMultires=&ATrousOrient;


    T_LGN<TYPE> p_INH_Control = LGN; p_INH_Control = 0.;


/////////////////////PREPARE LAYER and OUTPUTS


	LAYER<TYPE> V1(strParam);
	CorticalMagnification<TYPE> magnifier = CorticalMagnification<TYPE>(strParamCX,strParamGZ);

	V1.Config(&LGN);

	T_LAYER_OUTPUT<TYPE> FiringRate, FiringRate_Mean, FiringRateBuffer; //iFactor is FiringRate_mean
	ARRAY<ARRAY<T_LAYER_OUTPUT<TYPE>>> FiringRate_periter;


    FiringRate_Mean = LGN; FiringRate_Mean = 0.;

	V1.setOutput(&FiringRate);

	FiringRate = FiringRate_Mean;

	FiringRate_periter.Alloc(n_membr);



	for (int ff=0; ff< n_membr; ff++)
		FiringRate_periter[ff].Alloc(nIter);
	for (int membrt=0; membrt< n_membr; membrt++)
		for (int iter=0; iter< nIter; iter++)
			FiringRate_periter[membrt][iter] = FiringRate_Mean;








//////////////////////////READ input x_on, x_off, y_on, y_off




    if (nrhs == 0) { //leer MembrPot (x_on, x_off, y_on, y_off
        ZLI_NETWORK<TYPE> p_Layer_ON(strParam.strParamZLiNetwork), p_Layer_OFF(strParam.strParamZLiNetwork);
        V1.getLayer_ON(&p_Layer_ON);
        V1.getLayer_OFF(&p_Layer_OFF);


        T_MULTIRES_IMG<TYPE> ExcMembrPot_ON, ExcMembrPot_OFF, InhMembrPot_ON, InhMembrPot_OFF;


        mxArray2LGN(&ExcMembrPot_ON,prhs[2],nScales,nOrient);
        mxArray2LGN(&ExcMembrPot_OFF,prhs[3],nScales,nOrient);
        mxArray2LGN(&InhMembrPot_ON,prhs[4],nScales,nOrient);
        mxArray2LGN(&InhMembrPot_OFF,prhs[5],nScales,nOrient);


        p_Layer_ON.setvvExcMembrPot(&ExcMembrPot_ON);
        p_Layer_OFF.setvvExcMembrPot(&ExcMembrPot_OFF);
        p_Layer_ON.setvvInhMembrPot(&InhMembrPot_ON);
        p_Layer_OFF.setvvInhMembrPot(&InhMembrPot_OFF);


        V1.setLayer_ON(&p_Layer_ON);
        V1.setLayer_OFF(&p_Layer_OFF);


        //T_MULTIRES<T_CELL_ACT_MAP<TYPE> > pvviExcMembrPot;
        //V1.getvvExcMembrPot(&pvviExcMembrPot);
        //for (int s=0; s<nScales; s++)
        //    for (int o=0; o<nOrient; o++)
        //        for (int p=0; p<pvviExcMembrPot[s][o].Height()*pvviExcMembrPot[s][o].Width()-1; p++)
        //            std::cout<< s << ","<< o <<","<<pvviExcMembrPot[s][o].Height()<<"," << pvviExcMembrPot[s][o].Width() << ":" << pvviExcMembrPot[s][o][p] <<std::endl;

    }




////////////////////SOLVE DYNAMICS HERE


				for(int membrt=0;membrt<n_membr;++membrt)
				{
					std::cout << "\t Pos Membr time: " << membrt << std::endl;

					for(int iter=0;iter<nIter;++iter)
					{
						std::cout << "iter: " << iter << std::endl;

                        FiringRateBuffer = FiringRate;
                        std::cout << "hola1"<<std::endl;
                        if (ior){
                            //prepare multires from Inhibition from ior
                            TYPE precision = 1./nIter;
                            for(int s=0;s<nScales;++s){
                                for(int o=0;o<nOrient;++o){
                                    p_INH_Control[s][o]=strParamGZ.ior_matrix * exp(precision *log(strParamGZ.ior_factor_ctt));
                                }
                            }

                            V1.Solve(&FiringRateBuffer,&p_INH_Control);

						}else{

                            V1.Solve(&FiringRateBuffer);

						}



						if(membrt >= n_membr_ini_mean)
							FiringRate_Mean+=FiringRate*FiringRate;

						FiringRate_periter[membrt][iter] = FiringRate;

                        //redistort x_on, x_off, y_on, y_off

                        if (redistort_periter == true && foveate == true) {
                            magnifier.lgn_cortex2image(FiringRate, FiringRate, nScales, nOrient);
                            magnifier.lgn_image2cortex(FiringRate, FiringRate, nScales, nOrient);
						}

					}
				}

				for(int s=0;s<nScales;++s)
					for(int o=0;o<nOrient;++o)
						FiringRate_Mean[s][o] /= static_cast<TYPE>((n_membr-n_membr_ini_mean)*nIter);



/////////////////get output x_on, x_off, y_on, y_off

                ZLI_NETWORK<TYPE> p_Layer_ON(strParam.strParamZLiNetwork), p_Layer_OFF(strParam.strParamZLiNetwork);
                V1.getLayer_ON(&p_Layer_ON);
                V1.getLayer_OFF(&p_Layer_OFF);

                T_MULTIRES_IMG<TYPE> ExcMembrPot_ON, ExcMembrPot_OFF, InhMembrPot_ON, InhMembrPot_OFF;
                p_Layer_ON.getvvExcMembrPot(&ExcMembrPot_ON);
                p_Layer_OFF.getvvExcMembrPot(&ExcMembrPot_OFF);
                p_Layer_ON.getvvInhMembrPot(&InhMembrPot_ON);
                p_Layer_OFF.getvvInhMembrPot(&InhMembrPot_OFF);





    T_MULTIRES<T_CELL_ACT_MAP<TYPE> > pvviExcMembrPot;
        p_Layer_ON.getvvExcMembrPot(&pvviExcMembrPot);
        for (int s=0; s<nScales; s++)
            for (int o=0; o<nOrient; o++)
                for (int p=0; p<pvviExcMembrPot[s][o].Height()*pvviExcMembrPot[s][o].Width()-1; p++)
                    std::cout<< s << ","<< o <<","<<pvviExcMembrPot[s][o].Height()<<"," << pvviExcMembrPot[s][o].Width() << ":" << pvviExcMembrPot[s][o][p] <<std::endl;

	LGN.DeAlloc();

// *** Convert data ***

		// Set cell matrix


////////////////CONVERT OUTPUTS TO RETURN VALUES



    LGN2mxArray(&FiringRate_Mean,plhs[0],nScales,nOrient);

    dynamic_LGN2mxArray(&FiringRate_periter,plhs[1],nScales,nOrient,n_membr,nIter);

    LGN2mxArray(&ExcMembrPot_ON,plhs[2],nScales,nOrient);
    LGN2mxArray(&ExcMembrPot_OFF,plhs[3],nScales,nOrient);
    LGN2mxArray(&InhMembrPot_ON,plhs[4],nScales,nOrient);
    LGN2mxArray(&InhMembrPot_OFF,plhs[5],nScales,nOrient);

// **********************************************************



}


