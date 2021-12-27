function [InfoTiming,Response] = blockInfo(session, block)
% display block info based on phase and counterbalancing and wait for
% response

global phase w GL

ResponsePixx('StartNow',1); % start response collection

% Draw info pixel trigger
pixelTrigger = double(session.stimuli.triggers.info);
glRasterPos2d(10, 1);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));

% Send TTL at the next register write
Datapixx('SetDoutValues', session.triggers(1).BLOCK_INFO);

instructions=session.params.procedure.instructions;
if phase~=3 % instructions for phase 1/2: answer regarding the discs
    info = imread(instructions.disc);
    infoTex =  Screen('MakeTexture',w,info);
    Screen('DrawTexture',w, infoTex);
%     DrawFormattedText(w,instructions.disc , 'center', 'center', session.params.stimuli.text.colour);
    Datapixx('SetMarker');                   % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger); % register write exactly when the pixels appear on screen
    Screen('Flip',w);                        % present block info
    Datapixx('RegWrRd');                     % must read the register before getting the marker
    InfoTiming=Datapixx('GetMarker');        % retrieve the saved timing from the register
    
    WaitSecs(0.001);
    [Response] = ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
    Response=Response(1,:);
else % instructions for phase 3: answer regarding the images
    info = imread(instructions.image);
    infoTex =  Screen('MakeTexture',w,info);
    Screen('DrawTexture',w, infoTex);
%     DrawFormattedText(w,instructions.image , 'center', 'center', session.params.stimuli.text.colour);
    Datapixx('SetMarker');                   % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger); % register write exactly when the pixels appear on screen
    Screen('Flip',w);                        % present block info
    Datapixx('RegWrRd');                     % must read the register before getting the marker
    InfoTiming=Datapixx('GetMarker');        % retrieve the saved timing from the register
    
    WaitSecs(0.001);
    [Response] = ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
    Response=Response(1,:);
end

% display progress indication
if phase == 0
    progress_indication = 'Practice session';
else
    progress_indication = sprintf('Block %d / %d, Phase %d / %d',...
        block, session.params.procedure.numBlocks, phase, session.params.procedure.numPhases);
end
DrawFormattedText(w,progress_indication , 'center', 'center', session.params.stimuli.text.colour);
Screen('Flip',w);
WaitSecs(3);

% get ready to start
DrawFormattedText(w,'3' , 'center', 'center', session.params.stimuli.text.colour);
Screen('Flip',w);
WaitSecs(1);
DrawFormattedText(w,'2' , 'center', 'center', session.params.stimuli.text.colour);
Screen('Flip',w);
WaitSecs(1);
DrawFormattedText(w,'1' , 'center', 'center', session.params.stimuli.text.colour);
Screen('Flip',w);
WaitSecs(1);

ResponsePixx('StopNow',1); % stop response collection

end

