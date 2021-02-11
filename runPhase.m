function [session] = runPhase(session,phase)

global w

session.stimuli = initStimuli(session.params);

if phase==0
    PsychDataPixx('GetPreciseTime');        % sync system and Vpixx clocks
    [session] = runBlock(session,phase,1);
    Datapixx('SetDoutValues', session.triggers(1).PHASE_STARTED);
    Datapixx('RegWr');
else
    %% PREPARE THE TRIAL MATRIX
    % Create the trial matrix for each phase
    % Trial Types: Image Type: 1=face 2=house 3=noise; Disc orientation: 1=same 2=diff
    session.Phase(phase).phaseTrialList = initTrialList(session.params.procedure);
    [session.Phase(phase).startExpPtb,session.Phase(phase).startExpVpixx] = PsychDataPixx('GetPreciseTime'); % synchronize system and vpixx clocks and get their values
    Datapixx('SetDoutValues', session.triggers(1).PHASE_STARTED);
    Datapixx('RegWr');
    
    %% Initialize block
    for block=1:size(session.Phase(phase).phaseTrialList,3)
        [session] = runBlock(session,phase,block);
    end
end

%% Answer manipulation questions after each phase
if phase~=0
    sca
    [session.Phase(phase).postPhaseAns]=postPhase(session);
    w = initScreen();
end

Datapixx('SetDoutValues', session.triggers(1).PHASE_ENDED);
Datapixx('RegWr');

end

