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
    % Save data
    fileName = sprintf('..%cdata%cIB_Sub_%d_partial',filesep,filesep,session.subjnum);
    try
        save(fileName,'session');
    catch
        mkdir(sprintf('..%cdata',filesep));
        save(fileName,'session');
    end
    ResponsePixx('Close');Datapixx('Close');sca
    error('Exp stopped running');
end

%% Start block
% synchronize system and vpixx clocks
if phase~=0
    [session.Phase(phase).Blocks(block).startBlockPtb,session.Phase(phase).Blocks(block).startBlockVpixx] = PsychDataPixx('GetPreciseTime');
    prevTrial.FixTime = session.Phase(phase).Blocks(block).startBlockVpixx; % starting time saved as previous trial for the first trial to run proparly
    prevTrial.FixTime_ptb = session.Phase(phase).Blocks(block).startBlockPtb;
else
    [prevTrial.FixTime_ptb, prevTrial.FixTime] = PsychDataPixx('GetPreciseTime'); % starting time saved as previous trial for the first trial to run proparly
end

Datapixx('SetDoutValues', session.triggers(1).BLOCK_STARTED); % send TTL of block start at the next register write
Datapixx('RegWrRd');
WaitSecs(0.004);
Datapixx('SetDoutValues', 0);
Datapixx('RegWrRd');
WaitSecs(0.004);

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
    FixDur_ptbCell = {Trials(2:end).FixDur_ptb,0};
    [Trials.FixDur_ptb] = FixDur_ptbCell{:}; 
    
    % calc the last fixation duration
    Datapixx('SetMarker');
    lastFixOffset_ptb = Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',Trials(end).ExpImTime));
    Datapixx('RegWrRd');
    lastFixOffset=Datapixx('GetMarker');

    Trials(end).FixDur = lastFixOffset - Trials(end).ImTime;
    Trials(end).FixDur_ptb = lastFixOffset_ptb - Trials(end).ImTime_ptb;
    
    % remove experiment starting time from timings
    ImTimeCell             = num2cell([Trials.ImTime] - session.Phase(phase).startExpVpixx);
    [Trials.ImTime]        = ImTimeCell{:};
    FixTimeCell            = num2cell([Trials.FixTime] - session.Phase(phase).startExpVpixx);
    [Trials.FixTime]       = FixTimeCell{:};
    ImTime_ptbCell         = num2cell([Trials.ImTime_ptb] - session.Phase(phase).startExpPtb);
    [Trials.ImTime_ptb]    = ImTime_ptbCell{:};
    FixTime_ptbCell        = num2cell([Trials.FixTime_ptb] - session.Phase(phase).startExpPtb);
    [Trials.FixTime_ptb]   = FixTime_ptbCell{:};
    ExpImTimeCell          = num2cell([Trials.ExpImTime] - session.Phase(phase).startExpVpixx);
    [Trials.ExpImTime]     = ExpImTimeCell{:};
    RTfromStartCell        = num2cell([Trials.RTfromStart] - session.Phase(phase).startExpVpixx);
    RTfromStartCell([Trials.RTfromStart]<0)={-1};
    [Trials.RTfromStart]   = RTfromStartCell{:};
    
    % save trials into session struct
    session.Phase(phase).Blocks(block).trials   = Trials;
end

Datapixx('SetDoutValues', session.triggers(1).BLOCK_ENDED);
Datapixx('RegWrRd');
WaitSecs(0.004);
Datapixx('SetDoutValues', 0);
Datapixx('RegWrRd');
WaitSecs(0.004);

if block ~= session.params.procedure.numBlocks % break before starting a new block
    ResponsePixx('StartNow',1); % start response collection
    ExpBreak = imread(sprintf('%s%c%s%cbreak.tif',session.params.defaultpath,filesep,session.params.stimuli.stimFolder,filesep));
    ExpBreakTex =  Screen('MakeTexture',w,ExpBreak);
    Screen('DrawTexture',w, ExpBreakTex);
    Screen('Flip',w);
    ResponsePixx('GetLoggedResponses',2);
    ResponsePixx('StopNow',1); % stop response collection
else
    ResponsePixx('StartNow',1); % start response collection
    ExpBreak = imread(sprintf('%s%c%s%cbreak_end_of_phase.tif',session.params.defaultpath,filesep,session.params.stimuli.stimFolder,filesep));
    ExpBreakTex =  Screen('MakeTexture',w,ExpBreak);
    Screen('DrawTexture',w, ExpBreakTex);
    Screen('Flip',w);
    ResponsePixx('GetLoggedResponses',2);
    ResponsePixx('StopNow',1); % stop response collection
end

end

