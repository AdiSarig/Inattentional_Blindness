function [InfoTiming,Response] = blockInfo(session)
% display block info based on phase and counterbalancing and wait for
% response

global phase w

instructions=session.params.procedure.instructions;
if phase~=3 % instructions for phase 1/2: answer regarding the discs
    info = imread(instructions.disc);
else % instructions for phase 3: answer regarding the images
    info = imread(instructions.image);
end

infoTex =  Screen('MakeTexture',w,info);
Screen('DrawTexture',w, infoTex);
InfoTiming = Screen('Flip',w);                        % present block info
sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).BLOCK_INFO);

% unlimited wait for any response
[~, Response] = KbWait([], 2);

% Get ready countdown
DrawFormattedText(w,'3' , 'center', 'center', session.params.stimuli.text.colour);
Screen('Flip',w);
WaitSecs(1);
DrawFormattedText(w,'2' , 'center', 'center', session.params.stimuli.text.colour);
Screen('Flip',w);
WaitSecs(1);
DrawFormattedText(w,'1' , 'center', 'center', session.params.stimuli.text.colour);
Screen('Flip',w);
WaitSecs(1);


end

