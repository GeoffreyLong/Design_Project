function num=mod_srt2(filein, fileout, PTP_GpsTime, Distance,Azimuth,Elevation,pitch,roll,hdg,alt,agl,YZV_GpsTime)

FPS=15;
FTOK = 0.000164578834;
ERAD = 20925524.97; %radius of earth, in feet
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
    
    % when attempting to read and write, line by line, the interpolation operations below appear to really slow down the progress, 
    % so, as a workaround we'll read the whole file, and build up matrices of values, and then re-write the file
    
    
    fprintf(write,'%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d\n',times);
    gpstime = fscanf(read,'GPS Time :%f\n\n');
    
    dist_val = interp1(PTP_GpsTime,Distance,gpstime);
    az_value = interp1(PTP_GpsTime,Azimuth,gpstime);
    el_value = interp1(PTP_GpsTime,Elevation,gpstime);
    alt_value = interp1(YZV_GpsTime,alt,gpstime);
    agl_value = interp1(YZV_GpsTime,agl,gpstime);
    pitch_value = interp1(YZV_GpsTime,pitch,gpstime);
    roll_value = interp1(YZV_GpsTime,roll,gpstime);
    hdg_value = interp1(YZV_GpsTime,hdg,gpstime);
    
    % print the last few lines with the new data
    fprintf(write,'GPS Time :%.3f Frame #: %d Elapsed Time %02d:%02d:%02d,%03d \n',gpstime,num,times(1),times(2),times(3),times(4));
    fprintf(write,'Target-> Azimuth : %.1f (deg) Elevation : %.1f (deg) Distance:%.0f (ft), %.3f (nm)\n',az_value,el_value,dist_val,dist_val*0.000164578834);
    fprintf(write,'Host -> Pitch : %.1f (deg) Roll : %.1f (deg) Hdg : %.1f\n',pitch_value,roll_value,hdg_value);
    fprintf(write,'Host -> Altitude (gps) %.1f (ft) Altitude (AGL) %.1f (ft)\n\n',alt_value,agl_value);
    %fprintf(write,'GPS Tme :%.3f\nDistance (nm) :%.3f Bearing :%.3f Elevation :%.3f\n\n',gpstime, 1.2, 1.3, 1.4);
end

fclose(read);
fclose(write);
