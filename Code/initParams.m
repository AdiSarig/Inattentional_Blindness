function [params] = initParams(session)

global w

[w,wRect,bgColour] = initScreen(); % open ptb screen

%% Screen parameters:
screen.res = Screen(0,'resolution');
screen.rect = wRect;
screen.bgColour = bgColour;
screen.viewDist_cm = 60;                               % viewing distance
screen.dim.cm = [53.1,29.9];                           % screen dimensions in cm [W, H]
screen.dim.pix = [screen.res.width screen.res.height]; % screen dimensions in pix
screen.dim.deg = [47.74,27.98];                        % screen dimensions in deg at 60cm
screen.dim.ppd = 33.11;                                % pixels per degree at 60cm view distance
screen.rgbGamma = [1 1 1];                             % gamma correction, if any

params.screen = screen;

%% Pathway
currentFolder = pwd;
idcs = strfind(currentFolder,filesep);
params.defaultpath = currentFolder(1:idcs(end)-1);  % should be the folder that containg the codes and stimuli
params.expFolder = 'Code';  % change this according to the folder structure, should be the folder of the experimental codes

%% Timing parameters:
timing.minFix          =  1.3;                          % minimal time for fixation to appear
timing.addFix          =  0.2;                          % maximal time to add to fixation (total: 1.3-1.5 sec)
timing.ImDur           =  0.1;                          % stimuli duration
timing.ifi = Screen('GetFlipInterval',w);
if 1/timing.ifi< 115 || 1/timing.ifi> 125                   % abort if refresh rate isn't 120 hz
    ResponsePixx('Close');Datapixx('Close');sca
    error('Screen refresh rate should be set to 120 hz')
end
timing.ImFrames = round(timing.ImDur/timing.ifi);
timing.ImDurForFlip = timing.ifi*(timing.ImFrames-1); % remove one frame to make sure the flip timing isn't missed
timing.refreshRate     =  round(1/timing.ifi); %Hz

params.timing = timing;

%% Response params
KbName('UnifyKeyNames');
% Map response box buttons index as set by ResponsePixx('GetButtons') from left to right
RespboxLeft        =  1; % Left
RespboxMiddle      =  3; % 2 from left
RespboxRight       =  4; % 3 from left
% Respbox4         =  2; % uncomment if the fourth button is needed
RespboxTop         =  5; % top button used as esc from info window

% map response buttons to experimental conditions
if strcmp(session.CounterBalanceDisc,'n')
    if strcmp(session.CounterBalanceIm,'n')
        response.face = RespboxRight;         % face stim
        response.house = RespboxLeft;         % house stim
        response.discSame  = RespboxRight;    % disc same orientation
        response.discDiff  = RespboxLeft;     % disc changed orientation
    else
        response.face = RespboxLeft;          % face stim
        response.house = RespboxRight;        % house stim
        response.discSame  = RespboxRight;    % disc same orientation
        response.discDiff  = RespboxLeft;     % disc changed orientation
    end
else
    if strcmp(session.CounterBalanceIm,'n')
        response.face = RespboxRight;         % face stim
        response.house = RespboxLeft;         % house stim
        response.discSame  = RespboxLeft;     % disc same orientation
        response.discDiff  = RespboxRight;    % disc changed orientation
    else
        response.face = RespboxLeft;          % face stim
        response.house = RespboxRight;        % house stim
        response.discSame  = RespboxLeft;     % disc same orientation
        response.discDiff  = RespboxRight;    % disc changed orientation
    end
end

response.noise = RespboxMiddle;           % noise stim
response.abortKey = RespboxTop;           % exit exp

params.response = response;

%% Initialize procedure
procedure = load('PracList.mat');         % five practice trials, only with noise
procedure.numBlocks = 8;
procedure.numPhases = 3;
procedure.numTrials = 72;
procedure.numStim = 12;                   % number of different stimuli for each type (face/house/noise); must be multiplication of 4 for initTrialList
procedure.infoFolder = 'instructions';

if strcmp(session.CounterBalanceDisc,'n') % set response instructions based on counterbalancing
    if strcmp(session.CounterBalanceIm,'n')
        procedure.instructions.disc = sprintf('%s%c%s%crightSame.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = One changed             Right = All the same\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
        procedure.instructions.image = sprintf('%s%c%s%crightFace.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = House             Down = Nothing             Right = Face\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
    else
        procedure.instructions.disc = sprintf('%s%c%s%crightSame.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = One changed             Right = All the same\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
        procedure.instructions.image = sprintf('%s%c%s%crightHouse.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = Face             Down = Nothing             Right = House\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
    end
else
    if strcmp(session.CounterBalanceIm,'n')
        procedure.instructions.disc = sprintf('%s%c%s%crightDiff.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = All the same             Right = One changed\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
        procedure.instructions.image = sprintf('%s%c%s%crightFace.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = House             Down = Nothing             Right = Face\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
    else
        procedure.instructions.disc = sprintf('%s%c%s%crightDiff.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = All the same             Right = One changed\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
        procedure.instructions.image = sprintf('%s%c%s%crightHouse.tif',params.defaultpath,filesep,procedure.infoFolder,filesep); %'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = Face             Down = Nothing             Right = House\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
    end
end
procedure.instructions.End   =  sprintf('%s%c%s%cEnd.tif',params.defaultpath,filesep,procedure.infoFolder,filesep);
procedure.instructions.rerun_practice   =  sprintf('%s%c%s%crerunPractice.tif',params.defaultpath,filesep,procedure.infoFolder,filesep);

procedure.instructions.maintenance   =  sprintf('%s%c%s%cmaintenance.tif',params.defaultpath,filesep,procedure.infoFolder,filesep);

params.procedure = procedure;

%% Stimuli
stimuli.stimContrast = 0.4;
stimuli.stimFolder = 'stimuli';                % change this according to the folder structure
stimuli.pos.CTR = round(screen.rect([3,4])/2); % center of the screen in pixels
stimuli.pos.ULdisc = stimuli.pos.CTR-150;      % the four discs' positions
stimuli.pos.URdisc = [stimuli.pos.CTR(1)+150 stimuli.pos.CTR(2)-150];
stimuli.pos.LLdisc = [stimuli.pos.CTR(1)-150 stimuli.pos.CTR(2)+150];
stimuli.pos.LRdisc = stimuli.pos.CTR+150;
stimuli.text.font = 'Comic Sans MS';
stimuli.text.size = 24;
stimuli.text.colour = 0;

params.stimuli = stimuli;

end

