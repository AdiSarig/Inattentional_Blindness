function triggers = initBIO(session)
%% Initialize EEG triggers
% this is Leemor's version of the triggers! 

%% General
% in comments - location in code
triggers.EXP_START         = 255;  % main - before practice
triggers.EXP_END           = 254;  % main - end of exp
triggers.PHASE_STARTED     = 248;  % runPhase
triggers.PHASE_ENDED       = 249;  % runPhase
triggers.BLOCK_STARTED     = 246;  % runBlock - after timing calibration
triggers.BLOCK_INFO        = 247;  % blockInfo
triggers.BLOCK_ENDED       = 245;  % runBlock - before break

%% Trial trigger sequence:
% For each stimulus the entire sequence will be sent. Always begins with
% 250 at the exact time of stimulus presentation.
triggers.Trial_START = 250; % Stim display trigger - always the same for all trials!
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

%% Fixation
triggers.Fix_face  = 150; % fixation when image is face
triggers.Fix_house = 151; % fixation when image is house
triggers.Fix_noise = 152; % fixation when image is noise

%% Responses
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

%% trial number 1:72
trials = num2cell(1:session.params.procedure.numTrials);
[trialNum(1:session.params.procedure.numTrials).num] = trials{:};

%% image number 1:12    111:122
images = num2cell(111:110+session.params.procedure.numStim);
[imageNum(1:session.params.procedure.numStim).num] = images{:};

%% disc location 0:4 (total range: 140:144)
discLoc = num2cell(140:144);
[discLocNum(1:5).loc] = discLoc{:};

%% Merge
triggers(1).trialNum   = trialNum;
triggers(1).imageNum   = imageNum;
triggers(1).discLocNum = discLocNum;

%% Connect to port
triggers.LPT_address = hex2dec('c010'); % change if a different address is required

triggers.biosemi=io64;
status=io64(triggers.biosemi);
if status
    error('BIOSEMI connection failed');
end

end

