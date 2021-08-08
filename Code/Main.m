function Main()

% -----------------------------------------------------
% This function runs inattentional blindness experiment.

% L.M., August 2017
% github test
% -----------------------------------------------------

%%
global phase debug w

debug = 0;

%% INITIALIZE EXPERIMENT
% Initialize Vpixx
isOpen = Datapixx('Open'); % check if Vpixx screen is connected
if ~isOpen
    error('VIEWPixx not connected! Please check connection and try again');
end

PsychDataPixx('Open');
% switch to ScanningBacklight mode for full illumination only after pixels stabilize 
PsychDataPixx('EnableVideoScanningBacklight'); % comment for photodiode test
ResponsePixx('Close'); % to make sure open doesn't fail
ResponsePixx('Open');
Datapixx('EnableDinDebounce');
Datapixx('RegWr');

doutValue = bin2dec('0000 0000 0000 0000 0000 0000'); % initialize digital output
Datapixx('SetDoutValues', doutValue);
Datapixx('RegWr');


%% Initialize session
session = initSession('Inattentional_Blindness');

%% SAVE CODES
% for each subject, we save all codes used for running the experiment
[session] = saveCodes(session);

%% PRELIMINTY PREPATATION

% clc;                          % Clear Matlab/Octave window:
AssertOpenGL;                 % check for Opengl compatibility, abort otherwise
rand('state',sum(100*clock)); % Reseed the random-number generator for each expt.

KbCheck;                      % Do dummy calls to GetSecs, WaitSecs, KbCheck
WaitSecs(0.1);
GetSecs;
ListenChar(2);
priorityLevel=MaxPriority(w); % Set priority for script execution to realtime priority:
Priority(priorityLevel);

Datapixx('SetDoutValues', session.triggers(1).TRIGGERS_RECORDING_STARTED);
Datapixx('RegWr');

%% RUN EXPERIMENT
for phase=0:3
    [session] = runPhase(session,phase);
end

%% Save data
fileName = sprintf('..%cdata%cIB_Sub_%d',filesep,filesep,session.subjnum);
try
    save(fileName,'session');
catch
    mkdir(sprintf('..%cdata',filesep));
    save(fileName,'session');
end

%% Thank you screen
endScreen = imread(session.params.procedure.instructions.End);
endScreenTex = Screen('MakeTexture',w,endScreen);
Screen('DrawTexture',w,endScreenTex);
Screen('Flip',w);
WaitSecs(3);
KbWait;
Datapixx('SetDoutValues', session.triggers(1).TRIGGERS_RECORDING_ENDED);
Datapixx('RegWr');
Datapixx('SetDoutValues', session.triggers(1).BIOSEMI_CODE_SLEEP);
Datapixx('RegWr');
ResponsePixx('Close');
Screen('CloseAll');
ListenChar(0);

end