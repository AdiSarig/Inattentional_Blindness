function [session] = runPhase(session,phase)

global w

session.stimuli = initStimuli(session.params); % initialize all stimuli textures

if phase==0
    sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).PHASE_STARTED);
    [session] = runBlock(session,phase,1);
else
    %% PREPARE THE TRIAL MATRIX
    % Create the trial matrix for each phase
    % Trial Types: Image Type: 1=face 2=house 3=noise; Disc orientation: 1=same 2=diff
    session.Phase(phase).phaseTrialList = initTrialList(session.params.procedure);
    session.Phase(phase).startExp = GetSecs; % synchronize system and vpixx clocks and get their values
    sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).PHASE_STARTED);
    
    %% Run blocks
    for block=1:size(session.Phase(phase).phaseTrialList,3)
        [session] = runBlock(session,phase,block);
    end
end

%% Answer manipulation questions after each phase
if phase~=0
    sca
    [session.Phase(phase).postPhaseAns] = postPhase(session);
    w = initScreen();
end

sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).PHASE_ENDED);

end

