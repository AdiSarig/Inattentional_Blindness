function Main()

% -----------------------------------------------------
% This function runs inattentional blindness experiment.

% L.M., August 2017

% -----------------------------------------------------

%% TO DO
% Fix timing issues
% Add post phase questions - find out how to create a text box
% Add TTL by initBIO: http://psychtoolbox.org/docs/PsychImaging
%                     http://psychtoolbox.org/docs/PsychDataPixx
% Adjust response box: http://psychtoolbox.org/docs/ResponsePixx

%%
global phase debug w

debug = 1;

%% INITIALIZE EXPERIMENT
% Initialize Vpixx
isOpen = Datapixx('Open'); % check if Vpixx screen is connected
if ~isOpen
    error('VIEWPixx not connected! Please check connection and try again');
end
PsychDataPixx('Open');
% ResponsePixx('Close');
% ResponsePixx('Open');

%% Initialize session
session = initSession('Inattentional_Blindness');

%% SAVE CODES
% for each subject, we save all codes used for running the experiment
[session] = saveCodes(session);

%% PRELIMINTY PREPATATION

% clc;                        % Clear Matlab/Octave window:
AssertOpenGL;                 % check for Opengl compatibility, abort otherwise
rand('state',sum(100*clock)); % Reseed the random-number generator for each expt.

KbCheck;                      % Do dummy calls to GetSecs, WaitSecs, KbCheck
WaitSecs(0.1);
GetSecs;
ListenChar(2);
priorityLevel=MaxPriority(w);                                               % Set priority for script execution to realtime priority:
Priority(priorityLevel);

%% RUN EXPERIMENT

for phase=0:3
    [session] = runPhase(session,phase);
end

%% Save data
fileName = sprintf('..%cdata%cIB_Sub_%d',filesep,filesep,session.subjnum);
save(fileName,'session');

%% Thank you screen
DrawFormattedText(w, session.params.procedure.instructions.End, 'center', 'center', session.params.screen.text.colour);
Screen('Flip',w);
WaitSecs(MessDur);
KbWait;
Screen('CloseAll');
ListenChar(0);

end