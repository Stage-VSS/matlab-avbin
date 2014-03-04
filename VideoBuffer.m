classdef VideoBuffer < handle
    
    properties (SetAccess = private)
        count
    end
    
    properties (Access = private)
        images
        timestamps
    end
    
    methods
        
        function c = get.count(obj)
            c = length(obj.timestamps);
        end
        
        function add(obj, img, timestamp)
            if isempty(obj.images)
                obj.images = img;
            else
                obj.images(:, :, :, end + 1) = img;
            end
            obj.timestamps(end + 1) = timestamp;
        end
        
        function [img, timestamp] = peek(obj)
            if obj.count == 0
                error('Buffer empty');
            end
            
            img = obj.images(:, :, :, 1);
            timestamp = obj.timestamps(1);
        end
        
        function [img, timestamp] = remove(obj)
            [img, timestamp] = obj.peek();
            
            obj.images(:, :, :, 1) = [];
            obj.timestamps(1) = [];
        end
        
        function clear(obj)
            obj.images = [];
            obj.timestamps = [];
        end
        
    end
    
end

