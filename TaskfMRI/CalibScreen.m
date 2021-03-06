
clear all; close all;

% Make sure the script is running on Psychtoolbox-3:
AssertOpenGL;


%Prepares the screen
[Window,Rect] = initializeScreen;

screenWidth=Rect(3);
screenHeight=Rect(4);
xcenter=screenWidth/2;
ycenter=screenHeight/2;

%rectangle positions on screen

myrects=zeros(4,4);
rects=zeros(4,1);

myrects(:,1)=[xcenter-35 ycenter/2-35 xcenter+35 ycenter/2+35];%top

% myrects(:,2)=[(xcenter+(ycenter/2*cos(pi/4)))-35 (ycenter-(ycenter/2*sin(pi/4)))-35 (xcenter+(ycenter/2*cos(pi/4)))+35 (ycenter-(ycenter/2*sin(pi/4)))+35];
myrects(:,2)=[(xcenter+ycenter/2)-35 ycenter-35 (xcenter+ycenter/2)+35 ycenter+35];%right

% myrects(:,4)=[(xcenter+(ycenter/2*cos(pi/4)))-35 (ycenter+(ycenter/2*sin(pi/4)))-35 (xcenter+(ycenter/2*cos(pi/4)))+35 (ycenter+(ycenter/2*sin(pi/4)))+35];
 myrects(:,3)=[xcenter-35 (screenHeight-ycenter/2)-35 xcenter+35 (screenHeight-ycenter/2)+35];%bottom

% myrects(:,6)=[(xcenter-(ycenter/2*cos(pi/4)))-35 (ycenter+(ycenter/2*sin(pi/4)))-35 (xcenter-(ycenter/2*cos(pi/4)))+35 (ycenter+(ycenter/2*sin(pi/4)))+35];
 myrects(:,4)=[(xcenter-ycenter/2)-35 ycenter-35 (xcenter-ycenter/2)+35 ycenter+35];%left
% myrects(:,8)=[(xcenter-(ycenter/2*cos(pi/4)))-35 (ycenter-(ycenter/2*sin(pi/4)))-35 xcenter-(ycenter/2*cos(pi/4))+35 ycenter-(ycenter/2*sin(pi/4))+35];

% rects(:,1)=[xcenter-35 ycenter-35 xcenter+35 ycenter+35]; %central circle



% myrects(:,1)=[xcenter-35 0 xcenter+35 70];
% myrects(:,2)=[(xcenter+ycenter)-70 ycenter-35 (xcenter+ycenter) ycenter+35];
% myrects(:,3)=[xcenter-35 screenHeight-70 xcenter+35 screenHeight];
% myrects(:,4)=[(xcenter-ycenter) ycenter-35 (xcenter-ycenter)+70 ycenter+35];
% in RGB space, the first color is RED, the second is GREEN
% set left green 
mycolors=zeros(3,4);

mycolors(1,1)=255;%red rectangle
mycolors(2,2)=255;%green rectangle
mycolors(3,3)=255;%blue rectangle
mycolors(1,4)=255;%yellow rectangle
mycolors(2,4)=255;%yellow rectangle




%get devnumbers: internal keyboard
devnumberlap=0;
if devnumberlap == 0
    ds=PsychHID('Devices'); 
    xx = zeros(1,length(ds));
    xx(strmatch('Keyboard',str2mat(ds.usageName))) = xx(strmatch('Keyboard',str2mat(ds.usageName)))+1;
    xx(strmatch('Apple Internal Keyboard / Trackpad',str2mat(ds.product))) = xx(strmatch('Apple Internal Keyboard / Trackpad',str2mat(ds.product))) + 1; %labtop

    if ~any(xx==2)
        beep,beep,beep
        error('Cannot Find Xkeys Keyboard device!');
        Screen('CloseAll');
    else
        devnumberlap =find(xx==2);
    end
end

%%% wait for key  %%%

start=0;
key='l';
keyChar =0;


while start==0
    DrawFormattedText(Window, 'Calibration','center','center',355);
    Screen('FillOval', Window , mycolors, myrects);
    ShowCursor
    Screen('Flip', Window);
    [keyIsDown,secs,keyCode]=KbCheck(devnumberlap);
    if keyIsDown==1
        keyChar = KbName(keyCode);
        hit=strcmp(lower(keyChar),key);
        if hit==1
           start=1;
        end
    end
end
HideCursor
clear screen




