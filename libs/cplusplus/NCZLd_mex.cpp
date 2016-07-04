#include "multires.hpp"
#include "image.hpp"
#include "util.hpp"

#include "V1.hpp"


#include <matrix.h>
#include <math.h>
#include "conversion.hpp"



/******************************************************************


[w_out]=NCZLd_mex(w_in, nScales)

 	Parameters:
		- w_in: Input multiresolution coefficients (1 channel, i.e. non-color)

				Cell array being (Laplacian Pyramid)
               w{s}(:,:,1): i-th wavelet plane, horizontal details
               w{s}(:,:,2): i-th wavelet plane, vertical details
               w{s}(:,:,3): i-th wavelet plane, diagonal details

               where 's' is the spatial scale

		- nScales: number of wavelet planes (spatial scales)

		- w_out: The same format as w_in



 ******************************************************************/

void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
mexPrintf("Going into mex NCZLd_mex routine ... \n");

	typedef double TYPE;


//	if(nrhs<2) mexErrMsgTxt("At least two inputs required.");

	if(nrhs<1)
		mexErrMsgTxt("Too few parameters.");

	if(nrhs>1)
		mexErrMsgTxt("Too many parameters.");

	if  ( !mxIsCell(prhs[0]) )
		mexErrMsgTxt("First parameter should be a cell");


//	if(nrhs>1)
//	{
//		if (!mxIsNumeric(prhs[1]) || mxIsComplex(prhs[1]) ||
//					mxGetN(prhs[1])*mxGetM(prhs[1]) != 1 )
//		{
//
//			mexErrMsgTxt("2nd parameter must be a scalar.");
//		}
//		else
//		{
//			//  Get the scalar input cont.
//			nScales = mxGetScalar(prhs[1]);
//		}
//	}



	const int nScales = mxGetNumberOfElements(prhs[0]);
mexPrintf("mexPrintf: nScales : %d\n",nScales);


// *** Convert data ***

	T_MULTIRES_IMG<TYPE> vvLGN;

	const int nOrient = 3;

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



// *** Execute code ***


	ATROUS_ORIENT<IMG<TYPE>,IMG<TYPE>> ATrousOrient;

	ATrousOrient.vvW = vvLGN;

	strParam_V1<TYPE> strParam;

	strParam.strParamZLiNetwork.pMultires=&ATrousOrient;
	strParam.strParamZLiNetwork.strParamZLiExcInh.tDist = MANH_DIST;
	strParam.strParamZLiNetwork.strParamZLiExcInh.tNormalization = SCALE_NORM;
	strParam.strParamZLiNetwork.strParamZLiExcInh.min_shift = 0.;

	strParam.strParamZLiNetwork.strParamZLiExcInh.input_inh_factor = 0.01;
	strParam.output_normalization_value = 1.0;

	strParam.strParamZLiNetwork.strParamZLiExcInh.noise_stddev =0.01;
	strParam.strParamZLiNetwork.strParamZLiExcInh.bScaleDelta = true;
	strParam.strParamZLiNetwork.strParamZLiExcInh.bScaleInteraction = false;
	strParam.strParamZLiNetwork.strParamComputation.bSaveIterResults = false;
	strParam.strParamZLiNetwork.strParamComputation.tODESolvingMethod = ODE_EULER;

	const int n_membr = 10;
	strParam.strParamZLiNetwork.strParamComputation.nIterPerMembrTime = 10;

            
	const int n_mebr_ini_mean = 3;

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


	V1<TYPE> V1(strParam);

	V1.Config(&ATrousOrient.vvW);


	const int nIter = strParam.strParamZLiNetwork.strParamComputation.nIterPerMembrTime;
        std::cout << "niter=" << nIter << std::endl;
 
	T_V1_OUTPUT<TYPE> FiringRate,FiringRate_Mean;

	FiringRate_Mean = LGN_ON;

	for(int s=0;s<nScales;++s)
		for(int o=0;o<nOrient;++o)
			FiringRate_Mean[s][o]=0.;

	V1.setOutput(&FiringRate);

	FiringRate = FiringRate_Mean;


				for(int membrt=0;membrt<n_membr;++membrt)
				{
					std::cout << "\t Pos Membr time: " << membrt << std::endl;

					for(int iter=0;iter<nIter;++iter)
					{
						std::cout << "iter: " << iter << std::endl;

						V1.Solve(&LGN_ON,&LGN_OFF);

						if(membrt >= n_mebr_ini_mean)
							FiringRate_Mean += FiringRate;
					}
				}

				for(int s=0;s<nScales;++s)
					for(int o=0;o<nOrient;++o)
						FiringRate_Mean[s][o] /= static_cast<TYPE>((n_membr-n_mebr_ini_mean)*nIter);


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


// **********************************************************



}
