#include <mex.h>
#include "avbin.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    AVbinFile *file;
    int32_t index;
    AVbinStream *stream;
    mxArray *streamAddr;
    
    if (nrhs != 2)
    {
        mexErrMsgIdAndTxt("avbin:usage", "Usage: file = avbin_open_stream(file, index)");        
        return;
    }
    
    file = (AVbinFile *)*((uint64_t *)mxGetData(prhs[0]));
    index = mxGetScalar(prhs[1]);
        
    stream = avbin_open_stream(file, index);
    
    streamAddr = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
    *((uint64_t *)mxGetData(streamAddr)) = (uint64_t)stream;
    
    plhs[0] = streamAddr;
}