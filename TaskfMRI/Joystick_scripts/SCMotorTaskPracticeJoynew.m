%motor task with self selection of four possible mvt directions
%july 8 2010, Liane Schmidt, modifs Jochen Weber

clear all; close all;

% Make sure the script is running on Psychtoolbox-3:
AssertOpenGL;

% identification
nsub=input('subject number ?');
nsession=input('session number ?');
resultname=strcat('MtaskPracticeJoynewSub',num2str(nsub),'Session',num2str(nsession));


%Prepares the screen
[Window,Rect] = initializeScreen;
screenWidth=Rect(3);
screenHeight=Rect(4);
xcenter=screenWidth/2;
ycenter=screenHeight/2;

% generator reset
rand('state',sum(100*clock));

% function joyStickMoveTest(gamepadIndex)
gamepadIndex=1;
lastTrigger=0; % will get reset when trigger pulled
% motionParam=2;
motionThresh=0.10; % minimum argument coming from the joystick (allows it to remain stationary)

%create n vectors
totaltrial=80;

%conditions and jitters
resultname2=strcat('stimlistSession',num2str(nsession),'.mat');
load (resultname2)


%time variables;
responsetime=2.5;
endtime=1; 


%data to save
session(1:totaltrial)=nsession;
n=0;
redovals=zeros(totaltrial,4);
greenovals=zeros(totaltrial,4);
choice=zeros(totaltrial,1);
sample=zeros(totaltrial,8);
lesPointsX=zeros(302,totaltrial);
lesPointsY=zeros(302,totaltrial);
data=zeros(totaltrial,6);
timedata=zeros(160,7);
times=zeros(1,3);
movtime=zeros(160,1);

%timedata
time1=zeros(160,1);
startfix=zeros(160,1);
checktime1=zeros(160,1);
endresponse=zeros(160,1);
time2=zeros(160,1);
checktimeplaus=zeros(160,1);

%oval positions on screen
myrects=zeros(4,8);
rects=zeros(4,1);

myrects(:,1)=[xcenter-35 ycenter/2-35 xcenter+35 ycenter/2+35];
myrects(:,2)=[(xcenter+(ycenter/2*cos(pi/4)))-35 (ycenter-(ycenter/2*sin(pi/4)))-35 (xcenter+(ycenter/2*cos(pi/4)))+35 (ycenter-(ycenter/2*sin(pi/4)))+35];
myrects(:,3)=[(xcenter+ycenter/2)-35 ycenter-35 (xcenter+ycenter/2)+35 ycenter+35];
myrects(:,4)=[(xcenter+(ycenter/2*cos(pi/4)))-35 (ycenter+(ycenter/2*sin(pi/4)))-35 (xcenter+(ycenter/2*cos(pi/4)))+35 (ycenter+(ycenter/2*sin(pi/4)))+35];
myrects(:,5)=[xcenter-35 (screenHeight-ycenter/2)-35 xcenter+35 (screenHeight-ycenter/2)+35];
myrects(:,6)=[(xcenter-(ycenter/2*cos(pi/4)))-35 (ycenter+(ycenter/2*sin(pi/4)))-35 (xcenter-(ycenter/2*cos(pi/4)))+35 (ycenter+(ycenter/2*sin(pi/4)))+35];
myrects(:,7)=[(xcenter-ycenter/2)-35 ycenter-35 (xcenter-ycenter/2)+35 ycenter+35];
myrects(:,8)=[(xcenter-(ycenter/2*cos(pi/4)))-35 (ycenter-(ycenter/2*sin(pi/4)))-35 xcenter-(ycenter/2*cos(pi/4))+35 ycenter-(ycenter/2*sin(pi/4))+35];

rects(:,1)=[xcenter-35 ycenter-35 xcenter+35 ycenter+35]; %central circle
movrects(:,1)=[xcenter-35 ycenter-35 xcenter+35 ycenter+35]; %central circle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%get ready%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DrawFormattedText(Window, 'Ready','center','center',355);
Screen('Flip',Window);
waitSecs(3)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% start behaviroal task%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time0=GetSecs;
n=0;
for trial=1:160
    choiceT=0;
    time1(trial)=GetSecs;

    % fixation
    Screen('TextSize',Window,64);
    DrawFormattedText(Window,'+',xcenter-21,ycenter-46,255);
    Screen('Flip',Window);
    if stimlist(trial)==0
        startfix(trial)=GetSecs;
        waitSecs(3);
        
    else
        startfix(trial)=GetSecs;
        waitSecs(0.5)
        n=n+1;

        % define all colors as black (while be filled to green/red in switch)
        mycolors=zeros(3,8);
        colors=zeros(3,1);

        % create random list of values 1 through 8
        sample(n,:)=randperm(8);

        if stimlist(trial)==1
            % self selected no repetitions
            % if last n same chosen direction (choice > 0) and at same position
            % then replace
            for i=1:4
                if trial > 1 && choice(n-1,1) == sample(n, i)
                    sample(n, i) = sample(n, i+4);
                    sample(n,i+4)=choice(n-1,1);
                end
            end
        elseif stimlist(trial)==2
            %self selected repetition allowed
            if trial > 1 && ~ismember(choice(n-1,1),sample(n,1:4))
                tmp=find(sample(n,5:8)==choice(n-1,1)); 
                tmp=tmp+4;
                sample(n,tmp)=sample(n,tmp-4);
                sample(n,tmp-4)=choice(n-1,1);
            elseif trial > 1 && choice(n-1,1)==0
                sample(n,:)=sample(n,:);
            end
        end

        % record which target is green (one column) and red (7 columns)
        greenovals(n,:) = sample(n,1:4);
        redovals(n,:) = sample(n,5:8);

        % in RGB space, the first color is RED, the second is GREEN
        % set green (with first index = 2!)
        mycolors(2,sample(n,1:4))=255;%yellow ovals
        mycolors(1,sample(n,1:4))=255;%yellow ovals
       
        % % set red (with first index = 1!)
        mycolors(2,sample(n,5:8))=55; %blue ovals      
        mycolors(3,sample(n,5:8))=55; %blue ovals    
        
        %%% set green central circle
        colors(1:3,1)=300;
        
        
        % draw and present n
       
        Screen('FrameOval', Window, colors, rects);
        
        Screen('FillOval', Window, colors, movrects);
        Screen('FillOval', Window , mycolors, myrects);
        Screen('Flip', Window);
