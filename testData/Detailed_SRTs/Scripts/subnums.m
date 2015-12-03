distance =sqrt((yzv_utmx_ln200_ptime-ptp_utmx_hg1700).^2 + (yzv_utmy_ln200_ptime - ptp_utmy_hg1700).^2)*3.2808399;

yzv_hdg_ptime = interp1(yzv_time_fix,yzv_hdg,ptp_time_fix);
%new calc at azimuth
azimuth2 = 180/pi*atan2((ptp_utmx_hg1700-yzv_utmx_ln200_ptime),(ptp_utmy_hg1700 - yzv_utmy_ln200_ptime)); %relative to north
azimuth = azimuth2 - yzv_hdg_ptime;
azimuth = azimuth - 360*(azimuth>180);

elevation = 180/pi*atan((ptp_alt - yzv_alt_ln200_ptime)./distance); %elevation angle from b205 to harvard