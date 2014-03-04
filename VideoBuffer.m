classdef VideoBuffer < handle
    
    properties (SetAccess = private)
        count
    end
    
    properties (Access = private)
        head
        tail
        growFactor
        images
        timestamps
    end
    
    methods
        
        function obj = VideoBuffer(size, capacity)
            if nargin < 2
                capacity = 10;
            end
            
            obj.head = 1;
            obj.tail = 1;
            obj.growFactor = 4;
            
            obj.images = zeros(size(2), size(1), 3, capacity, 'uint8');
        end
        
        function c = get.count(obj)
            c = obj.tail - obj.head;
        end
        
        function add(obj, img, timestamp)
            capacity = size(obj.images, 4);
            if capacity == obj.tail
                newCapacity = size(obj.images, 4) * obj.growFactor;
                temp = zeros(size(obj.images, 1), size(obj.images, 2), size(obj.images, 3), newCapacity, class(obj.images));
                temp(:,:,:,1:capacity) = obj.images(:,:,:,1:capacity);
                obj.images = temp;
            end
            
            obj.images(:,:,:,obj.tail) = img;
            obj.timestamps(obj.tail) = timestamp;
            
            obj.tail = obj.tail + 1;
        end
        
        function [img, timestamp] = peek(obj)
            if obj.count == 0
                error('Buffer empty');
            end
            
            img = obj.images(:,:,:,obj.head);
            timestamp = obj.timestamps(obj.head);
        end
        
        function [img, timestamp] = remove(obj)
            [img, timestamp] = obj.peek();
            
            obj.head = obj.head + 1;
        end
        
    end
    
end