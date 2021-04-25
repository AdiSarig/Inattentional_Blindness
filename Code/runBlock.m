function [session] = runBlock(session,phase,block)

global w

%% Assign trial list
if phase==0
    trialList=session.params.procedure.PracList;
else
    trialList=session.Phase(phase).phaseTrialList(:,:,block);
end

%% Initialize block
ntrials=size(trialList,1);
Trials(size(trialList,1)) = initTrial(session,trialList(1,:),phase); % create a temp last trial for pre allocation (gets run over in the loop)
for trialnum=1:ntrials 
    % Initialize all trials within a block
    Trials(trialnum) = initTrial(session,trialList(trialnum,:),phase);
end
% add trial numbers
counttrials = num2cell(1:ntrials);
[Trials(1:ntrials).TrialNum] = counttrials{:};

%% Starting Message
[~,Response] = blockInfo(session);

% an option to stop the experiment without saving
if Response(session.params.response.abortKey)
    sca
    error('Exp stopped running');
end

%% Start block
% synchronize system and vpixx clocks
if phase~=0
    session.Phase(phase).Blocks(block).startBlock = GetSecs;
    prevTrial.FixTime = session.Phase(phase).Blocks(block).startBlock;
else
    prevTrial.FixTime = GetSecs; % starting time saved as previous trial for the first trial to run proparly
end

sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).BLOCK_STARTED);

Screen('Flip',w); % remove block info

prevTrial.ExpImTime = prevTrial.FixTime + rand(1)*session.params.timing.addFix + session.params.timing.minFix; % generate the expected timing of the first stimulus

%% Run block
for trialnum=1:ntrials  
    % Present stimuli
    Trials(trialnum)=run_trial(session,Trials(trialnum),prevTrial);
    prevTrial = Trials(trialnum); % save previous trial for using the expected time for the image to appear and to calculate the duration from the delta (see run_trial)
end % of trial loop

%% Save block
if phase~=0 % don't save practice data
    
    % move all fixDur one trial up
    FixDurCell = {Trials(2:end).FixDur,0};
    [Trials.FixDur] = FixDurCell{:}; 
    
    % calc the last fixation duration
    lastFixOffset = Screen('Flip',w,Trials(end).ExpImTime);
    Trials(end).FixDur = lastFixOffset - Trials(end).ImTime;
    
    % remove experiment starting time from timings
    ImTimeCell             = num2cell([Trials.ImTime] - session.Phase(phase).startExp);
    [Trials.ImTime]        = ImTimeCell{:};
    FixTimeCell            = num2cell([Trials.FixTime] - session.Phase(phase).startExp);
    [Trials.FixTime]       = FixTimeCell{:};
    ExpImTimeCell          = num2cell([Trials.ExpImTime] - session.Phase(phase).startExp);
    [Trials.ExpImTime]     = ExpImTimeCell{:};
    RTfromStartCell        = num2cell([Trials.RTfromStart] - session.Phase(phase).startExp);
    RTfromStartCell([Trials.RTfromStart]<0)={-1};
    [Trials.RTfromStart]   = RTfromStartCell{:};
    
    % save trials into session struct
    session.Phase(phase).Blocks(block).trials   = Trials;
end

sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).BLOCK_ENDED);

if block ~= 5 % break before starting a new block
    ExpBreak = imread(sprintf('%s%c%s%cbreak.tif',session.params.defaultpath,filesep,session.params.stimuli.stimFolder,filesep));
    ExpBreakTex =  Screen('MakeTexture',w,ExpBreak);
    Screen('DrawTexture',w, ExpBreakTex);
    Screen('Flip',w);
    KbWait([],2);
else
    ExpBreak = imread(sprintf('%s%c%s%cbreak_end_of_phase.tif',session.params.defaultpath,filesep,session.params.stimuli.stimFolder,filesep));
    ExpBreakTex =  Screen('MakeTexture',w,ExpBreak);
    Screen('DrawTexture',w, ExpBreakTex);
    Screen('Flip',w);
    KbWait([],2);
end

end

