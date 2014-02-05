#include <mex.h>
#include "avbin.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    AVbinOptions options;
    AVbinResult result;
    
    if (nrhs != 0)
    {
        mexErrMsgIdAndTxt("avbin:usage", "Usage: avbin_init()");        
        return;
    }
    
    options.structure_size = sizeof(options);
    options.thread_count = 0;
    
    result = avbin_init_options(&options);
    if (result == AVBIN_RESULT_ERROR)
    {
        mexErrMsgIdAndTxt("avbin:failed", "An error occurred");        
        return;
    }
}