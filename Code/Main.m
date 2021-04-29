function Main()

% -----------------------------------------------------
% This function runs inattentional blindness experiment.
% Images of faces and houses are displayed to the subjects while they are
% engaged with a different task. The distracting task requires noticing
% whether out of four cut-in-half circles, one is oriented to a different
% direction. Both are displayed at the same time for a 100 ms followed by a
% fixation dot during which responses are collected.
%
% There are 3 different phases followed by a questionnaire regarding the
% displayed stimuli. Phase 1 and 2 are as described above. However, in
% phase 3 subjects are required to answer regarding the displayed images.

% L.M., August 2017
% A.S., April 2021

% -----------------------------------------------------

%%
global phase debug w

debug = 0;

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

sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).EXP_START);

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
sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).EXP_END);
WaitSecs(3);
KbWait;
Screen('CloseAll');
ListenChar(0);

end