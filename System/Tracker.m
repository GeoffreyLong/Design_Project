classdef Tracker<handle
    properties
        index = 1;
        oldPos = -1;
        avg = 1;
        sum = 0;
        windowSize = 4;
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
    end
    
end