% This is first version of find the stalk profile after impact 
% using bwcoundaries function in MATLAB
% Subtract the background by using a reference image
% The logic is modified;

clear all; close all; clc;

format shortg
c = clock;
disp(c);

currentDate = 20200109;
% 20200107 is blank
currentNdl = input('currentNdl: ');
currentHight = input('currentHight:  ');
currentRun = input('currentRun:  ');



ext = '.bmp';
ext_out = '_test.txt';
extlevel_out = '.txt';

levelDir = 'C:\Users\lab-admin\Desktop\Lichen_Wu\movies_leveled\';
level_out = strcat(levelDir,'level',extlevel_out);

% ref_index = input('reference image (ref_index =?):  ');

prefix_1 = 'C:\Users\lab-admin\Desktop\Lichen_Wu\movies_processed\';
prefix_14 = num2str(currentDate);
prefix_15 = '_ndl';
prefix_10 = num2str(currentNdl);
prefix_11 = '_hgt';
prefix_6 = num2str(currentHight);
prefix_7 ='_r';
prefix_2 = num2str(currentRun);
prefix_3 =strcat('\',num2str(currentDate),'_ndl');
prefix_12 = num2str(currentNdl);
prefix_13 = '_ht';
prefix_8 =num2str(currentHight);
prefix_9 ='_r';
prefix_4 =num2str(currentRun);
prefix_5= '_';

prefix = strcat(prefix_1,prefix_14,prefix_15,prefix_10,prefix_11,prefix_6,...
    prefix_7,prefix_2,prefix_3,prefix_12,prefix_13,prefix_8,prefix_9,prefix_4,prefix_5);
disp(prefix);

ref_index = -2500;
ref_file = strcat(prefix,num2str(ref_index, '%05g'),ext);



while exist(ref_file,'file')==0
    ref_index = ref_index + 1;
    prefix = strcat(prefix_1,prefix_14,prefix_15,prefix_10,prefix_11,prefix_6,...
        prefix_7,prefix_2,prefix_3,prefix_12,prefix_13,prefix_8,prefix_9,prefix_4,prefix_5);
    ref_file = strcat(prefix,num2str(ref_index, '%05g'),ext);
end

% FirstIm = input('Please enter the number of first image of stalk (FirstIm =?):  ');
% FirstIm = ref_index + 40;
% FirstIm = ref_index + 53;
FirstIm = ref_index + 40;







% prefix = '../movies_processed/20200108_ndl18_hgt7_r3/20200108_ndl18_ht7_r3_';


% load the image before the drop impact in the movie as the background reference 
%ref_a = imread(strcat(prefix,num2str(7057, '%04g'),ext),'bmp');

%Impact_location, read form the flat image using Vision research software
%x1 and x2 read from flat surface (ref_a) in figure (1) from top in image

%%for ndl14_ht4_r1
%ref_a = imread(strcat(prefix,num2str(-0876, '%05g'),ext),'bmp'); 
%Impact_location = 1300; %Read flat surface, estimate the impact postion from the movie
%  %for images_2020feb24/ndl14_h4_r1_-0876.bmp
%  x1 = 1089;
%  x2 = 1084;

% ndl18_ht0_r3
ref_a = imread(strcat(prefix,num2str(ref_index, '%05g'),ext),'bmp'); 
% Impact_location = 1525; 
Impact_location = 1225; 
% Impact_location = 1127; 
% Impact_location = 1081;
% Impact_location = 969;
% Impact_location = 1380;
% Impact_location = 1433; 
% Impact_location = 1297; 



%x1=1082; 
%x2 = 1075; 

y2 = Impact_location+500;
y1 = Impact_location-500;

figure(1);
set(gcf,'WindowState','maximized')

plot(smooth(double((ref_a(:, Impact_location-500)))),'r');
hold on
plot(smooth(double((ref_a(:, Impact_location+500)))), 'g');
hold off
disp('Stretch figure 1 horizontally for a better resolution..... ')
disp('Click on the middle pick in red line once: ?')
[x1,y1g] = ginput(1);
disp(' ... ')
disp('Click on the middle pick in green line once: ?')
[x2,y2g] = ginput(1);
% disp('Save the values of x1 and x2 in this program for our record.... !')

fid = fopen(level_out,'a');
fprintf(fid, '%d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %8.2f\n',...
    [currentDate;currentNdl;currentHight;currentRun;c(1);c(2);c(3);c(4);c(5);c(6);x1;x2]); 
fclose(fid);

figure(2); imshow(ref_a);
hold on
plot([y1 y2], [x1 x2], 'r')
hold off

alpha = atan((x2-x1)/(y2-y1)); % the angle of falt surface in the image


go_on = 'Y';
i= 0;

%EndIm = input('Please enter the number of the last image of stalk (EndIm =?):  ');

while go_on == 'Y' | go_on == 'y'
    
    

   ii = FirstIm+i;
%    disp('The present image number: ')
%    ii
  
   filename = strcat(prefix, num2str(ii, '%05g'),ext);
  %  filename = 'zoom60_f2.8_testpic1.bmp';
  
  if(exist(filename)==0)
      fprintf('%d have been profiled.\n',ii - FirstIm);
      disp('----------------------------------');
      diary Impact_stalk_diary
      break
  end
    a = imread(filename, 'bmp');

    a0 =ref_a-a; %subtract the background
    a0_max = double(max(max(a0)))/256.0;
   % a1 = imadjust(a0, [0.2 0.7], [0 1]);
    a1 = imadjust(a0, [0.01 a0_max], [0 1]); %for a better contrast
    %BW = imbinarize(a0, 'adaptive','ForegroundPolarity','dark','Sensitivity',0.7); %both a1 and a0 are okay??
    %BW = imbinarize(a0, 'adaptive','Sensitivity',0.1); %adjust the sensitivity for a propoer contour
   % BW = imbinarize(a0); %adjust the sensitivity for a propoer contour
    BW = a0>max(max(a0))/5; %another way to convert into BW 
    [B, L]=bwboundaries(BW,'noholes');

    kk=0;
    boundary_size = zeros(1, length(B));
    for k=1:length(B)       
        boundary_size(k)= length(B{k});
        if boundary_size(k) >200 %count boundaries with points greater than 200
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
    plt=plot([y1 y2], [x1 x2], 'm', 'LineWidth', 2);

    hold off

    % redo = 'Y';
    % lp=1;  
    % while redo == 'Y' | redo == 'y' 
   % default: Find the stalk profile from the longest array in B
    profl = B{K_I(1)};
    [min_x, I_min]=min(profl(:,2)); %In the horizontal direction
    [max_x, I_max]=max(profl(:,2));
    x_temp = profl(I_min:I_max, 2)';
    y_temp = profl(I_min:I_max, 1)';

    figure(4); imshow(a);
    hold on
    plot(x_temp, y_temp, 'r');
    %hold off

   % alpha = 0; %The flat surface has aero angle in image 
    profile_x = (y_temp-x1).*sin(alpha)+(x_temp-y1).*cos(alpha);
    profile_y = (y_temp-x1).*cos(alpha)-(x_temp-y1).*sin(alpha);

    plot(profile_x+y1, profile_y+x1, 'y')
    hold off

% %     redo = 'Y'; %use it when necessary
% %     lp=1;  
% %     while redo == 'Y' | redo == 'y'
% %     redo = input('Mend the curve? Y/N [N]: ', 's');
% %     %redo='';
% %       if isempty(redo)
% %           redo = 'N';
% %       end
% %       if redo == 'Y' || redo == 'y'
% %           clear profile_x profile_y;
% %         disp(' ...Pick boundaries, in Fig.3. Add space between numbers if more than 2 boundaries')
% %         prompt = 'For instance, if first and third boundaries are picked, type 1 3?   ';
% %         loops = input(prompt, 's');
% %         lp = str2num(loops);
% %         clear x_temp y_temp;
% %         x_temp = [];
% %         y_temp = [];
% %         
% %         for k2 = 1:length(lp)
% %             profl = B{K_I(lp(k2))};
% % %             [min_x, I_min]=min(profl(:,2)); %In the horizontal direction
% % %             [max_x, I_max]=max(profl(:,2));
% %             x_temp = [x_temp profl(:, 2)'];
% %             y_temp = [y_temp profl(:, 1)'];
% %             clear profl;
% %         end
% %       end
% %       
% %         figure(4); imshow(a);
% %         hold on
% %         plot(x_temp, y_temp, 'r');
% % 
% %         % alpha = 0; %The flat surface has zero angle in image 
% %         profile_x = (y_temp-x1).*sin(alpha)+(x_temp-y1).*cos(alpha);
% %         profile_y = (y_temp-x1).*cos(alpha)-(x_temp-y1).*sin(alpha);    
% %         plot(profile_x+y1, profile_y+x1, 'y')
% %         hold off
% %     
% %     end

filename_out = strcat(prefix, num2str(ii, '%05g'),ext_out);
fid = fopen(filename_out,'w');
fprintf(fid, '%8.2f \t %8.2f\n',[profile_x; -profile_y]); %relative to flat surface
fclose(fid);
clear profile_x profile_y

% go_on = input('Continue to process NEXT image? Y/N [Y]: ','s');
%go_on ='';
    if isempty(go_on)
        go_on = 'Y';
    end
    i = i+1;
    

end












