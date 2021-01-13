function [session] = runPhase(session,phase)

if phase==0
    PsychDataPixx('GetPreciseTime');
    [session] = runBlock(session,phase,1);
else
    %% PREPARE THE TRIAL MATRIX
    % This section creates the trial matrix for each phase, using initTrialList function
    % Trial Types: Image Type: 1=face 2=house 3=noise; Disc orientation: 1=same 2=diff
    session.Phase(phase).phaseTrialList = initTrialList(session.params.procedure);
    [session.Phase(phase).startExpPtb,session.Phase(phase).startExpVpixx] = PsychDataPixx('GetPreciseTime'); % synchronize system and vpixx clocks and get their values
    
    %% Initialize block
    for block=1:size(session.Phase(phase).phaseTrialList,3)
        [session] = runBlock(session,phase,block);
    end
end

%% Answer manipulation questions after each phase
if phase~=0
    % [Ans1, Ans2, Ans3, Ans4, Ans5, Ans6]=postPhase();
end

end

