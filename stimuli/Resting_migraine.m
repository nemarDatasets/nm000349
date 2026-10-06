%% HD-EEG Migraine study, resting state

clearvars

Screen('Preference', 'SkipSyncTests', 0);

blocks = 6;

HideCursor;

[windowPr,rect] = Screen('OpenWindow',0,0,[]);%0 0 1920/2,1080/2]);
width=rect(RectRight)-rect(RectLeft);
height=rect(RectBottom)-rect(RectTop);

white = WhiteIndex(windowPr);
black = BlackIndex(windowPr);
gray = (white+black)/2;
[xCenter, yCenter] = RectCenter(rect);

% fixation cross coords
H=width/2; 
H1=width/2-(width/2/60);
H2=width/2+(width/2/60);
V=height/2;
V1=height/2-(width/2/60); 
V2=height/2+(width/2/60);
penWidth=2;
textsize=40;
Font='Arial'; Screen('TextSize',windowPr,textsize); Screen('TextFont',windowPr,Font); Screen('TextColor',windowPr,black);

Screen('FillRect',windowPr,127.5,rect);
DrawFormattedText(windowPr, 'Please focus on central cross', 'center', (rect(4)/8)*4);
DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*5);
Screen('Flip', windowPr); 
WaitSecs(.1);
KbWait;  

%%% set up triggering
object = io64; % 64-bit location handle for parallel interface object
status = io64(object); % all good if status = 0
address = hex2dec('CFF8'); % presentation computer parport address

for j = 1:blocks
    
    io64(object, address, 1);
    WaitSecs(.05);
    io64(object, address, 0);

    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
    Screen('Flip', windowPr);
    WaitSecs(120);
    
    io64(object, address, 2);
    WaitSecs(.05);
    io64(object, address, 0);
    
    if j < blocks
        Screen('FillRect',windowPr,127.5,rect);
        DrawFormattedText(windowPr, 'Please take a break', 'center', (rect(4)/8)*4);
        DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*5);
        Screen('Flip', windowPr); 
        WaitSecs(.1);
        KbWait
    else
        Screen('FillRect',windowPr,127.5,rect);
        DrawFormattedText(windowPr, 'You have finished', 'center', (rect(4)/8)*4);
        DrawFormattedText(windowPr, 'Please find experimenter', 'center', (rect(4)/8)*5);
        Screen('Flip', windowPr); 
        WaitSecs(.1);
        KbWait
    end
end
Screen('CloseAll');