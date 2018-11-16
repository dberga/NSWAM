#include "multires.hpp"
#include "image.hpp"
#include "util.hpp"

#include "V1.hpp"
#include "cortical_magnification.hpp"

#include <matrix.h>
#include <math.h>
#include "conversion.hpp"



/******************************************************************


[w_out]=NCZLd_periter_mex(w_in, struct)

 	Parameters:
		- w_in: Input multiresolution coefficients (1 channel, i.e. non-color)

				Cell array being (Laplacian Pyramid)
               w{s}(:,:,1): i-th wavelet plane, horizontal details
               w{s}(:,:,2): i-th wavelet plane, vertical details
               w{s}(:,:,3): i-th wavelet plane, diagonal details

               where 's' is the spatial scale

		-struct: model parameters, including zli, wave, ...

		- w_out: The same format as w_in, output iFactor



 ******************************************************************/

void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
mexPrintf("Going into mex NCZLd_mex routine ... \n");

	typedef double TYPE;

	if(nrhs<1)
		mexErrMsgTxt("Too few parameters.");


    //////SET PARAMETERS

    strParam_V1<TYPE> strParam;
    strParam_Cortex<TYPE> strParamCX;
    strParam_Gaze<TYPE> strParamGZ;


    //CONSTANTS
     int nScales;
     int nOrient;
    //nScales = mxGetNumberOfElements(prhs[0]);
    //nOrient = mxGetNumberOfElements(mxGetCell(prhs[0],0));
     int n_membr;
     int nIter;
     int n_membr_ini_mean;

    //BOOLS
    bool foveate;
    bool redistort_periter;


        mxArray *fPtr;
        mxArray *fPtr2;

        //types of vars to retrieve
        double *double_realPtr2;
        int *int_realPtr2;
        char *char_realPtr2;
        bool *bool_realPtr2;

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

            fPtr = mxGetField(prhs[1],0,"wave_params");
                fPtr2 = mxGetField(fPtr,0,"ini_scale");  double_realPtr2 = (double *) mxGetPr(fPtr2); strParam.strParamZLiNetwork.strParamZLiExcInh.initial_scale = double_realPtr2[0]-1; //mexPrintf("initial_scale=%d\n",strParam.strParamZLiNetwork.strParamZLiExcInh.initial_scale);
                fPtr2 = mxGetField(fPtr,0,"n_scales");  double_realPtr2 = (double *) mxGetPr(fPtr2); nScales = double_realPtr2[0]-1; //mexPrintf("nScales=%d\n",nScales);
                fPtr2 = mxGetField(fPtr,0,"n_orient");  double_realPtr2 = (double *) mxGetPr(fPtr2); nOrient = double_realPtr2[0]; //mexPrintf("nOrient=%d\n",nOrient);

            fPtr = mxGetField(prhs[1],0,"gaze_params");
                fPtr2 = mxGetField(fPtr,0,"foveate");  bool_realPtr2 = (bool *) mxGetPr(fPtr2); foveate = bool_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"redistort_periter");  bool_realPtr2 = (bool *) mxGetPr(fPtr2); redistort_periter = bool_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"orig_width"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.orig_width = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"orig_height"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.orig_height = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"fov_x"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.fov_x = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"fov_y"); int_realPtr2 = (int *) mxGetPr(fPtr2); strParamGZ.fov_y = int_realPtr2[0];
                fPtr2 = mxGetField(fPtr,0,"img_diag_angle"); double_realPtr2 = (double *) mxGetPr(fPtr2); strParamGZ.img_diag_angle = double_realPtr2[0];
                strParamGZ.update();

            fPtr = mxGetField(prhs[1],0,"cortex_params");
                fPtr2 = mxGetField(fPtr,0,"cm_method");  char_realPtr2 = (char *) mxGetPr(fPtr2); if ( strcmp(char_realPtr2, "schwartz_monopole") == 0 ) strParamCX.method = SCHWARTZ_MONOPOLE; else if ( strcmp(char_realPtr2, "schwartz_dipole") == 0 ) strParamCX.method = SCHWARTZ_DIPOLE; else strParamCX.method = SCHWARTZ_MONOPOLE;
                fPtr2 = mxGetField(fPtr,0,"mirroring"); bool_realPtr2 = (bool *) mxGetPr(fPtr2); strParamCX.mirroring = bool_realPtr2[0];
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



    // *** Convert data ***

	T_MULTIRES_IMG<TYPE> vvLGN;
	vvLGN.Alloc(nScales);
    for(int s=0;s<nScales;++s)
	{
			// Get cell matrix

		mxArray *pTemp;
		pTemp = mxGetCell(prhs[0],s);

		if  ( !mxIsNumeric(pTemp) || mxIsComplex(pTemp) )
			mexErrMsgTxt("First parameter should be a cell of matrixes");

			// Convert matrix to an IMG array

		IMG<TYPE> *pTmpImg;
		int canals;

		pTmpImg = Matlab2IMAGE<TYPE>::func(pTemp, &canals);

		if(canals!=nOrient)
			throw;

			// Copy IMG array to T_MULTIRES<> format

		vvLGN[s].Alloc(nOrient);

		for(int o=0;o<nOrient;++o)
			vvLGN[s][o] = pTmpImg[o];

		delete [] pTmpImg;	// delete data allocated by Matlab2IMAGE
	}
    mexPrintf("a2\n");
        ATROUS_ORIENT<IMG<TYPE>,IMG<TYPE>> ATrousOrient;
        ATrousOrient.vvW = vvLGN;


	T_LGN_ON<TYPE> LGN_ON;
	T_LGN_OFF<TYPE> LGN_OFF;

	LGN_ON.Alloc(nScales);
	LGN_OFF.Alloc(nScales);

	for(int s=0;s<nScales;++s)
	{
		LGN_ON[s].Alloc(nOrient);
		LGN_OFF[s].Alloc(nOrient);

		for(int o=0;o<nOrient;++o)
		{
			StripPosAndNeg(ATrousOrient.vvW[s][o],&LGN_ON[s][o],&LGN_OFF[s][o]);
			LGN_OFF[s][o] *= -1.0;
		}
	}
    strParam.strParamZLiNetwork.pMultires=&ATrousOrient;







