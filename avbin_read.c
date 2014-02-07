#include <mex.h>
#include "avbin.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    AVbinFile *file;
    AVbinPacket packet;
    AVbinResult result;
    mxArray *data;
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
    
    data = mxCreateNumericMatrix(0, 0, mxUINT8_CLASS, mxREAL);
    mxSetPr(data, packet.data);
    mxSetM(data, packet.size);
    mxSetN(data, 1);
    
    packetStruct = mxCreateStructMatrix(1, 1, sizeof(fieldNames) / sizeof(fieldNames[0]), fieldNames);
    mxSetField(packetStruct, 0, "timestamp", mxCreateDoubleScalar(packet.timestamp));
    mxSetField(packetStruct, 0, "stream_index", mxCreateDoubleScalar(packet.stream_index));
    mxSetField(packetStruct, 0, "data", data);
    mxSetField(packetStruct, 0, "size", mxCreateDoubleScalar(packet.size));
    
    plhs[0] = packetStruct;
}