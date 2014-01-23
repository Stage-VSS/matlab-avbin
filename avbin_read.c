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

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    AVbinFile *file;
    AVbinPacket packet;
    AVbinResult result;
    const char *fieldNames[] = {"timestamp", "stream_index", "data", "size"};
    mxArray *packetStruct;
    
    if (nrhs != 1)
    {
        mexErrMsgIdAndTxt("avbin:usage", "Usage: packet = avbin_read(file)");        
        return;
    }
    
    file = (AVbinFile *)*((uint64_t *)mxGetData(prhs[0]));
    
    packet.structure_size = sizeof(packet);
    
    result = avbin_read(file, &packet);
    if (result == AVBIN_RESULT_ERROR)
    {
        mexErrMsgIdAndTxt("avbin:failed", "An error occurred");        
        return;
    }
    
    packetStruct = mxCreateStructMatrix(1, 1, sizeof(fieldNames) / sizeof(fieldNames[0]), fieldNames);
    mxSetField(packetStruct, 0, "timestamp", mxCreateDoubleScalar(packet.timestamp));
    mxSetField(packetStruct, 0, "stream_index", mxCreateDoubleScalar(packet.stream_index));
    mxSetField(packetStruct, 0, "data", toMatrix(packet.data, packet.size));
    mxSetField(packetStruct, 0, "size", mxCreateDoubleScalar(packet.size));
    
    plhs[0] = packetStruct;
}