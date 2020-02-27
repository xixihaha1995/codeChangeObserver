% This is first version of find the stalk profile after impact 
% using bwcoundaries function in MATLAB
% Subtract the background by using a reference image
% The logic is modified;

clear all; close all; clc;

%prefix = '../images/20200107_ndl14_h4_r1/ndl14_h4_r1_';
% prefix = '../movies_processed/ndl14_hgt1_r2/ndl14_ht1_r2_';
% prefix = '../movies_processed/ndl14_hgt1_r3/ndl14_ht1_r3_';
% prefix = '../movies_processed/ndl14_hgt1_r4/ndl14_ht1_r4_';
% prefix = '../movies_processed/ndl14_hgt2_r5/ndl14_ht2_r5_';
% prefix = '../movies_processed/ndl14_hgt2_r6/ndl14_ht2_r6_';
% prefix = '../movies_processed/ndl14_hgt3_r1/ndl14_ht3_r1_';
% prefix = '../movies_processed/ndl14_hgt3_r2/ndl14_ht3_r2_';
% prefix = '../movies_processed/ndl14_hgt3_r3/ndl14_ht3_r3_';
% prefix = '../movies_processed/ndl14_hgt4_r1/ndl14_ht4_r1_';
% prefix = '../movies_processed/ndl14_hgt4_r2/ndl14_ht4_r2_';
% prefix = '../movies_processed/ndl14_hgt4_r3/ndl14_ht4_r3_';
% prefix = '../movies_processed/ndl14_hgt5_r1/ndl14_ht5_r1_';
prefix = '../movies_processed/ndl14_hgt5_r3/ndl14_ht5_r3_';

ext = '.bmp';
ext_out = '.txt';

% load the first image in the movie as the background reference image 
%ref_a = imread(strcat(prefix,num2str(7057, '%04g'),ext),'bmp');
%ref_a = imread(strcat(prefix,num2str(-0876, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-1102, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0676, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0685, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0789, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0852, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0874, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0735, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0940, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0884, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0916, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0876, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0949, '%05g'),ext),'bmp');
% ref_a = imread(strcat(prefix,num2str(-0854, '%05g'),ext),'bmp');
ref_a = imread(strcat(prefix,num2str(-1066, '%05g'),ext),'bmp');


%Read flat surface, estimate the impact postion from the movie
% Impact_location = 1428;
% Impact_location = 1515;
% Impact_location = 1341;
% Impact_location = 1285;
% Impact_location = 1237;
% Impact_location = 1253;
% Impact_location = 1241;
% Impact_location = 1335;
% Impact_location = 1317;
% Impact_location = 1399;
% Impact_location = 1219;
Impact_location = 1279;


y2 = Impact_location+500;
y1 = Impact_location-500;

figure(1); %for each movie, uncomment the following lines to read x1, x2
           % from reference image
           % this block is used to determine the level line.              
plot(ref_a(:, Impact_location-500),'r')
hold on
plot(ref_a(:, Impact_location+500), 'k');
hold off
disp('Click on the middle pick in red line once: ')
[x1,y1g] = ginput(1);
disp('Click on the middle pick in green line once: ')
[x2,y2g] = ginput(1);

%  %for images_2020feb24/ndl14_h4_r1_-0876.bmp, read from the above lines
%  x1 = 1089;
%  x2 = 1084;

figure(2); imshow(ref_a);
hold on
plot([y1 y2], [x1 x2], 'r')
hold off

FirstIm = input('Please enter the number of first image of stalk (FirstIm =?):  ');
go_on = 'Y';
i= 0;

%EndIm = input('Please enter the number of the last image of stalk (EndIm =?):  ');

while go_on == 'Y' | go_on == 'y'

   ii = FirstIm+i;
   disp('The present image number: ')
   ii
%    redo = 'Y';
%    while redo == 'Y' | redo == 'y'   
   filename = strcat(prefix, num2str(ii, '%05g'),ext);
  %  filename = 'zoom60_f2.8_testpic1.bmp';
    a = imread(filename, 'bmp');
 
    a0 =ref_a-a; %subtract the background
    a0_max = double(max(max(a0)))/256.0;
   % a1 = imadjust(a0, [0.2 0.7], [0 1]);
    a1 = imadjust(a0, [0.01 a0_max], [0 1]); %for a better contrast
    BW = imbinarize(a0); %both a1 and a0 are okay??
    [B, L]=bwboundaries(BW,'noholes');

    kk=0;
    boundary_size = zeros(1, length(B));
    for k=1:length(B)       
        boundary_size(k)= length(B{k});
        if boundary_size(k) >500 %remove a boundary with points less than 100
             kk = kk+1;
        end
    end
    [K_M, K_I]=sort(boundary_size, 'descend');
        
    figure(3); imshow(a1);
    hold on
    for k1=1:kk
        boundary = B{K_I(k1)};
        plot(boundary(:,2), boundary(:,1),'r');
        text(boundary(int16(K_M(k1)/2), 2), boundary(int16(K_M(k1)/2),1), num2str(k1),'Color','green','FontSize',24);
    end 
    plot([y1 y2], [x1 x2], 'm')

    hold off
    
    profl = B{K_I(1)};
    [min_x, I_min]=min(profl(:,2));
    [max_x, I_max]=max(profl(:,2));
    profile_x = profl(I_min:I_max, 2)';
    profile_y = profl(I_min:I_max, 1)';
    
    
    figure(4); imshow(a);
    hold on
    plot(profile_x, profile_y, 'r');
    hold off
    

% redo = input('Mend the curve? Y/N [N]: ', 's');
% %redo='';
%   if isempty(redo)
%       redo = 'N';
%   end
%   if redo == 'Y' || redo == 'y'
%       clear profile_x profile_y;
%       line???? = input('Please enter a new thresh value (current value 0.1):  ');
%   end
% end

filename_out = strcat(prefix, num2str(ii, '%05g'),ext_out);
fid = fopen(filename_out,'w');
fprintf(fid, '%8.2f \t %8.2f\n',[profile_x; 1000-profile_y]);
fclose(fid);
clear profile_x profile_y

go_on = input('Continue to process NEXT image? Y/N [Y]: ','s');
%go_on ='';
    if isempty(go_on)
        go_on = 'Y';
    end
    i = i+1;

end












