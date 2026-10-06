%% HD-EEG migraine study with SSAEP using modulated tones
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
att = repmat([0 0 0 0 0 0 0 0 0 1],1,4 );

RT = [];

% fixation cross coords
H=width/2; 
H1=width/2-(width/2/60);
H2=width/2+(width/2/60);
V=height/2;
V1=height/2-(width/2/60);
V2=height/2+(width/2/60);
penWidth=2;
textsize=40;

white = WhiteIndex(windowPr);
black = BlackIndex(windowPr);
gray = (white+black)/2;
[xCenter, yCenter] = RectCenter(rect);
Font='Arial'; Screen('TextSize',windowPr,textsize); Screen('TextFont',windowPr,Font); Screen('TextColor',windowPr,black);

a = gray*.75;
b = gray*.75; %.01 

Screen('FillRect',windowPr,127.5,rect);
DrawFormattedText(windowPr, 'Experimenter:', 'center', (rect(4)/8)*3);
DrawFormattedText(windowPr, 'Make sure volume is set to 40', 'center', (rect(4)/8)*4);
DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*5);
Screen('Flip', windowPr); 
WaitSecs(.1);
KbWait;

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

%% Modulated tones

% Specs for the tone
Fs = 44100;      %# Samples per second
dt = 1/Fs;
toneFreq = 1000;  %# Tone frequency, in Hertz
nSeconds = 2;   %# Duration of the sound
t_beep = [dt:dt:nSeconds];
yT = [sin(2*pi*toneFreq*t_beep)];% zeros(size(t_beep))];
maxVol = ones(1,length(yT));
VolN = yT.*(maxVol*0.5);
Tattack = 0.05; 
bump1=8; % how many bumps in the tone
bump2=12;

% cosine ramp
A=(0:dt:Tattack)/Tattack;
Tfade=(pi/(length(A)-.5));
RaisedCosine=cos(pi:Tfade:3*pi)+1;
RaisedCosineNormSquare=(RaisedCosine/max(RaisedCosine)).^2;
A=RaisedCosineNormSquare(1:(length(RaisedCosineNormSquare)/2));
rampUp = A;
rampDown = fliplr(rampUp);

% main body of tone
modul0 = (1+0.5.*[sin(2*pi*10*t_beep)]).*VolN;
mid = ones(1,length(modul0) - length(rampUp) - length(rampDown));
envelope = [rampUp mid rampDown];
pad = zeros(1,50);

Screen('Flip', windowPr);
WaitSecs(0.5); 

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
       
        Screen('FillRect',windowPr, gray);
        Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
        Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
        Screen('Flip', windowPr);
        modul = (1+0.9.*[sin(2*pi*bump1*t_beep)]).*VolN;
        a = sqrt(mean(modul0.^2));
        shapedVol = modul.*envelope;
        presentVol = [pad shapedVol pad];
        sound(presentVol, Fs);
        io64(object, address, 1);
        WaitSecs(.05);
        io64(object, address, 0);

        WaitSecs(2);
        
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

        Screen('FillRect',windowPr, gray);
        Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
        Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
        Screen('Flip', windowPr);
        modul = (1+0.9.*[sin(2*pi*bump2*t_beep)]).*VolN;
        b = sqrt(mean(modul0.^2));
        shapedVol = modul.*envelope;
        presentVol = [pad shapedVol pad]; 
        sound(presentVol, Fs);
        io64(object, address, 2);
        WaitSecs(.05);
        io64(object, address, 0);
        WaitSecs(2);
        
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
    
Screen('CloseAll');

Finish = GetSecs-Start;

dlmwrite([ID 'aud_migraine.txt'],RT);
xlswrite([ID 'aud_migraine.xlsx'],RT);
