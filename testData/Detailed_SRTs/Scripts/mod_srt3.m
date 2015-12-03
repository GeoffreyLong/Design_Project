function num=mod_srt3(filein, fileout, PTP_GpsTime, Distance,Azimuth,Elevation,pitch,roll,hdg,alt,agl,YZV_GpsTime)

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
index = 1;
while feof(read)~=1
    % read in relevent data and write the unchanged lines in the new file
    num(index) = fscanf(read,'%d\n',1);
    %there's some weirdness with the srt files...it seems that it writes 1000 miliseconds instead of 1 second
    t_temp = fscanf(read,'%02d:%02d:%02d,%d --> %02d:%02d:%02d,%d');
    times(index,:) = t_temp';   % we need to transpose here since t_temp is read into a column vector
    if(times(index,4) == 1000)
        times(index,3)=times(index,3) + 1;
        times(index,4) = 0;
    end %if
    if (times(index,8) == 1000)
        times(index,7) = times(index,7) + 1;
        times(index,8) = 0;
    end %if
    gpstime(index) = fscanf(read,'GPS Time :%f\n\n');
    index=index+1;
end %while


% when attempting to read and write, line by line, the interpolation operations below appear to really slow down the progress, 
% so, as a workaround we'll read the whole file, and build up matrices of values, and then re-write the file
    

disp('File read completed....woring on interpolation')


    %do the interpolation as vectors
    dist_val = interp1(PTP_GpsTime,Distance,gpstime);
    az_value = interp1(PTP_GpsTime,Azimuth,gpstime);
    el_value = interp1(PTP_GpsTime,Elevation,gpstime);
    alt_value = interp1(YZV_GpsTime,alt,gpstime);
    agl_value = interp1(YZV_GpsTime,agl,gpstime);
    pitch_value = interp1(YZV_GpsTime,pitch,gpstime);
    roll_value = interp1(YZV_GpsTime,roll,gpstime);
    hdg_value = interp1(YZV_GpsTime,hdg,gpstime);
    
disp('Interpolation complete...working on writing new file')

for i=1:length(num)
    fprintf(write,'%d\n',num(i));
    fprintf(write,'%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d\n',times(i,1),times(i,2),times(i,3),times(i,4),times(i,5),times(i,6),times(i,7),times(i,8));    
    % print the last few lines with the new data
    fprintf(write,'GPS Time :%.3f Frame #: %d Elapsed Time %02d:%02d:%02d,%03d \n',gpstime(i),num(i),times(i,1),times(i,2),times(i,3),times(i,4));
    fprintf(write,'Target-> Azimuth : %.1f (deg) Elevation : %.1f (deg) Distance:%.0f (ft), %.3f (nm)\n',az_value(i),el_value(i),dist_val(i),dist_val(i)*0.000164578834);
    fprintf(write,'Host -> Pitch : %.1f (deg) Roll : %.1f (deg) Hdg : %.1f\n',pitch_value(i),roll_value(i),hdg_value(i));
    fprintf(write,'Host -> Altitude (gps) %.1f (ft) Altitude (AGL) %.1f (ft)\n\n',alt_value(i),agl_value(i));
end

fclose(read);
fclose(write);
