function [Trial] = saveResponse(session,Trial,phase)
% decode the logged responses based on key allocation done in parameters initiation

if Trial.Response == -1 %no response
    Trial.Accuracy = -1;
    Trial.RT = -1;
else
    Trial.RT = Trial.RTfromStart - Trial.ImTime;
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
    else        % disc orientation responses (same/different)
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

