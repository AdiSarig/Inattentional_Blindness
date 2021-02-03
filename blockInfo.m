function [InfoTiming,Response] = blockInfo(session)
% display block info based on phase and counterbalancing and wait for
% response

global phase w

ResponsePixx('StartNow',1);

% Draw info pixel trigger
vpix_trig = session.stimuli.triggers.info;
vpix_trig_info_tex=Screen('MakeTexture',w,vpix_trig);
Screen('DrawTexture',w,vpix_trig_info_tex,[],[0 0 8 1]);

% Send TTL at the next register write
doutValue = bin2dec('0000 0000 0000 1111 1111 1111');
Datapixx('SetDoutValues', doutValue);

% Register write exactly when the pixels appear on screen
pixelTrigger = double([vpix_trig(:,:,1);vpix_trig(:,:,2);vpix_trig(:,:,3)]);
Datapixx('RegWrPixelSync',pixelTrigger,3000);

instructions=session.params.procedure.instructions;
if phase~=3
    DrawFormattedText(w,instructions.disc , 'center', 'center', session.params.stimuli.text.colour);
    
    Datapixx('SetMarker');            % save the onset of the next register write
    Screen('Flip',w);
    Datapixx('RegWrRd');              % must read the register before getting the marker
    InfoTiming=Datapixx('GetMarker'); % retrieve the saved timing
    
    [Response] = ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
    Response=Response(1,:);
else
    DrawFormattedText(w,instructions.image , 'center', 'center', session.params.stimuli.text.colour);
    
    Datapixx('SetMarker');            % save the onset of the next register write
    Screen('Flip',w);
    Datapixx('RegWrRd');              % must read the register before getting the marker
    InfoTiming=Datapixx('GetMarker'); % retrieve the saved timing
    
    [Response] = ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
    Response=Response(1,:);
end

ResponsePixx('StopNow',1);

end

