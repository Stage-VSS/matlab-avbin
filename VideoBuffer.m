classdef VideoBuffer < handle
    
    properties (SetAccess = private)
        count
    end
    
    properties (Access = private)
        head
        tail
        images
        timestamps
    end
    
    methods
        
        function obj = VideoBuffer()
            obj.head = 1;
            obj.tail = 1;
        end
        
        function c = get.count(obj)
            c = obj.tail - obj.head;
        end
        
        function add(obj, img, timestamp)
            if isempty(obj.images)
                obj.images = img;
            else
                obj.images(:, :, :, obj.tail) = img;
            end
            obj.timestamps(obj.tail) = timestamp;
            
            obj.tail = obj.tail + 1;
        end
        
        function [img, timestamp] = peek(obj)
            if obj.count == 0
                error('Buffer empty');
            end
            
            img = obj.images(:, :, :, obj.head);
            timestamp = obj.timestamps(obj.head);
        end
        
        function [img, timestamp] = remove(obj)
            [img, timestamp] = obj.peek();
            
            obj.head = obj.head + 1;
        end
        
        function clear(obj)
            obj.head = 1;
            obj.tail = 1;
            obj.images = [];
            obj.timestamps = [];
        end
        
    end
    
end

