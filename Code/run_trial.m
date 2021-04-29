function [Trial] = run_trial(session, Trial, prevTrial)

% Inattentional Blindness paradigm:
% Each trial includes presentation of the stimuli followed by a fixation.
% The stimuli are all displayed at once and include an image
% (face/house/noise) at the center of the screen and four discs (half red 
% half green) at each corner of the image. Subjects are asked either
% regarding the discs' orientation or the image type. Response collection
% occurs during fixation presentation.

global w phase

%% Draw STIMULI
% Draw frame
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);
% Draw background
Screen('DrawTexture',w, session.stimuli.bgNoise(Trial.ImageNum),[],[],[],[], session.params.stimuli.stimContrast);
% Draw image
Screen('DrawTexture',w, Trial.imTex,[],[],[],[], session.params.stimuli.stimContrast);
% Draw discs
position = session.params.stimuli.pos;
disc1Loc = CenterRectOnPointd(session.stimuli.Disc.discSize,position.ULdisc(1),position.ULdisc(2));
Screen('DrawTexture',w, Trial.discTex.n1,[],disc1Loc,[],[], session.params.stimuli.stimContrast);
disc2Loc = CenterRectOnPointd(session.stimuli.Disc.discSize,position.URdisc(1),position.URdisc(2));
Screen('DrawTexture',w, Trial.discTex.n2,[],disc2Loc,[],[], session.params.stimuli.stimContrast);
disc3Loc = CenterRectOnPointd(session.stimuli.Disc.discSize,position.LLdisc(1),position.LLdisc(2));
Screen('DrawTexture',w, Trial.discTex.n3,[],disc3Loc,[],[], session.params.stimuli.stimContrast);
disc4Loc = CenterRectOnPointd(session.stimuli.Disc.discSize,position.LRdisc(1),position.LRdisc(2));
Screen('DrawTexture',w, Trial.discTex.n4,[],disc4Loc,[],[], session.params.stimuli.stimContrast);

% Photodiode test
% Screen('FillRect', w, [0 0 0], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);


%% Display stimuli

Trial.ImTime = Screen('Flip',w,prevTrial.ExpImTime);     % present stimuli
sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Trial_START);

% send all other triggers
followupTriggers(session,Trial,'stim')

Trial.FixDur = Trial.ImTime - prevTrial.FixTime;         % calculate fixation duration

%% Draw fixation

% Draw frame
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);
% Draw fixation
Screen('DrawTexture',w, session.stimuli.fixation.fixTex);

% Photodiode test
% Screen('FillRect', w, [255 255 255], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);

%% Display fixation

Trial.FixTime = Screen('Flip',w,Trial.ImTime+session.params.timing.ImDurForFlip); % present fixation

switch Trial.ImageType % send TTL
    case 1
        sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers.Fix_face);
    case 2
        sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers.Fix_house);
    case 3
        sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers.Fix_noise);
end

Trial.ImDur = Trial.FixTime - Trial.ImTime;  % calculate stimuli duration

%% Collect Response

% Set response time limit which is also the time for the next trial to begin
tempFixDur = rand(1)*session.params.timing.addFix + session.params.timing.minFix;
fixFrames = round(tempFixDur/session.params.timing.ifi);
Trial.ExpImTime = Trial.FixTime + session.params.timing.ifi*(fixFrames-0.5);

keyIsDown = 0;
while ~keyIsDown
    [keyIsDown, Trial.RTfromStart, Trial.Response] = KbCheck;
    if keyIsDown
        sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).Resp_START);
    end
    if GetSecs > Trial.ExpImTime
        Trial.Response = -1;
        sendTriggers(session.triggers.biosemi,session.triggers.LPT_address,session.triggers(1).RESP_missing);
        break
    end
end

% decode each trial's logged response based on key allocation done in parameters initiation
[Trial] = saveResponse(session,Trial,phase);
% send response triggers
followupTriggers(session,Trial,'resp')

end