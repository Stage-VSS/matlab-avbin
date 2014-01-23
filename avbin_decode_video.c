#include <mex.h>
#include "avbin.h"

mxArray* toMatrix(uint8_t *array, size_t size)
{
    mxArray *matrix;
    uint8_t *pointer;
    mwSize i;
    
    matrix = mxCreateNumericMatrix(1, size, mxUINT8_CLASS, mxREAL);
    pointer = mxGetData(matrix);
    for (i = 0; i < size; i++)
    {
        pointer[i] = array[i];
    }
    
    return matrix;
}

uint8_t *toArray(mxArray *matrix)
{
    uint8_t *pointer;
    uint8_t *array;
    size_t size;
    int i;
    
    pointer = mxGetData(matrix);
    size = mxGetN(matrix);
    array = malloc(size * sizeof(uint8_t));
    
    for (i = 0; i < size; i++)
    {
        array[i] = pointer[i];
    }
    
    return array;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    AVbinStream *stream;
    uint8_t *data_in;
    size_t size_in;
    int width;
    int height;
    uint8_t *data_out;
    int32_t size_used;
    
    if (nrhs != 4)
    {
        mexErrMsgIdAndTxt("avbin:usage", "Usage: data = avbin_decode_video(stream, data, width, height)");        
        return;
    }
    
    stream = (AVbinStream *)*((uint64_t *)mxGetData(prhs[0]));
    data_in = toArray((mxArray *)prhs[1]);
    width = mxGetScalar(prhs[2]);
    height = mxGetScalar(prhs[3]);
    
    size_in = mxGetN(prhs[1]) * sizeof(data_in[0]);
    data_out = malloc(width * height * 3 * sizeof(uint8_t));
    
    size_used = avbin_decode_video(stream, data_in, size_in, data_out);
    if (size_used == -1)
    {
        free(data_in);
        free(data_out);
        mexErrMsgIdAndTxt("avbin:failed", "An error occurred");        
        return;
    }
    
    plhs[0] = toMatrix(data_out, width * height * 3);
    
    free(data_in);
    free(data_out);
}