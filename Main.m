function Main(subNo,counterBalance)

% -----------------------------------------------------
% this script runs the main experimental phase of Experiment 1.

% L.M., August 2017

% Input parameters:
% subNo = subject number
% counterBalance = balance right and left keys (should be set to 0 or 1)
% -----------------------------------------------------

%% TO DO
% Fix timing - check vpixx in the lab
% Fix the position of the discs - V
% Add messages and instructions for block start and phase start - V
% Add post phase questions - find out how to create a text box
% Remove redundent vars - V
% Organize and add comments
% fix fixTime to match the trial - V
% add ttl ind for: im 1/2/3, orientation h/v, change y/n, location 1/2/3/4
% adjust response box: http://psychtoolbox.org/docs/ResponsePixx

%%
debug = 1;

global phase
global defaultpath ImFol
global addFix minFix ifi ImDurForFlip ImCont refreshRate
global screens screenNumber gray ScreenWidth ScreenHeight center
global w wRect fixation vpix_trig start_exp_ptb start_exp_vpixx


%% DEFINE PARAMS & STIMULI
% ****************************

%% Screen params
isOpen = Datapixx('Open'); % check if Vpixx screen is connected
if ~isOpen
    error('VIEWPixx not connected! Please check connection and try again');
end
PsychDataPixx('Open');
ResponsePixx('Close');
ResponsePixx('Open');

% psychtoolbox initialization
screens         =  Screen('Screens');
screenNumber    =  max(screens);
gray            =  GrayIndex(screenNumber);
if debug
    [w, wRect]  =  Screen('OpenWindow',screenNumber, gray, [100 100 600 600]);
else
    [w, wRect]  =  Screen('OpenWindow',screenNumber, gray);
    HideCursor;
end
ScreenWidth     =  wRect(3);
ScreenHeight    =  wRect(4);
center        =  [ScreenWidth/2; ScreenHeight/2];
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);             % this enables us to use the alpha transparency

%% Procedure params & variables

trialNum = 72; % number of trials within each block
blockNum = 5; % number of blocks within each phase
ImCont   = 0.4;  % CHANGE THIS FOR THE STIMULI CONTRAST

%% Duration params

minFix          =  1.3;
addFix          =  0.2;
ImDur           =  0.1;
ifi = Screen('GetFlipInterval',w);
ImFrames = round(ImDur/ifi);
ImDurForFlip = ifi*(ImFrames-0.5);
refreshRate     =  round(1/ifi); %Hz

%% Response params
KbName('UnifyKeyNames');
% Map response box buttons index as set by ResponsePixx('GetButtons') from left to right
RespboxLeft        =  1; % Left
RespboxMiddle      =  3; % 2 from left
RespboxRight       =  4; % 3 from left
% Respbox4         =  2; % uncomment if the fourth button is needed
RespboxTop         =  5; % top button used as esc from info window

if counterBalance
    Resp1im = RespboxRight;    % face stim
    Resp2im = RespboxLeft;     % house stim
    Resp1d  = RespboxRight;    % disc same orientation
    Resp2d  = RespboxLeft;     % disc changed orientation
else
    Resp1im = RespboxLeft;     % face stim
    Resp2im = RespboxRight;    % house stim
    Resp1d  = RespboxLeft;     % disc same orientation
    Resp2d  = RespboxRight;    % disc changed orientation
end
Resp3im = RespboxMiddle;       % noise stim
abortKey = RespboxTop;         % exit exp

%% Text params

Screen('TextFont',w, 'Comic Sans MS');
Screen('TextStyle', w, 0);
% Screen('Preference','TextRenderer',0); % make sure it doesn't cause timing and location issues
Screen('TextSize', w, 24);
text.Color = 0;

%% Messages

DiscQuest1 = 'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = One changed             Right = All the same\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
DiscQuest2 = 'In the following part you will see 4 circles cut in half and colored in red and green\n \n \nAnswer using the arrow keys if any of the circles change orientation\n \n \nLeft = All the same             Right = One changed\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';

ImQuest1 = 'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = House             Down = Nothing             Right = Face\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';
ImQuest2 = 'In the following part you will see images in between the colored circles\n \n \nAnswer using the arrow keys if you saw a face, a house or neither\n \n \nLeft = Face             Down = Nothing             Right = House\n \n \n \n \n \n \nGood Luck!\n \nPress any key to continue';

End   =  'Thank you for your participation in the experiment';

%% PRELIMINTY PREPATATION

clc;                                                                        % Clear Matlab/Octave window:
AssertOpenGL;                                                               % check for Opengl compatibility, abort otherwise

if nargin < 1                                                               % Check if all needed parameters given:
    error('Must provide required input parameters "subNo"!');
end

rand('state',sum(100*clock));                                               % Reseed the random-number generator for each expt.

IBMat = zeros(trialNum,19);                 % file handling
TotalIBMat=zeros(size(IBMat,1)*blockNum,19);

%% DEFINE PATHWAYS

defaultpath = 'G:\My Drive\MudrikLab020818\Experiments_new\Triangulating_consciousness\Inattentional_Blindness\Experiment\Development';  % change this according to your folder structure
ImFol = 'stimuli';  % change this according to your folder structure

% for each subject, we save all codes used for running the experiment
cl = clock;
prf = sprintf('%d-%d-%s-%d-%d-%d',subNo,phase, date,cl(4),cl(5),round(cl(6)));
copyfile(sprintf('%s%cMain.m',defaultpath,filesep),sprintf('%s%cdata%cMain_%s.m',defaultpath, filesep, filesep, prf));  % change this according to your folder structure
% copyfile(sprintf('%s%cpresentstim2020.m',defaultpath,filesep),sprintf('%s%cdata%cpresentstim2020_%s.m',defaultpath, filesep, filesep, prf));  % change this according to your folder structure
% copyfile(sprintf('%s%cpresentQuest3_2020.m',defaultpath,filesep),sprintf('%s%cdata%cpresentQuest3_2020_%s.m',defaultpath, filesep, filesep, prf));  % change this according to your folder structure

