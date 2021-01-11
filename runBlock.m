function [session] = runBlock(session,phase,block)

global w

if phase==0
    trialList=PracList;
else
    trialList=session.Phase(phase).phaseTrialList(:,:,block);
end

% Starting Message
[~,Response] = blockInfo(session);

% an option to stop the experiment: escape key
if Response(session.params.response.abortKey)
    Screen('CloseAll'); % graceful abort
    error('Exp stopped running'); % find a better way to do so
end

%% Initialize block
ntrials=size(trialList,1);
if phase~=0
    [session.Phase(phase).Blocks(block).startBlockPtb,session.Phase(phase).Blocks(block).startBlockVpixx] = PsychDataPixx('GetPreciseTime'); % synchronize system and vpixx clocks
else
    PsychDataPixx('GetPreciseTime');
end
Datapixx('SetMarker');
Screen('Flip',w);
Datapixx('RegWrRd');
prevTrial.FixTime=Datapixx('GetMarker'); % start of block
prevTrial.ExpImTime=prevTrial.FixTime + rand(1)*session.params.timing.addFix + session.params.timing.minFix;

for trialnum=1:ntrials
    % Initialize trial
    Trials(trialnum) = initTrial(session,trialList(trialnum,:),phase);
    
    % Present stimuli
    Trials(trialnum)=run_trial(session,Trials(trialnum),prevTrial);
    prevTrial = Trials(trialnum);
    
end % of trial loop

if phase~=0 % don't save practice data
    % move up one trial all fixDur
    FixDurCell = {Trials(2:end).FixDur,0};
    [Trials.FixDur] = FixDurCell{:}; 
    
    % calc the last fixation duration
    Datapixx('SetMarker');
    Screen('Flip',w);
    Datapixx('RegWrRd');
    lastFixTime=Datapixx('GetMarker');
    delta=lastFixTime-Trials(end).ImTime;
    numberOfFrames = ceil(delta*session.params.timing.refreshRate);
    Trials(end).FixDur = numberOfFrames/session.params.timing.refreshRate;
    
    % remove experiment starting time from timings:
    ImTimeCell             = num2cell([Trials.ImTime] - session.Phase(phase).startExpVpixx);
    [Trials.ImTime]        = ImTimeCell{:};
    FixTimeCell            = num2cell([Trials.FixTime] - session.Phase(phase).startExpVpixx);
    [Trials.FixTime]       = FixTimeCell{:};
    RTfromStartCell        = num2cell([Trials.RTfromStart] - session.Phase(phase).startExpVpixx);
    [Trials.RTfromStart]   = RTfromStartCell{:};
    
    % save trials into session struct
    session.Phase(phase).Blocks(block).trials   = Trials;
end

end

