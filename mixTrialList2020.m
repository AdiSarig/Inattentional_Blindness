function  [trialList] = mixTrialList2020(numTrials)

% The script below is based on the one used for the Biderman & Mudrik,
% 2017 study.

% This script creates trial lists for inattentional blindness with two orthogonal tasks (face/house/noise X changed/unchanges disc orientation)
% numTrials must be multiplication of numStim and of 4

% L.M., August 2017
% ------------------------------------------------------------------
numStim=12; % number of different stimuli for each type (face/house/noise); must be multiplication of 4
numBlocks=5;
numCol=5; % columns: image_levels (face/house/noise), image_num (1:numStim), discOrientation (horizontal/vertical), changeDisc (whether one of the discs changes),locations (which of the 4 changes)
trialList=zeros(numTrials,numCol,numBlocks);

%% Prepare the trial matrix
% create basic matrices with all the conditions for each block
for block=1:numBlocks
    image_levels=[ones(numTrials/3,1);ones(numTrials/3,1)+1;ones(numTrials/3,1)+2]; % image type (face/house/noise)
    image_num=randperm(numStim)'; % image vec randomized
    for ind=1:numTrials/numStim-1
        image_num=[image_num;randperm(numStim)'];
    end
    discOrientation=repmat([ones(numTrials/6,1);ones(numTrials/6,1)+1],3,1); % all 4 discs orientation (vertical/horizontal)
    changeDisc=repmat([ones(numTrials/12,1);ones(numTrials/12,1)+1],6,1); % change orentation of one disc
    
    locByStim=repmat((1:4)',numStim/4,1); % which disc to change, 25% for each location
    scrambeled_loc=[locByStim(randperm(length(locByStim)));locByStim(randperm(length(locByStim)));locByStim(randperm(length(locByStim)))]; % scramble seperately by stim so that each type (face/house/noise) would have 25% of each location
    locations=zeros(size(changeDisc));
    locations(changeDisc==2)=scrambeled_loc;
    
    trialList(:,:,block)=[image_levels,image_num,discOrientation,changeDisc,locations];
end

%% Trials randomization

% mix matrices and check whether the constraints are met; if not, shuffle again
for block=1:numBlocks
    conditionsMet = 0;
    while ~conditionsMet
        RandTrialList = trialList(randperm(size(trialList,1)),:,block); % randomize the order of the trials
        conditionsMet = 1;   
        if RandTrialList(1,1)~=3 % start with noise trial
            conditionsMet = 0;
        end
        for j=1:(numTrials-3) % check if there are 4 consecutive identical stimulus types
            if RandTrialList(j,1)==RandTrialList(j+1,1) && RandTrialList(j+1,1)==RandTrialList(j+2,1) && RandTrialList(j+2,1)==RandTrialList(j+3,1)
                conditionsMet = 0;
            end
        end
    end
    trialList(:,:,block)=RandTrialList;
end

