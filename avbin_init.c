#include <mex.h>
#include "avbin.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    AVbinResult result;
    
    if (nrhs != 0)
    {
        mexErrMsgIdAndTxt("avbin:usage", "Usage: avbin_init()");        
        return;
    }
    
    result = avbin_init();
    if (result == AVBIN_RESULT_ERROR)
    {
        mexErrMsgIdAndTxt("avbin:failed", "An error occurred");        
        return;
    }
}