function [Trial] = initTrial(session,trialParam,phase)
% Initiate one trial based on trial parameters and current phase
Trial.TrialNum = [];

Trial.ImageType       = trialParam(1); % 1=face, 2=house, 3=noise
Trial.ImageNum        = trialParam(2); % 1-12
Trial.DiscOrientation = trialParam(3); % 1=vertical, 2=horizontals
Trial.DiscRotation    = trialParam(4); % 1=same, 2=diff
Trial.DiscLocation    = trialParam(5); % 0=no rotation, 1=UL, 2=UR, 3=LL, 4=LR

Trial.imName = sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,...
    filesep, session.params.stimuli.stimFolder, filesep, trialParam(1),...
    trialParam(2));

% find image texture
if Trial.ImageType==1     % face
    Trial.imTex = session.stimuli.image(trialParam(2)).face;
elseif Trial.ImageType==2 % house
    Trial.imTex = session.stimuli.image(trialParam(2)).house;
else                      % noise
    Trial.imTex = session.stimuli.image(trialParam(2)).noise;
end

% find discs textures based on trial specificaions: orientation vertical/horizontal, change same/different, location 1/2/3/4
[Trial.discTex.n1,Trial.discTex.n2,Trial.discTex.n3,Trial.discTex.n4]=rotateDiscs...
    (trialParam(3),trialParam(4),trialParam(5),session.stimuli.Disc);

Trial.ExpImTime      = [];
Trial.ImTime         = [];
Trial.ImDur          = [];
Trial.FixTime        = [];
Trial.FixDur         = [];

% Trial.ImTime_ptb     = [];
% Trial.ImDur_ptb      = [];
% Trial.FixTime_ptb    = [];
% Trial.FixDur_ptb     = [];

% determine accuracy based on phase number - phase 3 the task is to identify the image type,
% in all other phases the task is to identify whether the discs changed orientation
if phase==3 
    Trial.CorrAns   = Trial.ImageType;
else
    Trial.CorrAns   = Trial.DiscRotation;
end

Trial.Response    = [];
Trial.Accuracy    = [];
Trial.RT          = [];
Trial.RTfromStart = [];

end

