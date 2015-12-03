
subnums;
for i=1:8
    filein = ['cam3_0' num2str(i) '.srt'];
    fileout = ['Detailed/cam3_0' num2str(i) '.srt'];
    mod_srt3(filein, fileout, ptp_time_fix, distance,azimuth,elevation,yzv_pitch,yzv_roll,yzv_hdg,yzv_alt,yzv_alt,yzv_time_fix);
end %if

%(filein, fileout, Own_GpsTime, Distance,Azimuth,Elevation,pitch,roll,hdg,alt,agl)