function [Trial] = initTrial(session,trialParam,phase)

Trial.ImageType       = trialParam(1); % 1=face, 2=house, 3=noise
Trial.ImageNum        = trialParam(2); % 1-12
Trial.DiscOrientation = trialParam(3); % 1=vertical, 2=horizontals
Trial.DiscRotation    = trialParam(4); % 1=same, 2=diff
Trial.DiscLocation    = trialParam(5); % 0=no rotation, 1=UL, 2=UR, 3=LL, 4=LR

Trial.imName = sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,...
    filesep, session.params.stimuli.stimFolder, filesep, trialParam(1),...
    trialParam(2));

[Trial.discs.n1,Trial.discs.n2,Trial.discs.n3,Trial.discs.n4]=rotateDiscs...
    (trialParam(3),trialParam(4),trialParam(5),session.params); % inputs: orientation v/h, change s/d, location 1/2/3/4

Trial.ExpImTime  = [];
Trial.ImTime  = [];
Trial.ImDur   = [];
Trial.FixTime = [];
Trial.FixDur  = [];

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

