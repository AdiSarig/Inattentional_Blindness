
%% this is Leemor's version of the triggers! 

% triggers' names: 

BIOSEMI_CODE_START = 255;
BIOSEMI_CODE_SLEEP = 0;
BIOSEMI_CODE_END = 253;
TRIGGERS_RECORDING_STARTED= 254;
TRIGGERS_RECORDING_ENDED= 252;
TRIGGERS_PHASE_STARTED = 248;
TRIGGERS_PHASE_ENDED = 249;
TRIGGERS_BLOCK_STARTED = 246;
TRIGGERS_BLOCK_ENDED = 247;

% Trial trigger sequence:
TRIAL_END = 210; % previous trial has ended
TRIAL_START = 250; % Stim display trigger
% trial number 1:72
TRIGGERS_Image   = [100, 101, 102]; % Image: f/h/n
% image number 1:12
TRIGGERS_Disc    = [110, 111, 112, 113]; % Disc: v+same, v+diff, h+same, h+diff
% 10 + disc location 0:4 (total range: 10:14)

TRIGGERS_FIX = [150, 151, 152]; % fixation when image is f/h/n

% Responses:
TRIGGERS_RespSub_Disc = [180,181]; % 180 = sub said Same 181 = sub said Different
TRIGGERS_RespSub_Image = [182,183,184]; % 182 = sub said face 183= sub said house 184 = sub said noise
TRIGGERS_RespSub_Corr = [190,191]; % 190=correct 191=incorrect
TRIAL_SUBJ_RESP_ERROR = 199; % wrong button


[BIOSEMI, BIO_LPT_ADDRESS]=init_bio; % problematic!!
% for debugging:
% BIOSEMI = 0;
% BIO_LPT_ADDRESS = 0;

