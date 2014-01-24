classdef AvbinVideoReader < handle
    
    properties (SetAccess = private)
        size
    end
    
    properties (Access = private)
        file
        streamIndex
        stream
    end
    
    methods
        
        function obj = AvbinVideoReader(filename)
            avbin_init();
            
            obj.file = avbin_open_filename(filename);
            
            fileInfo = avbin_file_info(obj.file);
            nStreams = fileInfo.n_streams;
            
            for i = 0:nStreams-1
                streamInfo = avbin_stream_info(obj.file, i);
                
                if streamInfo.type == 1
                    obj.streamIndex = i;
                    break;
                end
            end
            
            if isempty(obj.streamIndex)
                error('No video stream found');
            end
            
            obj.stream = avbin_open_stream(obj.file, obj.streamIndex);
            obj.size = [streamInfo.width, streamInfo.height];
        end
        
        function delete(obj)
            if obj.stream
                avbin_close_stream(obj.stream);
            end
            
            if obj.file
                avbin_close_file(obj.file);
            end
        end
        
        function seek(obj, timestamp)
            avbin_seek_file(obj.file, timestamp);
        end
        
        function frame = nextFrame(obj)
            frame = [];
         
            try
                packet = avbin_read(obj.file);
                while packet.stream_index ~= obj.streamIndex
                    packet = avbin_read(obj.file);
                end
            catch
                return;
            end
            
            while isempty(frame);
                try
                    data = avbin_decode_video(obj.stream, packet.data, obj.size(1), obj.size(2));
                catch
                    continue;
                end
            
                frame = permute(reshape(data, 3, obj.size(1), obj.size(2)), [3, 2, 1]);
            end
        end
        
    end
    
end