%         [x,y] = GetMouse;
        
        currentX=xcenter; %center of screen X
        currentY=ycenter; %center of screen Y
        SetMouse(currentX,currentY,Window); %set the mouse to the center of the experiment window
        
        % Loop and track the mouse, drawing the contour
        thePoints = zeros(302, 2);
        thePoints(1, :) = [currentX currentY];
        thePointsIdx = 1;
        
        Screen('FrameOval', Window, colors, rects);
        Screen('FillOval', Window , mycolors, myrects);
        ShowCursor('CrossHair', Window);
        Screen('Flip', Window);
        checktime1(trial)=GetSecs;

        sampleTime = 0.01;
        startTime = GetSecs;
        nextTime=startTime;
        endTime = startTime+responsetime;

        % do for "responsetime" seconds, that is until GetSecs > endTime
        while (GetSecs<=endTime)


            % as we already have the first position (line 210), now we
            % wait for sampleTime ! there must not be any code in the
            % loop, as GetSecs updates internally!
            nextTime = nextTime + sampleTime;
            while (GetSecs < nextTime)
            end

            % get the new position
             [x,y] = GetMouse(Window);

            % and store in thePoints
            thePointsIdx = thePointsIdx + 1;
            thePoints(thePointsIdx, :) = [x, y];
            speed=30;
            %get new coordinates
            outputCoords=getGamePadCoords(gamepadIndex);

            if abs(outputCoords(1))>motionThresh && round(currentX+outputCoords(1)*10)>=0 && round(currentX+outputCoords(1)*10)<=Rect(3)
                currentX=round(currentX+outputCoords(1)*speed);
            end

            if abs(outputCoords(2))>motionThresh && round(currentY+outputCoords(2)*10)>=0 && round(currentY+outputCoords(2)*10)<=Rect(4)
                currentY=round(currentY+outputCoords(2)*speed);
            end
            SetMouse(currentX,currentY,Window);          
            
            % cursor position changed => update screen
            if ((x ~= currentX | y ~= currentY))
                
                Screen('FrameOval', Window, colors, rects);
                Screen('FillOval', Window , mycolors, myrects);
                Screen('TextSize',Window,35);
                ShowCursor('CrossHair',Window);
                Screen('Flip', Window);
                currentX = x; currentY = y;
            end
        end

        HideCursor;
        endresponse(trial)=GetSecs;

        % plausibility check of timing data
        checktimeplaus(trial,1)=nextTime-startTime;
        lesPointsX(1:thePointsIdx,n)=thePoints(1:thePointsIdx,1);
        lesPointsY(1:thePointsIdx,n)=thePoints(1:thePointsIdx,2);

        % choice points
        idx=250;
        var=50;
        for pos=1:8;
            a=find(lesPointsX(1:idx,n)>=myrects(1,pos)-var & lesPointsX(1:idx,n)<=myrects(3,pos)+var);
            b=find(lesPointsY(1:idx,n)>=myrects(2,pos)-var & lesPointsY(1:idx,n)<=myrects(4,pos)+var);

            if isempty(a) | isempty(b)
                continue;
            else
                if length(a)>length(b)
                    if length(b)>3
                        x=lesPointsX(b(end-3,1),n);
                        y=lesPointsY(b(end-3,1),n);
                    else
                        x=lesPointsX(b(end,1),n);
                        y=lesPointsY(b(end,1),n);
                    end

                    if x>=myrects(1,pos)-var && x<=myrects(3,pos)+var && y>=myrects(2,pos)-var && y<=myrects(4,pos)+var
                        movtime(trial)=b(1,1)*0.01;
                        choiceT=pos;
                        break;
                    else
                        continue;
                    end

                else

                    if length(a)>3
                        x=lesPointsX(a(end-3,1),n);
                        y=lesPointsY(a(end-3,1),n);
                    else
                        x=lesPointsX(a(end,1),n);
                        y=lesPointsY(a(end,1),n);
                    end

                    if x>=myrects(1,pos)-var && x<=myrects(3,pos)+var && y>=myrects(2,pos)-var && y<=myrects(4,pos)+var
                        movtime(trial)=a(1,1)*0.01;
                        choiceT=pos;
                        break;
                    else
                        continue;
                    end

                end
            end
        end
        choice(n)=choiceT;


    end
    time2(trial)=GetSecs;
end

time3=GetSecs;

%%%%%%%%%%%%%%%%%%%%%%%%end behavioral task%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('TextSize',Window,72);
DrawFormattedText(Window,'END','center','center',255);
Screen('Flip',Window);
waitSecs(5)
n=1:totaltrial;
data=[session' n' stimlist(stimlist>0) choice];
times=[time0 time3];
timedata=[time1 startfix checktime1 movtime checktimeplaus endresponse time2];
save(resultname, 'data','timedata','times', 'lesPointsX', 'lesPointsY','sample', 'redovals', 'greenovals');
clear screen


