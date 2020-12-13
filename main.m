clear all;
clc;  
close all;

nums = load('ecgsample.mat');                % load data from ecgexample.mat
nums = struct2cell(nums);                    % Convert structure to cell array
nums = cell2mat(nums);                       % Convert cell array to normal matrix

i = 0; % i is the coordinate axis loop variable, set the initial value to 0

for begins = 1:100:4901                      % begin time of every window, from 1 to 4901
    ends = begins + 1100;                    % end time of every window
    x = begins:1:ends;                       % range of every x axis 
    d = nums(1,:);
    y = d(begins:ends);                      % range of every y axis 
    
    fc = [8 30];                             %A cutoff frequency of 30 Hz
    fs = 150;                                %Data sampled at 150 Hz
    % band pass the signal
    [b,a] = butter(2,fc/(fs/2));             %Design a 2th-order lowpass Butterworth filter
    yf = filter(b,a,y);                      % Filtered waveform

    figure(1); %draw figure
    plot(x/100,yf,'r'); 
    axis([(0+i*1),(11+i*1),-3,3]);           % set the range of x axis and y axis in every window
    %title and labels    
    title(['Time is from ',num2str((begins-1)/100),'s to ',num2str((ends-1)/100),'s']);
    xlabel('second');
    ylabel('ECG Amplitude');

    threshold = 2.2;                         % 190 is the minimum difference between 
                                             % any two consecutive maximum/minimum points
    [maxtab, mintab] = peakdet(yf,threshold,x/100) ;  % do a peak detection, 
   
    hold on;                                 % hold on the figure

    plot(mintab(:,1),mintab(:,2),'c*')
    plot(maxtab(:,1),maxtab(:,2),'g*')  

    drawnow;                                 % Change to animation
    F = getframe(gcf);                       % Capture the entire interior of the current graphics window 
                                             % and obtain frames as images
    I = frame2im(F);                         % Convert movie animation to addressed image 
                                             % because the image must be an index index image
    [I,map] = rgb2ind(I,256);                % Convert true color images to index images
    imwrite(I,map,'test.gif','gif', 'Loopcount',inf,'DelayTime',0.5);
    pause(1);                                % delay 1 second for every window

    HR = (size(maxtab,1) + size(mintab,1))/2*6;  % each peak corresponds to a heart beat. 
                                             % Heart rate is always given as HR/minute. 

    fprintf('The Heart Rate is %d\n',HR);    % display the result of Heart rate
    i = i + 1;
    
    end

    
