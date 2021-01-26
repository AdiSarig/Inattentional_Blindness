function [params] = initParams(session)

global w

[w,wRect,bgColour] = initScreen();

%% Screen parameters:
screen.res = Screen(0,'resolution'); % [1680 x 1050] in Cohen testing rooms
screen.rect = wRect;
screen.bgColour = bgColour;
screen.viewDist_cm = 60; % viewing distance
screen.dim.cm = [53.1,29.9]; % screen dimensions in cm [W, H]
screen.dim.pix = [screen.res.width screen.res.height]; % screen dimensions in pix
screen.dim.deg = [47.74,27.98];% screen dimensions in deg at 50cm
screen.dim.ppd = 33.11; % pixels per degree at 60cm view distance
screen.rgbGamma = [1 1 1]; % gamma correction, if any

params.screen = screen;

%% Timing parameters:
timing.minFix          =  1.3;
timing.addFix          =  0.2;
timing.ImDur           =  0.1;
timing.ifi = Screen('GetFlipInterval',w);
timing.ImFrames = round(timing.ImDur/timing.ifi);
timing.ImDurForFlip = timing.ifi*(timing.ImFrames-0.5);
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

if strcmp(session.RespCounterBalance,'n')
    response.face = RespboxRight;    % face stim
    response.house = RespboxLeft;     % house stim
    response.discSame  = RespboxRight;    % disc same orientation
    response.discDiff  = RespboxLeft;     % disc changed orientation
else
    response.face = RespboxLeft;     % face stim
    response.house = RespboxRight;    % house stim
    response.discSame  = RespboxLeft;     % disc same orientation
    response.discDiff  = RespboxRight;    % disc changed orientation
end
response.noise = RespboxMiddle;       % noise stim
response.abortKey = RespboxTop;         % exit exp

params.response = response;

%% Initialize procedure
procedure = load('PracList.mat');
procedure.numBlocks = 5;
procedure.numTrials = 72;
procedure.numStim = 12; % number of different stimuli for each type (face/house/noise); must be multiplication of 4
if strcmp(session.RespCounterBalance,'n')
    procedure.instructions.disc = 'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = One changed             Right = All the same\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
    procedure.instructions.image = 'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = House             Down = Nothing             Right = Face\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
else
    procedure.instructions.disc = 'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = All the same             Right = One changed\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
    procedure.instructions.image = 'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = Face             Down = Nothing             Right = House\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
end
procedure.instructions.End   =  'Thank you for your participation in the experiment';

params.procedure = procedure;

%% Stimuli
stimuli.stimContrast = 0.4;
stimuli.stimFolder = 'stimuli';  % change this according to your folder structure
stimuli.pos.CTR = round(screen.rect([3,4])/2); %[720 450]; % center of the screen in pixels
stimuli.pos.ULdisc = stimuli.pos.CTR-200;
stimuli.pos.URdisc = [stimuli.pos.CTR(1)+200 stimuli.pos.CTR(2)-200];
stimuli.pos.LLdisc = [stimuli.pos.CTR(1)-200 stimuli.pos.CTR(2)+200];
stimuli.pos.LRdisc = stimuli.pos.CTR+200;
stimuli.text.font = 'Comic Sans MS';
stimuli.text.size = 24;
stimuli.text.colour = 0;

params.stimuli = stimuli;

%% Pathway
params.defaultpath = 'G:\My Drive\MudrikLab020818\Experiments\Triangulating_consciousness\Inattentional_Blindness\Experiment\Development';  % change this according to your folder structure
params.expFolder = 'RunExp';  % change this according to your folder structure

end

