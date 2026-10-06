%% HD-EEG Migraine study with SSVEP using Gabor patch
% Hit space bar whenever fixation cross changes colour

clear all; 
Screen('Preference', 'SkipSyncTests', 0);

ID='OT'; % change
HideCursor;	% Hide the mouse cursor

[windowPr,rect] = Screen('OpenWindow',0,0,[]);%0 0 1920/2,1080/2]);
width=rect(RectRight)-rect(RectLeft);
height=rect(RectBottom)-rect(RectTop);

blocks = 2;
trials = repmat([1 1 1 1 1 2 2 2 2 2],1,4);
att = repmat([0 0 0 0 0 0 0 0 0 1],1,4);

RT = [];

% fixation cross coords
H=width/2; 
H1=width/2-(width/2/60);
H2=width/2+(width/2/60);
V=height/2;
V1=height/2-(width/2/60);
V2=height/2+(width/2/60);
penWidth=2;

white = WhiteIndex(windowPr);
black = BlackIndex(windowPr);
gray = (white+black)/2;
[xCenter, yCenter] = RectCenter(rect);
textsize=40;
Font='Arial'; Screen('TextSize',windowPr,textsize); Screen('TextFont',windowPr,Font); Screen('TextColor',windowPr,black);

a = gray*.75;
b = gray*.75; %.01 

Screen('FillRect',windowPr,127.5,rect);
DrawFormattedText(windowPr, 'Hit button when you see the central cross flash', 'center', (rect(4)/8)*3);
DrawFormattedText(windowPr, 'Remember to focus on center cross', 'center', (rect(4)/8)*4);
DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*5);
Screen('Flip', windowPr); 
WaitSecs(.1);
KbWait;  

%%% set up triggering
object = io64; % 64-bit location handle for parallel interface object
status = io64(object); % all good if status = 0
address = hex2dec('CFF8'); % presentation computer parport address

%% Gabor patch

% motion details
duration = 4;
PresenSecs = 2;
ifi=Screen('GetFlipInterval', windowPr);
ifims = ifi*1000; %time in ms
nframes = round(1000*1/ifims)*PresenSecs; %number of frames to show the stimulus for

speed1 = 4; % check number of peaks using figure;plot(targetwaveform1)
targetwaveform1 = sin(2 .* speed1 .* (1-1000*duration/2:ifims:1000*duration/2) .* pi./1000);
targetwaveform1 = (targetwaveform1 + 1)./2;
targetwaveform1=(targetwaveform1-min(targetwaveform1));
targetwaveform1=((targetwaveform1./max(targetwaveform1))-0.5).*2;

speed2 = 6; % check number of peaks using figure;plot(targetwaveform3)
targetwaveform2 = sin(2 .* speed2 .* (1-1000*duration/2:ifims:1000*duration/2) .* pi./1000);
targetwaveform2 = (targetwaveform2 + 1)./2;
targetwaveform2=(targetwaveform2-min(targetwaveform2));
targetwaveform2=((targetwaveform2./max(targetwaveform2))-0.5).*2;

[x,y] = meshgrid(-rect(3)/2:rect(3)/2, -rect(4)/2:rect(4)/2);     
% m = (sin(0.01*2*pi*x));
% pict=floor(255*(sign(m+eps)+1)/2); 
m = exp(-((x/150).^ 2)-((y/150).^2)) .* sin(0.01*2*pi*x);
% m=size of gabor * SF
m = exp(-((x/150).^ 2)-((y/150).^2)) .* sin(0.005*2*pi*x);

for n = 1:nframes
    comp = gray+(gray*m*(targetwaveform1(n)));
    maskandtest1(n) = Screen('MakeTexture', windowPr, comp);
end
save('maskandtest_m1','maskandtest1');

for n = 1:nframes
    comp = gray+(gray*m*(targetwaveform2(n)));
    maskandtest2(n) = Screen('MakeTexture', windowPr, comp);
end
save('maskandtest_m2','maskandtest2');

Screen('Flip', windowPr);
WaitSecs(0.5);

mt1 = load(['maskandtest_m1.mat']);
maskandtest1 = mt1.maskandtest1;

mt2 = load(['maskandtest_m2.mat']);
maskandtest2 = mt2.maskandtest2;  

KbQueueCreate;

io64(object, address, 30);
WaitSecs(.05);
io64(object, address, 0);

Start = GetSecs;

for j = 1:blocks

    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
    Screen('Flip', windowPr);
    WaitSecs(1+(rand/2));

    trialrand = trials(randperm(length(trials)));
    attrand = att(randperm(length(att)));
    
    clearvars pressed firstPress secs0
    clear KbWait
    KbQueueStart;
    
