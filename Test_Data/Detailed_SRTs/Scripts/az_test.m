%original az calculation
% azimuth = 180/pi*atan2(-(yzv_utmx_ln200_ptime-ptp_utmx_hg1700),(yzv_utmy_ln200_ptime - ptp_utmy_hg1700)) - yzv_hdg_ptime;

%new calc at azimuth
azimuth2 = 180/pi*atan2((ptp_utmx_hg1700-yzv_utmx_ln200_ptime),(ptp_utmy_hg1700 - yzv_utmy_ln200_ptime)); %relative to north
azimuth = azimuth2 - yzv_hdg_ptime;

elevation = 180/pi*atan((ptp_alt - yzv_alt_ln200_ptime)./distance); %elevation angle from b205 to harvard

figure(7)
clf
number = rand(1);
some_value = floor(number*length(ptp_time_fix));
plot(0,0,'bx',ptp_utmx_hg1700(some_value)-yzv_utmx_ln200_ptime(some_value),ptp_utmy_hg1700(some_value)-yzv_utmy_ln200_ptime(some_value),'ro')
grid on
axis equal
ylabel ('Northing (m)')
xlabel('Easting (m)')
hold on
x2 = distance(some_value)*0.3048*sin(yzv_hdg_ptime(some_value)*pi/180);
x3 = distance(some_value)*0.3048*sin((yzv_hdg_ptime(some_value)+azimuth(some_value))*pi/180);
y2 = distance(some_value)*0.3048*cos(yzv_hdg_ptime(some_value)*pi/180);
y3 = distance(some_value)*0.3048*cos((yzv_hdg_ptime(some_value)+azimuth(some_value))*pi/180);

x4 = distance(some_value)*0.3048*sin(azimuth2(some_value)*pi/180);
y4 =distance(some_value)*0.3048*cos(azimuth2(some_value)*pi/180);
plot([0 x2], [0 y2],'--k',[0 x3],[0 y3],'-r',[0 x4],[0 y4],'--b')
title(['YZV hdg =' num2str(yzv_hdg_ptime(some_value)) 'calc azi=' num2str(azimuth(some_value)) 'non hdg comp azi=' num2str(azimuth2(some_value))]);
height_diff = ptp_alt(some_value)-yzv_alt_ln200_ptime(some_value)
the_dist = distance(some_value)
el=elevation(some_value)

% distance =sqrt((yzv_utmx_ln200_ptime-ptp_utmx_hg1700).^2 + (yzv_utmy_ln200_ptime - ptp_utmy_hg1700).^2)*3.2808399;
% elevation = 180/pi*atan((yzv_alt_ln200_ptime - ptp_alt)./distance); %elevation angle from b205 to harvard
% 
% yzv_hdg_ptime = interp1(yzv_time_fix,yzv_hdg,ptp_time_fix);
% azimuth = 180/pi*atan2(-(yzv_utmx_ln200_ptime-ptp_utmx_hg1700),(yzv_utmy_ln200_ptime - ptp_utmy_hg1700)) - yzv_hdg_ptime;