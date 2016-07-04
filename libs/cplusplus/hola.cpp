/*
TO COMPILE THIS MEX FILE, WRITE THE COMMAND "mex hola.cpp" 
THEN, A .mexa64 FILE WILL BE GENERATED, WILL BE ABLE TO USE IT
AS A FUNCTION THAT EXECUTES THE "mexFunction"
*/

#include <iostream>
#include "mex.h"

using namespace std;

void print_hola() {

    cout << "Hola Mundo" << endl;


}

/* The gateway function or main */

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

    print_hola();

}



