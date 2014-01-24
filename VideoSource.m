classdef VideoSource < handle
    
    properties (SetAccess = private)
        size
        duration
    end
    
    properties (Access = private)
        file
        streamIndex
        stream
        bufferedImage
    end
    
    methods
        
        function obj = VideoSource(filename)
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
            obj.duration = fileInfo.duration;
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
            obj.bufferedImage = {};
        end
        
        function [img, timestamp] = getImage(obj, time)
            [img, timestamp] = obj.nextImage();
            while ~isempty(img) && timestamp < time
                [img, timestamp] = obj.nextImage();
            end
        end
        
        function [img, timestamp] = nextImage(obj)
            img = [];
            timestamp = [];
            
            if ~isempty(obj.bufferedImage)
                img = obj.bufferedImage{1};
                timestamp = obj.bufferedImage{2};
                obj.bufferedImage = {};
                return;
            end
            
            try
                packet = avbin_read(obj.file);
                while packet.stream_index ~= obj.streamIndex
                    packet = avbin_read(obj.file);
                end
            catch
                return;
            end
            
            while isempty(img);
                try
                    data = avbin_decode_video(obj.stream, packet.data, obj.size(1), obj.size(2));
                catch
                    continue;
                end
            
                img = permute(reshape(data, 3, obj.size(1), obj.size(2)), [3, 2, 1]);
                timestamp = packet.timestamp;
            end
        end
        
        function timestamp = nextTimestamp(obj)
            if ~isempty(obj.bufferedImage)
                timestamp = obj.bufferedImage{2};
            else
                [img, timestamp] = obj.nextImage();
                obj.bufferedImage = {img, timestamp};
            end
        end
        
    end
    
end