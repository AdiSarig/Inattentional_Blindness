function [InfoTiming,Response] = blockInfo(session)

global phase w

Datapixx('EnablePixelMode');
Datapixx('RegWr');
Datapixx('DisableDoutDinLoopback');
Datapixx('RegWr');
ResponsePixx('StartNow',1);

vpix_trig = session.stimuli.triggers.info;
vpix_trig_info_tex=Screen('MakeTexture',w,vpix_trig);
Screen('DrawTexture',w,vpix_trig_info_tex,[],[0 0 8 1]);
pixelTrigger = double([vpix_trig(:,:,1);vpix_trig(:,:,2);vpix_trig(:,:,3)]);
Datapixx('RegWrPixelSync',pixelTrigger);

instructions=session.params.procedure.instructions;
if phase~=3
    DrawFormattedText(w,instructions.disc , 'center', 'center', session.params.stimuli.text.colour);
    
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
    DrawFormattedText(w,instructions.image , 'center', 'center', session.params.stimuli.text.colour);
    
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

ResponsePixx('StopNow',1);

end

