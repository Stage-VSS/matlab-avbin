classdef VideoPlayer < handle
    
    properties (SetAccess = private)
        source
        isPlaying
    end
    
    properties (Access = private)
        start
        previousImage
    end
    
    methods
        
        function obj = VideoPlayer(source)
            obj.source = source;
            obj.previousImage = {[], []};
        end
        
        % Begins playing the current source.
        function play(obj)
            if obj.isPlaying
                return;
            end
            
            obj.start = tic;
        end
        
        function tf = get.isPlaying(obj)
            tf = ~isempty(obj.start);
        end
        
        % Gets an image of the current video frame.
        function img = getImage(obj)
            img = [];
            
            if ~obj.isPlaying
                return;
            end
            
            position = toc(obj.start) * 1e6;
            if ~isempty(obj.previousImage{2}) && position <= obj.previousImage{2}
                img = obj.previousImage{1};
                return;
            end
                        
            [img, timestamp] = obj.source.getImage(position);
            obj.previousImage = {img, timestamp};
        end
        
    end
    
end