// *** Execute code ***









	V1<TYPE> V1(strParam);
	CorticalMagnification<TYPE> magnifier = CorticalMagnification<TYPE>(strParamCX,strParamGZ);

	V1.Config(&ATrousOrient.vvW);



	T_V1_OUTPUT<TYPE> FiringRate,FiringRate_Mean;
	ARRAY<ARRAY<T_V1_OUTPUT<TYPE>>> FiringRate_periter;

	FiringRate_Mean = LGN_ON;

	for(int s=0;s<nScales;++s)
		for(int o=0;o<nOrient;++o)
			FiringRate_Mean[s][o]=0.;

	V1.setOutput(&FiringRate);

	FiringRate = FiringRate_Mean;

	FiringRate_periter.Alloc(n_membr);


	for (int ff=0; ff< n_membr; ff++)
		FiringRate_periter[ff].Alloc(nIter);
	for (int membrt=0; membrt< n_membr; membrt++)
		for (int iter=0; iter< nIter; iter++)
			FiringRate_periter[membrt][iter] = FiringRate;

				for(int membrt=0;membrt<n_membr;++membrt)
				{
					std::cout << "\t Pos Membr time: " << membrt << std::endl;

					for(int iter=0;iter<nIter;++iter)
					{
						std::cout << "iter: " << iter << std::endl;

						V1.Solve(&LGN_ON,&LGN_OFF);

						if(membrt >= n_membr_ini_mean)
							FiringRate_Mean += FiringRate;

						FiringRate_periter[membrt][iter] = FiringRate;

                        if (redistort_periter == true && foveate == true) {
                            magnifier.lgn_cortex2image(FiringRate, FiringRate, nScales, nOrient);
                            magnifier.lgn_image2cortex(FiringRate, FiringRate, nScales, nOrient);
						}
					}
				}

				for(int s=0;s<nScales;++s)
					for(int o=0;o<nOrient;++o)
						FiringRate_Mean[s][o] /= static_cast<TYPE>((n_membr-n_membr_ini_mean)*nIter);


	LGN_ON.DeAlloc();
	LGN_OFF.DeAlloc();

// *** Convert data ***

		// Set cell matrix

	long unsigned int lnScales[1];

	lnScales[0] = nScales;

	plhs[0] = mxCreateCellArray(1,lnScales);


	IMG<TYPE> *pTmpImg;

	pTmpImg = new IMG<TYPE> [nOrient];

	for(int s=0;s<nScales;++s)
	{

			// Copy  T_MULTIRES<> format to IMG array

		for(int o=0;o<nOrient;++o)
			pTmpImg[o] = FiringRate_Mean[s][o] ;

			// Copy IMG array to Cell matrix

		mxSetCell(plhs[0],s,IMAGE2Matlab(pTmpImg,nOrient));


	}

	delete [] pTmpImg;	// delete allocated data

	long unsigned int lndims5[1];
	lndims5[0] = nScales;

	long unsigned int lndims6[2];
	lndims6[0] = nIter;
	lndims6[1] = nScales;

	long unsigned int lndims7[3];
	lndims7[0] = n_membr;
	lndims7[1] = nIter;
	lndims7[2] = nScales;

	plhs[1] = mxCreateCellArray(3,lndims7);

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
					pTmpImg2[o] = FiringRate_periter[membrt][iter][s][o];
				}
				mxSetCell(cell_scales,s,IMAGE2Matlab(pTmpImg2,nOrient));
			}
			mxSetCell(cell_iter,iter,cell_scales);
		}
		mxSetCell(plhs[1],membrt,cell_iter);


	}
    delete [] pTmpImg2;

// **********************************************************



}
