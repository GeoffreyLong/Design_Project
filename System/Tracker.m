classdef Tracker<handle
    properties
        index = 1;
        oldHeight = -1;
        avg = 1;
        sum = 0;
        windowSize = 4;
        
        imgHeigh = 2050;
        imgWidth = 2448;
        tempSum = 0;
        oldDistance;
        tempTime = -1;
        frameCount = 1;
        
        time1 = -1;
        dist1 = -1;
        count1 = 1;
    end
    methods (Static)
        function distance = estimateDistance(height)
            
         %  distance to object (mm) = focal length (mm) * real height of the object (mm) * image height (pixels)
         %                            ---------------------------------------------------------------------------
         %                                      object height (pixels) * sensor height (mm) 
            imgHeight = 2050;
            realHeight = 1.8; % height in meters
            focalLength = 12e-3; %focal length of camera in meters, 12mm
            objHeight = height;%/10;
%             if objHeight < 5
%                 objHeight = 2;
%             end
            sensorHeight = 3.45e-6 * 2050; % 2/3 inch
            distance = (focalLength * realHeight * imgHeight)/(objHeight*sensorHeight);
            
        end 
        
       
    end
    methods
         % Real TTC
        function time = realTTC(this, dist)
            speed = (this.dist1 - dist)*15;
            this.time1 = (dist - 152.4)/speed;               
            this.dist1 = dist;
            time = this.time1;
        end
       % Estimate TTC
       function time = estTTC(this, distance)
           
           if mod(this.frameCount, 5) == 0 
               avg = this.tempSum/5;
               this.tempSum = 0;
           else
               this.tempSum = this.tempSum + distance;
           end
           % compute ttc every 15 frames as fps = 15
           if this.frameCount == 5
               this.oldDistance = avg;          

           elseif this.frameCount == 15
               newDistance = avg;
               speed = (this.oldDistance - newDistance);
               %collision radius is 500ft = 152.5m
               this.tempTime = (newDistance - 152.4) / speed;
               this.frameCount = 0;
           end
                      
           this.frameCount = this.frameCount + 1;
           time = this.tempTime;
           
       end
        % this method is for a cummulative moving average      
        function r = movingAvg(this, newHeight) 
                 
                
            if this.index < this.windowSize;
                this.sum = this.sum + newHeight;
            elseif this.index == this.windowSize
               this.avg = this.sum/this.windowSize;
               this.sum = 0;
               this.index = 0;
            else              
%                 this.avg = (diff + this.index*this.avg)/(this.index+1);

            end
            r = this.avg;

            % increment moving average index    
            this.index = this.index + 1;
            % save the passed in position into old position
            this.oldHeight = newHeight;         
            
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