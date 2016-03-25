fileName = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/cam3_05.avi.dat';

try
    rect = csvread(fileName);
    rect = arrayfun(@(x) ceil(x), rect);
    csvwrite(fileName, rect);
    disp(fileName);

catch
    printString = sprintf('No file found by name "%s"', fileName);
    display(printString)
    rect = zeros(1,5);
end