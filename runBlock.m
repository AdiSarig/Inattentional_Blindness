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
    Screen('CloseAll');
    error('Exp stopped running');
end

%% Start block
% synchronize system and vpixx clocks
if phase~=0
    [session.Phase(phase).Blocks(block).startBlockPtb,session.Phase(phase).Blocks(block).startBlockVpixx] = PsychDataPixx('GetPreciseTime');
    Datapixx('SetDoutValues', session.triggers(1).BLOCK_STARTED); % send TTL of block start at the next register write
    Datapixx('RegWr');
    prevTrial.FixTime = session.Phase(phase).Blocks(block).startBlockVpixx; % starting time saved as previous trial for the first trial to run proparly
else
end

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
    Datapixx('SetMarker');
    Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',Trials(trialnum).ExpImTime));
    Datapixx('RegWrRd');
    lastFixOffset=Datapixx('GetMarker');

    Trials(end).FixDur = lastFixOffset - Trials(end).ImTime;
    
    % remove experiment starting time from timings
    ImTimeCell             = num2cell([Trials.ImTime] - session.Phase(phase).startExpVpixx);
    [Trials.ImTime]        = ImTimeCell{:};
    FixTimeCell            = num2cell([Trials.FixTime] - session.Phase(phase).startExpVpixx);
    [Trials.FixTime]       = FixTimeCell{:};
    ExpImTimeCell          = num2cell([Trials.ExpImTime] - session.Phase(phase).startExpVpixx);
    [Trials.ExpImTime]     = ExpImTimeCell{:};
    RTfromStartCell        = num2cell([Trials.RTfromStart] - session.Phase(phase).startExpVpixx);
    RTfromStartCell([Trials.RTfromStart]<0)={-1};
    [Trials.RTfromStart]   = RTfromStartCell{:};
    sca
    % save trials into session struct
    session.Phase(phase).Blocks(block).trials   = Trials;
end

Datapixx('SetDoutValues', session.triggers(1).BLOCK_ENDED);
Datapixx('RegWr');

end

