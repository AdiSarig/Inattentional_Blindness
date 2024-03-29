function [session,is_error] = runPhase(session,phase)

global w

is_error = 0;
session.stimuli = initStimuli(session.params); % initialize all stimuli textures

if phase==0
    PsychDataPixx('GetPreciseTime');        % sync system and Vpixx clocks
    Datapixx('SetDoutValues', session.triggers(1).PHASE_STARTED);
    Datapixx('RegWr');
    WaitSecs(0.004);
    Datapixx('SetDoutValues', 0);
    Datapixx('RegWrRd');
    WaitSecs(0.004);
    [session] = runBlock(session,phase,1);
else
    %% PREPARE THE TRIAL MATRIX
    % Create the trial matrix for each phase
    % Trial Types: Image Type: 1=face 2=house 3=noise; Disc orientation: 1=same 2=diff
    session.Phase(phase).phaseTrialList = initTrialList(session.params.procedure);
    [session.Phase(phase).startExpPtb,session.Phase(phase).startExpVpixx] = PsychDataPixx('GetPreciseTime'); % synchronize system and vpixx clocks and get their values
    Datapixx('SetDoutValues', session.triggers(1).PHASE_STARTED);
    Datapixx('RegWr');
    WaitSecs(0.004);
    Datapixx('SetDoutValues', 0);
    Datapixx('RegWrRd');
    WaitSecs(0.004);
    
    %% Run blocks
    for block=1:size(session.Phase(phase).phaseTrialList,3)
        try
            [session] = runBlock(session,phase,block);
        catch
            is_error = 1;
            return
        end
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
WaitSecs(0.004);
Datapixx('SetDoutValues', 0);
Datapixx('RegWrRd');
WaitSecs(0.004);

end

