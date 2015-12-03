% Loop through .png's of interest
range=input('Input range of frames of interest as [frame1 frame2]: ','s');
range=str2num(range);

% Setting this up for later image reading
screen_size = get(0,'ScreenSize');

for i=range(2):-1:range(1)
    %Open .png
    filename=sprintf('%s %s%s','../July 8 2009/Image Sequences/cam2/05/cam2_05',num2str(round(i)),'.png');
    [picture,map]=imread(filename);
    h=figure(1); set(h,'Position',[0 0 screen_size(3) screen_size(4)]);
    image(picture); colormap(map);
    
    temp = sprintf('Frame: %s. Press ENTER to exit zoom mode',num2str(round(i)));disp(temp);
    zoom on;
    waitfor(gcf,'CurrentCharacter',13); % must be "enter"
    zoom reset;
    zoom off;
    % Select pixel location
    [temp1 temp2] = ginput(1);  % Grab pixel position
    if isempty(temp1)           % Failsafe incase key is struck
        x(i-range(1)+1) = 0;
        y(i-range(1)+1) = 0; % helicopter not yet found
        t(i-range(1)+1) = i/15;
    else                        
        x(i-range(1)+1) = round(temp1);
        y(i-range(1)+1) = round(temp2);
        t(i-range(1)+1) = i/15; % in seconds from start of video
    end
    
    if ~isempty(h)
        close(h);
        h=[];
    end
end

pause;

% Prompt for name and open .txt file
output_filename = input('Type desired filename including .txt entension: ','s');
if isempty(output_filename)
    output_filename = 'temporary.txt';
end
fid=fopen(output_filename,'wt');

% Print to .txt file
disp('Printing data to text file');
for i=1:numel(x)
   fprintf(fid,'%f %f %f %f\n',t(i),round(t(i)*15),x(i),y(i));  
end
fclose(fid);
