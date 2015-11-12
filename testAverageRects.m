%%%%%%% CASE ONE %%%%%%%
% This case only has single averaging
rect1 = zeros(5,5);
rect2 = zeros(5,5);
expRect = zeros(5,5);

% Average on the scales
rect1(1,:) = [1 50 50 15 15];
rect2(1,:) = [1 50 50 13 13];
expRect(1,:) = [1 50 50 14 14];

% Average one scale
rect1(2,:) = [2 50 50 70 15];
rect2(2,:) = [2 50 50 60 15];
expRect(2,:) = [2 50 50 65 15];

% Average location
rect1(3,:) = [3 45 55 15 15];
rect2(3,:) = [3 51 49 13 13];
expRect(3,:) = [3 48 52 14 14];

% Average both
rect1(4,:) = [4 52 50 10 30];
rect2(4,:) = [4 50 52 14 28];
expRect(4,:) = [4 51 51 12 29];

% Average with decimals
rect1(5,:) = [5 29 60 15 29];
rect2(5,:) = [5 30 63 10 26];
expRect(5,:) = [5 30 62 13 28];

rect = averagerects(rect1,rect2)

% Expected return values
assert(isequaln(rect,expRect), 'Case One Failed');



%%%%%%% CASE TWO %%%%%%%
% This case has Random Indexing
rect1 = zeros(5,5);
rect2 = zeros(5,5);
expRect = zeros(5,5);

% Average on the scales
rect1(1,:) = [1 50 50 15 15];
rect2(1,:) = [1 50 50 13 13];
expRect(1,:) = [1 50 50 14 14];

% Average one scale
rect1(2,:) = [19 50 50 70 15];
rect2(2,:) = [19 50 50 60 15];
expRect(2,:) = [19 50 50 65 15];

% Average location
rect1(3,:) = [20 45 55 15 15];
rect2(3,:) = [20 51 49 13 13];
expRect(3,:) = [20 48 52 14 14];

% Average both
rect1(4,:) = [21 52 50 10 30];
rect2(4,:) = [21 50 52 14 28];
expRect(4,:) = [21 51 51 12 29];

% Average with decimals
rect1(5,:) = [27 29 60 15 29];
rect2(5,:) = [27 30 63 10 26];
expRect(5,:) = [27 30 62 13 28];

rect = averagerects(rect1,rect2);

% Expected return values
assert(isequaln(rect,expRect), 'Case Two Failed');





%%%%%%% CASE THREE %%%%%%%
% This case has multiple frames but no averaging
rect1 = zeros(5,5);
rect2 = zeros(5,5);
expRect = zeros(10,5);

rect1(1,:) = [1 20 25 15 15];
rect2(1,:) = [1 50 50 13 13];
expRect(1,:) = [1 20 25 15 15];
expRect(2,:) = [1 50 50 13 13];

rect1(2,:) = [1 100 25 15 15];
rect2(2,:) = [1 50 25 15 15];
expRect(3,:) = [1 100 25 15 15];
expRect(4,:) = [1 50 25 15 15];

rect1(3,:) = [2 100 25 10 15];
rect2(3,:) = [2 50 50 13 13];
expRect(5,:) = [2 100 25 10 15];
expRect(6,:) = [2 50 50 13 13];

rect1(4,:) = [3 1 1 15 15];
rect2(4,:) = [3 80 50 13 13];
expRect(7,:) = [3 1 1 15 15];
expRect(8,:) = [3 80 50 13 13];

rect1(5,:) = [3 180 25 15 15];
rect2(5,:) = [3 100 120 13 13];
expRect(9,:) = [3 180 25 15 15];
expRect(10,:) = [3 100 120 13 13];

expRect = sortrows(expRect)
rect = averagerects(rect1,rect2)

% Expected return values
assert(isequaln(rect,expRect), 'Case Three Failed');






%TODO 
% Tests for acyclic matching
% Tests for average + multi

%TODO FINISH

%%%%%%% CASE FOUR %%%%%%%
% This case has acyclic averaging NOT FINISHED
rect1 = zeros(5,5);
rect2 = zeros(5,5);
expRect = zeros(10,5);

rect1(1,:) = [1 20 25 15 15];
rect2(1,:) = [2 50 50 13 13];
expRect(1,:) = [1 20 25 15 15];
expRect(2,:) = [2 50 50 13 13];

rect1(2,:) = [2 100 25 15 15];
rect2(2,:) = [3 50 25 15 15];
expRect(3,:) = [1 100 25 15 15];
expRect(4,:) = [1 50 25 15 15];

rect1(3,:) = [2 100 25 10 15];
rect2(3,:) = [2 50 50 13 13];
expRect(5,:) = [2 100 25 10 15];
expRect(6,:) = [2 50 50 13 13];

rect1(4,:) = [3 1 1 15 15];
rect2(4,:) = [3 80 50 13 13];
expRect(7,:) = [3 1 1 15 15];
expRect(8,:) = [3 90 50 13 13];

rect1(5,:) = [3 180 25 15 15];
rect2(5,:) = [3 100 120 13 13];
expRect(9,:) = [3 180 25 15 15];
expRect(10,:) = [3 100 120 13 13];

expRect = sortrows(expRect)
rect = averagerects(rect1,rect2)

% Expected return values
assert(isequaln(rect,expRect), 'Case Four Failed');