for i = 1:length(trials)    

    if trialrand(i)==1
        
        io64(object, address, 1);
        WaitSecs(.05);
        io64(object, address, 0);
        
        try
            for n = 1:nframes
                frameindex = mod(n-1,nframes)+1;
                Screen('FillRect',windowPr, gray);
                Screen('DrawTextures', windowPr, maskandtest1(n));
                Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                Screen('Flip', windowPr);

            end
            psychrethrow(psychlasterror);
        end
        
        Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
        Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
        Screen('Flip', windowPr);
        
        if attrand(i) == 1
            WaitSecs(1+(rand/2));
            Screen('DrawLine', windowPr ,[255 255 255], H1, V, H2, V, penWidth);
            Screen('DrawLine', windowPr ,[255 255 255], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            secs0 = GetSecs;
            WaitSecs(.1);
            Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth); 
            Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            WaitSecs(1+(rand/2));
            [pressed, firstPress]=KbQueueCheck;
            %%
            if pressed==0
                Screen('DrawLine', windowPr ,[255 0 0], H1, V, H2, V, penWidth);
                Screen('DrawLine', windowPr ,[255 0 0], H, V1, H, V2, penWidth);
                Screen('Flip', windowPr);
                WaitSecs(.1);
                Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth); 
                Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                Screen('Flip', windowPr);
                WaitSecs(1+(rand/2));
            else
            io64(object, address, 11);
            WaitSecs(.05);
            io64(object, address, 0);    
            end 
        else
            Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
            Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            WaitSecs(1+(rand/2));
        end

    elseif trialrand(i)==2
        
        io64(object, address, 2);
        WaitSecs(.05);
        io64(object, address, 0);
        
        try
            for n = 1:nframes
                frameindex = mod(n-1,nframes)+1;
                Screen('FillRect',windowPr, gray);
                Screen('DrawTextures', windowPr, maskandtest2(n));
                Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                Screen('Flip', windowPr);
            end
            psychrethrow(psychlasterror);
        end
        
        Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
        Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
        Screen('Flip', windowPr);
        
        if attrand(i) == 1
            WaitSecs(1+(rand/2));
            Screen('DrawLine', windowPr ,[255 255 255], H1, V, H2, V, penWidth);
            Screen('DrawLine', windowPr ,[255 255 255], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            secs0 = GetSecs;
            WaitSecs(.1);
            Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth); 
            Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            WaitSecs(1+(rand/2));
            [pressed, firstPress]=KbQueueCheck;
            %%
            if pressed==0
                Screen('DrawLine', windowPr ,[255 0 0], H1, V, H2, V, penWidth);
                Screen('DrawLine', windowPr ,[255 0 0], H, V1, H, V2, penWidth);
                Screen('Flip', windowPr);
                WaitSecs(.1);
                Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth); 
                Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                Screen('Flip', windowPr);
                WaitSecs(1+(rand/2));
            else
            io64(object, address, 22);
            WaitSecs(.05);
            io64(object, address, 0);    
            end 
        else
            Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth); 
            Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            WaitSecs(1+(rand/2));
        end
    end
    % Collect keyboard response and record trial details
    sz = size(RT);
    RT(1,sz(2)+1) = trialrand(i);
        if attrand(i) == 1 
            if pressed == 1   
                RT(2,sz(2)+1) = 1;
                RT(3,sz(2)+1) = max(firstPress)-secs0;
            else RT(2,sz(2)+1) = 2;
                RT(3,sz(2)+1) = 100;
            end
        else 
            RT(2,sz(2)+1) = 0;
            RT(3,sz(2)+1) = 0;
        end
        
        clearvars pressed firstPress secs0
end   
        
if j<blocks
    DrawFormattedText(windowPr, 'Please take a break', 'center', (rect(4)/8)*3);
    DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*4);
    Screen('Flip', windowPr);
    WaitSecs(.1);
    KbWait;
    clearvars pressed firstPress secs0
    clear KbWait
    KbQueueFlush;
else
    DrawFormattedText(windowPr, 'You have finished', 'center', (rect(4)/8)*3);
    DrawFormattedText(windowPr, 'Please find the experimenter', 'center', (rect(4)/8)*4);
    Screen('Flip', windowPr);
    WaitSecs(2);  
end
end

io64(object, address, 20);
WaitSecs(.05);
io64(object, address, 0);

Finish = GetSecs-Start;

Screen('CloseAll');

dlmwrite([ID '_vis_migraine.txt'],RT);
xlswrite([ID '_vis_migraine.xlsx'],RT);
