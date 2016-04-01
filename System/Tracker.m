classdef Tracker<handle
    properties
        index = 1;
        oldPos = -1;
        avg = 1;
        sum = 0;
        windowSize = 4;
        
        imgHeigh = 2050;
        imgWidth = 2448;
    end
    methods (Static)
       function distance = estimateDistance(height)
            
         %  distance to object (mm) = focal length (mm) * real height of the object (mm) * image height (pixels)
         %                            ---------------------------------------------------------------------------
         %                                      object height (pixels) * sensor height (mm) 
            imgHeight = 2050;
            realHeight = 2; % height in meters
            focalLength = 12e-3; %focal length of camera in meters, 12mm
            objHeight = height/2;
            sensorHeight = 3.45e-6 * 2050; % 2/3 inch
            distance = (focalLength * realHeight * imgHeight)/(objHeight*sensorHeight);
            
        end 
    end
    methods
        % this method is for a cummulative moving average      
        function r = movingAvg(this, newPos) 
            
            %if there is an old position registered
            if this.oldPos ~= -1   
                % sum the change of position of detection from previoius frames
                diff = this.oldPos - newPos;   
            else
                %for the first time only
                diff = [0 0];
            end
                      
                
            if this.index < this.windowSize;
                r = -1;
            elseif this.index == this.windowSize
               this.avg = diff/this.windowSize;
               r = this.avg;
            else              
                this.avg = (diff + this.index*this.avg)/(this.index+1);
                r = this.avg;
            end
            
            % increment moving average index    
            this.index = this.index + 1;
            % save the passed in position into old position
            this.oldPos = newPos;         
            
        end
        
        % This method estimates the relative heading of the target aircraft
%          function r = heading(this, heading)
%              avg = this.avg;
%              pos = this.oldPos;
%              % Get difference between midpoint of image and target position
%              change = (this.imgWidth/2) - pos(1);
%              r = 1;
%          end
    end
    
end