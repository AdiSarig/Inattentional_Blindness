function [InfoTiming,Response] = blockInfo(session)
% display block info based on phase and counterbalancing and wait for
% response

global phase w GL

ResponsePixx('StartNow',1);

% Draw info pixel trigger
pixelTrigger = double(session.stimuli.triggers.info);
glRasterPos2d(10, 1);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));

% Send TTL at the next register write
Datapixx('SetDoutValues', session.triggers(1).BLOCK_INFO);

instructions=session.params.procedure.instructions;
if phase~=3
    DrawFormattedText(w,instructions.disc , 'center', 'center', session.params.stimuli.text.colour);
    Datapixx('SetMarker');                   % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger); % register write exactly when the pixels appear on screen
    Screen('Flip',w);                        % present block info
    Datapixx('RegWrRd');                     % must read the register before getting the marker
    InfoTiming=Datapixx('GetMarker');        % retrieve the saved timing from the register
    
    [Response] = ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
    Response=Response(1,:);
else
    DrawFormattedText(w,instructions.image , 'center', 'center', session.params.stimuli.text.colour);
    Datapixx('SetMarker');                   % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger); % register write exactly when the pixels appear on screen
    Screen('Flip',w);                        % present block info
    Datapixx('RegWrRd');                     % must read the register before getting the marker
    InfoTiming=Datapixx('GetMarker');        % retrieve the saved timing from the register
    
    [Response] = ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
    Response=Response(1,:);
end

ResponsePixx('StopNow',1);

end

