function [InfoTiming,Response] = blockInfo(Resp1d,DiscQuest1,DiscQuest2,Resp1im,ImQuest1,ImQuest2,textColor,RespboxRight)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global phase vpix_trig w
% Response=0;
ResponsePixx('StartNow',1);
Datapixx('EnablePixelMode');
Datapixx('RegWr');

vpix_trig_info_tex=Screen('MakeTexture',w,vpix_trig(:,17:24,:));
Screen('DrawTexture',w,vpix_trig_info_tex,[],[0 0 8 1]);
pixelTrigger = [255 0 255 0 255 0 255 0;0 0 0 0 0 0 0 0;0 255 0 255 0 255 0 255];
Datapixx('RegWrPixelSync',pixelTrigger);

if phase~=3
    if Resp1d==RespboxRight
        DrawFormattedText(w, DiscQuest1, 'center', 'center', textColor);
    else
        DrawFormattedText(w, DiscQuest2, 'center', 'center', textColor);
    end
    Datapixx('SetMarker');
    Screen('Flip',w);
    Datapixx('RegWrRd');
    InfoTiming=Datapixx('GetMarker');
    
    [Response] = ResponsePixx('GetLoggedResponses',2);
    Response=Response(1,:);
%     while ~any(Response)
%         [Response] = ResponsePixx('GetButtons');
%     end
else
    if Resp1im==RespboxRight
        DrawFormattedText(w, ImQuest1, 'center', 'center', textColor);
    else
        DrawFormattedText(w, ImQuest2, 'center', 'center', textColor);
    end
    Datapixx('SetMarker');
    Screen('Flip',w);
    Datapixx('RegWrRd');
    InfoTiming=Datapixx('GetMarker');
    
    [Response] = ResponsePixx('GetLoggedResponses',2);
    Response=Response(1,:);
%     while ~any(Response)
%         [Response] = ResponsePixx('GetButtons');
%     end
end

% ResponsePixx('StopNow',1);

end

