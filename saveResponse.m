function [Trial] = saveResponse(session,Trial,phase)

if Trial.Response == -1 %no response
    Trial.Accuracy = -1;
    Trial.RTfromStart = -1;
    Trial.RT = -1;
else
    Trial.RT = Trial.RTfromStart - Trial.ImTime - 0.005; % there is a deviation between markers and the display, stimuli are actually presented 5ms after marker time
    Response=find(Trial.Response);
    if phase==3  % face/house/noise responses
        if Response == session.params.response.face %face stim
            Trial.Response=1;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        elseif Response == session.params.response.house %house stim
            Trial.Response=2;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        elseif Response == session.params.response.noise %noise stim
            Trial.Response=3;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        else % wrong button
            Trial.Response = 99;
            Trial.Accuracy = 0;
        end
    else
        if Response == session.params.response.discSame % same orientation
            Trial.Response=1;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        elseif Response == session.params.response.discDiff % changed orientation
            Trial.Response=2;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        else % wrong button
            Trial.Response = 99;
            Trial.Accuracy = 0;
        end
    end
end 

end

