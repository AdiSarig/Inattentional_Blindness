function triggers = initBIO(session)
%% this is Leemor's version of the triggers! 

% triggers' names: 

triggers.BIOSEMI_CODE_START         = 255;
triggers.BIOSEMI_CODE_SLEEP         = 0;
triggers.BIOSEMI_CODE_END           = 253;
triggers.TRIGGERS_RECORDING_STARTED = 254;
triggers.TRIGGERS_RECORDING_ENDED   = 252;

triggers.PHASE_STARTED  = 248;
triggers.PHASE_ENDED    = 249;
triggers.BLOCK_STARTED  = 246;
triggers.BLOCK_INFO     = 247;
triggers.BLOCK_ENDED    = 248;

% Trial trigger sequence:
triggers.Trial_END = 210; % previous trial has ended
triggers.Trial_START = 250; % Stim display trigger
% trial number 1:72
triggers.Image_face    = 100; % Image: face
triggers.Image_house   = 101; % Image: house
triggers.Image_noise   = 102; % Image: noise
% image number 1:12    111:122
triggers.Disc_vertical   = 130; % Disc: vertical
triggers.Disc_horizontal = 131; % Disc: horizontal
triggers.Disc_same       = 132; % Disc: all the same orientation
triggers.Disc_diff       = 133; % Disc: one with different orientation
% disc location 0:4 (total range: 140:144)

triggers.Fix_face  = 150; % fixation when image is face
triggers.Fix_house = 151; % fixation when image is house
triggers.Fix_noise = 152; % fixation when image is noise

% Responses:
triggers.Resp_Disc_same   = 180; % sub said Same
triggers.Resp_Disc_diff   = 181; % sub said Different
triggers.Resp_Image_face  = 182; % sub said face
triggers.Resp_Image_house = 183; % sub said house
triggers.Resp_Image_noise = 184; % sub said noise
triggers.Resp_Corr        = 190; % correct
triggers.Resp_inCorr      = 191; % incorrect
triggers.RESP_missing     = 198; % No response
triggers.RESP_ERROR       = 199; % wrong button

% convert to binary for Vpixx digital output
trigNames = fieldnames(triggers);
trigBin = convertTriggers(triggers);
trigBinstruct = cell2struct(trigBin,trigNames);
triggers = [trigBinstruct triggers];

% trial number 1:72
trials = num2cell(1:session.params.procedure.numTrials);
[trialNum(1:session.params.procedure.numTrials).num] = trials{:};

% image number 1:12    111:122
images = num2cell(111:110+session.params.procedure.numStim);
[imageNum(1:session.params.procedure.numStim).num] = images{:};

% disc location 0:4 (total range: 140:144)
discLoc = num2cell(140:144);
[discLocNum(1:5).loc] = discLoc{:};

trigBin = convertTriggers(trialNum);
[trialNum(1:session.params.procedure.numTrials).numBin] = trigBin{:};

trigBin = convertTriggers(imageNum);
[imageNum(1:session.params.procedure.numStim).numBin] = trigBin{:};

trigBin = convertTriggers(discLocNum);
[discLocNum(1:5).numBin] = trigBin{:};

triggers(1).trialNum   = trialNum;
triggers(1).imageNum   = imageNum;
triggers(1).discLocNum = discLocNum;

end

