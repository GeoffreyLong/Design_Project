function num=mod_srt(filein, fileout, Own_GpsTime, Distance,Azimuth,Elevation)

FPS=15; %frames per second
FTOK = 0.000164578834;  %feet to nautical miles

read = fopen(filein, 'r');
write = fopen(fileout, 'w+');
num = 0;
oindex = 1;
hindex = 1;
disp('=====================================');
disp(['Now working on file: ' filein]);
disp(['Creating file: ' fileout]);
while feof(read)~=1
    % read in relevent data and write the unchanged lines in the new file
    num = fscanf(read,'%d\n',1);
    fprintf(write,'%d\n',num);
    %there's some weirdness with the srt files...it seems that it writes 1000 miliseconds instead of 1 second
    times =fscanf(read,'%02d:%02d:%02d,%d --> %02d:%02d:%02d,%d');
    if(times(4) == 1000)
        times(3)=times(3) + 1;
        times(4) = 0;
    end %if
    if (times(8) == 1000)
        times(7) = times(7) + 1;
        times(8) = 0;
    end %if
    
    fprintf(write,'%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d\n',times);
    gpstime = fscanf(read,'GPS Time :%f\n\n');
    
    dist_val = interp1(Own_GpsTime,Distance,gpstime);
    az_value = interp1(Own_GpsTime,Azimuth,gpstime);
    el_value = interp1(Own_GpsTime,Elevation,gpstime);
    
    % print the last few lines with the new data
    fprintf(write,'GPS Time :%.3f\nDistance:%.0f (ft), %.3f (nm)  \n',gpstime,dist_val,dist_val*FTOK);
    fprintf(write,'Azimuth : %.1f (deg) Elevation : %.1f (deg)\n\n',az_value,el_value);
    
    %fprintf(write,'GPS Tme :%.3f\nDistance (nm) :%.3f Bearing :%.3f Elevation :%.3f\n\n',gpstime, 1.2, 1.3, 1.4);
end

fclose(read);
fclose(write);
