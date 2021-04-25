function followupTriggers(session,Trial,cmd)
% Send additional triggers following stimuli presentation and response
% collection to provide more information for the analysis

global phase

if strcmp(cmd,'stim') % stimuli triggers
    % trial number in block
    sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,Trial.TrialNum);
    
    % face / house / noise
    switch Trial.ImageType
        case 1
            sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Image_face);
        case 2
            sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Image_house);
        case 3
            sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Image_noise);
    end
    
    % image number 1-12
    sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).imageNum(Trial.ImageNum).num);
    
    % disc orientation - vertical / horizontal
    switch Trial.DiscOrientation
        case 1
            sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Disc_vertical);
        case 2
            sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Disc_horizontal);
    end
    
    % disc rotation - all the same or one rotated
    switch Trial.DiscRotation
        case 1
            sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Disc_same);
        case 2
            sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Disc_diff);
    end
    
    % Location of the rotated disc - 0 for no rotation, 1-4 (UL, UR, LL, LR)
    sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).discLocNum(Trial.DiscLocation+1).loc);
    
elseif strcmp(cmd,'resp') % response triggers
    if phase == 3
        switch Trial.Response
            case 1
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_Image_face);
            case 2
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_Image_house);
            case 3
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_Image_noise);
        end
    else
        switch Trial.Response
            case 1
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_Disc_same);
            case 2
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_Disc_diff);
        end
    end
    if Trial.Response == 99
        sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).RESP_ERROR);
        sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_inCorr);
    else
        switch Trial.Accuracy
            case 0
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_inCorr);
            case 1
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_Corr);
            case -1
                sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).RESP_missing);
        end
    end
end

end