%% EXPERIMENT

load('PracList.mat');
fixation = imread(sprintf('%s%c%s%cfixation.tif',defaultpath,filesep, ImFol, filesep));
vpix_trig=uint8([255 0 255 0 255 0 255 0 0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0]);
vpix_trig(:,:,2)=uint8([0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 0 0 0 0 0 0 0]);
vpix_trig(:,:,3)=uint8([0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0 0 255 0 255 0 255 0 255]);

KbCheck;                                                                    % Do dummy calls to GetSecs, WaitSecs, KbCheck
WaitSecs(0.1);
GetSecs;
ListenChar(2);
priorityLevel=MaxPriority(w);                                               % Set priority for script execution to realtime priority:
Priority(priorityLevel);

for phase=0:3
    %% PREPARE THE TRIAL MATRIX
    % This section creates the trial matrix for each phase, using a function
    % Trial Types: Image Type: 1=face 2=house 3=noise; Disc orientation: 1=same 2=diff
    expTrialList = mixTrialList2020(trialNum);
    [start_exp_ptb,start_exp_vpixx] = PsychDataPixx('GetPreciseTime'); % synchronize system and vpixx clocks and get their values
    
    %% Initialize block
    for block=1:5
        trialList=expTrialList(:,:,block);
        
        % Starting Message
        [InfoTiming,Response] = blockInfo(Resp1d,DiscQuest1,DiscQuest2,Resp1im,ImQuest1,ImQuest2,text.Color,RespboxRight);
        
        % an option to stop the experiment: escape key
        if Response(abortKey)
            Screen('CloseAll'); % graceful abort
            return
        end
        
        if block ~=1 % add fixTime to the last trial of the previous block
            TotalIBMat(matLoc+trialNum-1,17)=InfoTiming-Tfix;
        end
        
        if phase==0
            trialList=PracList;
        end
        
        %% Initialize trial
        ntrials=size(trialList,1);
        PsychDataPixx('GetPreciseTime'); % synchronize system and vpixx clocks
        
        Datapixx('SetMarker');
        Screen('Flip',w);
        Datapixx('RegWrRd');
        Tfix=Datapixx('GetMarker'); % start of block
        nextImTime=Tfix + rand(1)*addFix + minFix;
        
        for trial=1:ntrials
            %% Find trial parameters for trial functions

            imName = sprintf('%s%c%s%c%d_%d.pcx',defaultpath,...
                filesep, ImFol, filesep, trialList(trial, 1),...
                trialList(trial, 2));
            
            [disc1,disc2,disc3,disc4]=rotateDiscs(trialList(trial,3),trialList(trial,4),trialList(trial,5)); % inputs: orientation v/h, change s/d, location 1/2/3/4
            
            if phase==3
                CorrAns   = trialList(trial,1);
            else
                CorrAns   = trialList(trial,4);
            end
            
            FixID = 10000*trialList(trial,1)+1000*trialList(trial,3)+100*trialList(trial,4)+10*trialList(trial,5); % f/h/n, v/h, same/diff, Loc, im/fix
            ImID  = FixID+1;
            
            %% Present stimuli
            
            [FixTime, ImTime, RT, Resp, corr, Tim, Tfix,nextImTime]=run_trial(imName,...
                disc1, disc2, disc3, disc4,Tfix,nextImTime,...
                CorrAns, Resp1im, Resp2im, Resp3im, Resp1d, Resp2d);
           
            %% SAVE DATA
            % add timing from start for both im and fix
            if phase~=0 % only save data if this is not practice
                IBMat(trial,1)    =  subNo;                % subject number
                IBMat(trial,2)    =  phase;
                IBMat(trial,3)    =  block;
                IBMat(trial,4)    =  trial;                % trial number
                IBMat(trial,5:9)  =  trialList(trial,1:5); % trial specifications
                IBMat(trial,10)   =  Resp;                % subejct's reponse about the target
                IBMat(trial,11)   =  corr;                % was subject right about the target?
                IBMat(trial,12)   =  RT;                  % RT for the target
                IBMat(trial,13)   =  ImID;             
                IBMat(trial,14)   =  ImTime;
                IBMat(trial,15)   =  Tim-start_exp_vpixx;  % image time from start
                IBMat(trial,16)   =  FixID; 
                if trial ~= 1
                    IBMat(trial-1,17)   =  FixTime;
                end
                IBMat(trial,18)   =  Tfix-start_exp_vpixx;  % fixation time from start          
                IBMat(trial,19)   =  ImCont;
            end
        end % of trial loop
        if phase==0 % don't save practice data
            break
        else % add responses of current block to the total mat
            matLoc=(block-1)*trialNum+1;
            TotalIBMat(matLoc:matLoc+trialNum-1,:)=IBMat;
        end
    end % of block loop
    if phase~=0 % save response matrix by phase
        MatName = sprintf('%s%cdata%cSummary_sub_%d_p%d.mat',defaultpath,filesep,filesep,subNo, phase);  % change this according to your folder structure
        save(MatName,'TotalIBMat');
    end
    if phase~=0 % answer manipulation questions after each phase
        % [Ans1, Ans2, Ans3, Ans4, Ans5, Ans6]=postPhase();
    end
end

% Thank you screen
DrawFormattedText(w, End, 'center', 'center', text.Color);
Screen('Flip',w);
WaitSecs(MessDur);
KbWait;
Screen('CloseAll');
ListenChar(0);

end


