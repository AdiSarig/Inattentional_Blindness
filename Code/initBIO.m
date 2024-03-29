function triggers = initBIO(session)
%% this is Leemor's version of the triggers! 

% triggers' names: 

triggers.BIOSEMI_CODE_START         = 255;
triggers.BIOSEMI_CODE_SLEEP         = 0;    % main - end of exp
triggers.BIOSEMI_CODE_END           = 253;
triggers.TRIGGERS_RECORDING_STARTED = 254;  % main - before practice
triggers.TRIGGERS_RECORDING_ENDED   = 252;  % main - after end screen

triggers.PHASE_STARTED  = 248;  % runPhase
triggers.PHASE_ENDED    = 249;  % runPhase
triggers.BLOCK_STARTED  = 246;  % runBlock - after timing calibration
triggers.BLOCK_INFO     = 247;  % blockInfo
triggers.BLOCK_ENDED    = 245;  % runBlock - before break

triggers.maintenance_break = 250;
triggers.maintenance_break_over = 251;

% Trial trigger sequence:
% stimuli - phase 0
triggers.Image_noise_p0   = 202; % Image: noise
% stimuli - phase 1
triggers.Image_face_p1    = 210; % Image: face
triggers.Image_house_p1   = 211; % Image: house
triggers.Image_noise_p1   = 212; % Image: noise
% stimuli - phase 2
triggers.Image_face_p2    = 220; % Image: face
triggers.Image_house_p2   = 221; % Image: house
triggers.Image_noise_p2   = 222; % Image: noise
% stimuli - phase 3
triggers.Image_face_p3    = 230; % Image: face
triggers.Image_house_p3   = 231; % Image: house
triggers.Image_noise_p3   = 232; % Image: noise

% trial number 1:72
% image number 1:12    111:122
triggers.Disc_vertical   = 130; % Disc: vertical (1)
triggers.Disc_horizontal = 131; % Disc: horizontal (2)
triggers.Disc_same       = 132; % Disc: all the same orientation (1)
triggers.Disc_diff       = 133; % Disc: one with different orientation (2)
% disc location 0:4 (total range: 140:144)

triggers.Fix_face  = 150; % fixation when image is face
triggers.Fix_house = 151; % fixation when image is house
triggers.Fix_noise = 152; % fixation when image is noise

% Responses:
triggers.Resp_START       = 180; % response collected - same for all responses and decoded later
triggers.Resp_Disc_same   = 181; % sub said Same
triggers.Resp_Disc_diff   = 182; % sub said Different
triggers.Resp_Image_face  = 183; % sub said face
triggers.Resp_Image_house = 184; % sub said house
triggers.Resp_Image_noise = 185; % sub said noise
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

