function [params] = initParams(session)
% Initialize session parameters

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
params.defaultpath = currentFolder(1:idcs(end)-1);  % should be the folder containg the codes stimuli and instructions
params.expFolder = 'Code';  % change this if changing the folder structure, should be the folder of the experimental codes

%% Timing parameters:
timing.minFix          =  1.3;                          % minimal time for fixation to appear
timing.addFix          =  0.2;                          % maximal time to add to fixation (total: 1.3-1.5 sec)
timing.ImDur           =  0.1;                          % stimuli duration
timing.ifi = Screen('GetFlipInterval',w);
if 1/timing.ifi< 115 || 1/timing.ifi> 125               % abort if refresh rate isn't 120 hz
    sca
    error('Screen refresh rate should be set to 120 hz')
end
timing.ImFrames = round(timing.ImDur/timing.ifi);
timing.ImDurForFlip = timing.ifi*(timing.ImFrames-0.5); % remove half a frame to make sure the flip timing isn't missed
timing.refreshRate     =  round(1/timing.ifi); %Hz

params.timing = timing;

%% Response params
KbName('UnifyKeyNames');
% Map response buttons
Left        =  KbName('LeftArrow');
Down        =  KbName('DownArrow');
Right       =  KbName('RightArrow');
Exit        =  KbName('ESCAPE');

% map response buttons to experimental conditions
if strcmp(session.CounterBalanceDisc,'n')
    if strcmp(session.CounterBalanceIm,'n')
        response.face = Right;         % face stim
        response.house = Left;         % house stim
        response.discSame  = Right;    % disc same orientation
        response.discDiff  = Left;     % disc changed orientation
    else
        response.face = Left;          % face stim
        response.house = Right;        % house stim
        response.discSame  = Right;    % disc same orientation
        response.discDiff  = Left;     % disc changed orientation
    end
else
    if strcmp(session.CounterBalanceIm,'n')
        response.face = Right;         % face stim
        response.house = Left;         % house stim
        response.discSame  = Left;     % disc same orientation
        response.discDiff  = Right;    % disc changed orientation
    else
        response.face = Left;          % face stim
        response.house = Right;        % house stim
        response.discSame  = Left;     % disc same orientation
        response.discDiff  = Right;    % disc changed orientation
    end
end

response.noise = Down;           % noise stim
response.abortKey = Exit;        % exit exp

params.response = response;

%% Initialize procedure
procedure = load('PracList.mat');         % one block of practice trials, only with noise
procedure.numBlocks = 5;
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

params.procedure = procedure;

%% Stimuli
stimuli.stimContrast = 0.4;
stimuli.stimFolder = 'stimuli';                % change this if changing the folder structure
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

