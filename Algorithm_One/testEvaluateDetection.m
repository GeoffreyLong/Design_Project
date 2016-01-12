
filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/Feb_13_cam1_5.avi';
readRect = readrectxml(filePath);


%%%%%%% CASE ONE %%%%%%%
% Test on real data, but simply feed in the same rect to both
nDetections = size(readRect,1);
[nTrueDetections, nFalsePositives, nFalseNegatives] = evaluatedetection(readRect, readRect);
assert(isequaln(nDetections,nTrueDetections), 'Case One Failed: True Detections');
assert(isequaln(0, nFalsePositives), 'Case One Failed: False Positives');
assert(isequaln(0, nFalseNegatives), 'Case One Failed: False Negatives');



%%%%%%% CASE TWO %%%%%%%
trueRect = zeros(5,5);
testRect = zeros(5,5);

% Average on the scales
trueRect(1,:) = [1 50 50 15 15];
testRect(1,:) = [1 50 50 13 13];

% Average one scale
trueRect(2,:) = [2 50 50 70 15];
testRect(2,:) = [2 50 50 60 15];

% Average location
trueRect(3,:) = [3 45 55 15 15];
testRect(3,:) = [3 51 49 13 13];

% Average both
trueRect(4,:) = [4 52 50 10 30];
testRect(4,:) = [4 50 52 14 28];

% Average with decimals
trueRect(5,:) = [5 29 60 15 29];
testRect(5,:) = [5 30 63 10 26];

[nTrueDetections, nFalsePositives, nFalseNegatives] = evaluatedetection(trueRect, testRect);
assert(isequaln(5, nTrueDetections), 'Case Two Failed: True Detections');
assert(isequaln(0, nFalsePositives), 'Case Two Failed: False Positives');
assert(isequaln(0, nFalseNegatives), 'Case Two Failed: False Negatives');


%%%%%%% CASE THREE %%%%%%%
trueRect = zeros(5,5);
testRect = zeros(5,5);

trueRect(1,:) = [1 50 50 15 15];
testRect(1,:) = [1 50 50 13 13];

trueRect(2,:) = [19 50 50 70 15];
testRect(2,:) = [19 50 50 60 15];

trueRect(3,:) = [20 45 55 15 15];
testRect(3,:) = [20 51 49 13 13];

trueRect(4,:) = [21 52 50 10 30];
testRect(4,:) = [21 50 52 14 28];

trueRect(5,:) = [27 29 60 15 29];
testRect(5,:) = [27 30 63 10 26];


[nTrueDetections, nFalsePositives, nFalseNegatives] = evaluatedetection(trueRect, testRect);
assert(isequaln(5, nTrueDetections), 'Case Three Failed: True Detections');
assert(isequaln(0, nFalsePositives), 'Case Three Failed: False Positives');
assert(isequaln(0, nFalseNegatives), 'Case Three Failed: False Negatives');


%%%%%%% CASE FOUR %%%%%%%
trueRect = zeros(5,5);
testRect = zeros(5,5);

trueRect(1,:) = [1 20 25 15 15];
testRect(1,:) = [1 50 50 13 13];

trueRect(2,:) = [1 100 25 15 15];
testRect(2,:) = [1 50 25 15 15];

trueRect(3,:) = [2 100 25 10 15];
testRect(3,:) = [2 50 50 13 13];

trueRect(4,:) = [3 1 1 15 15];
testRect(4,:) = [3 80 50 13 13];

trueRect(5,:) = [3 180 25 15 15];
testRect(5,:) = [3 100 120 13 13];

[nTrueDetections, nFalsePositives, nFalseNegatives] = evaluatedetection(trueRect, testRect);
assert(isequaln(0, nTrueDetections), 'Case Four Failed: True Detections');
assert(isequaln(5, nFalsePositives), 'Case Four Failed: False Positives');
assert(isequaln(5, nFalseNegatives), 'Case Four Failed: False Negatives');



%%%%%%% CASE FIVE %%%%%%%
trueRect = zeros(5,5);
testRect = zeros(5,5);

trueRect(1,:) = [1 20 25 15 15];
testRect(1,:) = [2 50 50 13 13];

trueRect(2,:) = [2 50 54 15 15];
testRect(2,:) = [2 100 25 15 15];

trueRect(3,:) = [2 100 25 10 15];
testRect(3,:) = [3 100 120 13 13];

trueRect(4,:) = [3 1 1 15 15];
testRect(4,:) = [3 80 50 50 48];

trueRect(5,:) = [3 180 25 15 15];
testRect(5,:) = [3 76 50 50 40];

[nTrueDetections, nFalsePositives, nFalseNegatives] = evaluatedetection(trueRect, testRect);
assert(isequaln(2, nTrueDetections), 'Case Five Failed: True Detections');
assert(isequaln(3, nFalsePositives), 'Case Five Failed: False Positives');
assert(isequaln(3, nFalseNegatives), 'Case Five Failed: False Negatives');

