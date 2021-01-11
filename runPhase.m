function [session] = runPhase(session,phase)

% PREPARE THE TRIAL MATRIX
% This section creates the trial matrix for each phase, using a function
% Trial Types: Image Type: 1=face 2=house 3=noise; Disc orientation: 1=same 2=diff
session.Phase(phase).phaseTrialList = initTrialList(session.params.procedure);

if phase~=0
    [session.Phase(phase).startExpPtb,session.Phase(phase).startExpVpixx] = PsychDataPixx('GetPreciseTime'); % synchronize system and vpixx clocks and get their values
else
    PsychDataPixx('GetPreciseTime');
end

%% Initialize block
for block=1:size(session.Phase(phase).phaseTrialList,3)
    [session] = runBlock(session,phase,block);
end

%% Answer manipulation questions after each phase
if phase~=0 
    % [Ans1, Ans2, Ans3, Ans4, Ans5, Ans6]=postPhase();
end

end

