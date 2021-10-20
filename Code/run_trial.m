function [Trial] = run_trial(session, Trial, prevTrial)

% Inattentional Blindness paradigm:
% Each trial includes presentation of the stimuli followed by a fixation.
% The stimuli are all displayed at once and include an image
% (face/house/noise) at the center of the screen and four discs (half red 
% half green) at each corner of the image. Subjects are asked either
% regarding the discs' orientation or the image type. Response collection
% occurs during fixation presentation.

% L.M., August 2017

global w phase GL

ResponsePixx('StartNow',1); % start response collection

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

% Photodiode
% Screen('FillRect', w, [0 0 0], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);

% Draw pixel trigger
pixelTrigger = double(session.stimuli.triggers.image);
glRasterPos2d(session.params.stimuli.pos.CTR(1), session.params.stimuli.pos.CTR(2)-200);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));

%% Set EEG trigger value
switch phase
    case 0 % practice block
        image_trig = session.triggers(1).Image_noise_p0;
    case 1
        switch Trial.ImageType
            case 1
                image_trig = session.triggers(1).Image_face_p1;
            case 2
                image_trig = session.triggers(1).Image_house_p1;
            case 3
                image_trig = session.triggers(1).Image_noise_p1;
        end
    case 2
        switch Trial.ImageType
            case 1
                image_trig = session.triggers(1).Image_face_p2;
            case 2
                image_trig = session.triggers(1).Image_house_p2;
            case 3
                image_trig = session.triggers(1).Image_noise_p2;
        end
    case 3
        switch Trial.ImageType
            case 1
                image_trig = session.triggers(1).Image_face_p3;
            case 2
                image_trig = session.triggers(1).Image_house_p3;
            case 3
                image_trig = session.triggers(1).Image_noise_p3;
        end
end

%% Display stimuli

% wait until expected display time is reached
while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > prevTrial.ExpImTime
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', image_trig); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Trial.ImTime_ptb = Screen('Flip',w);                        % present stimuli

Datapixx('RegWrRd');                                        % must read the register before getting the marker
Trial.ImTime = Datapixx('GetMarker');                       % retrieve the saved timing from the register

WaitSecs(0.004);                                            % for triggers to be sent seperatly
sendTriggers(session.triggers,Trial,'image');               % trial info triggers - sent after the flip

Trial.FixDur = Trial.ImTime - prevTrial.FixTime;            % calculate the exact fixation duration
Trial.FixDur_ptb = Trial.ImTime_ptb - prevTrial.FixTime_ptb;% also for ptb timing


%% Draw fixation

% Draw frame
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);
% Draw fixation
Screen('DrawTexture',w, session.stimuli.fixation.fixTex);

% Photodiode:
% Screen('FillRect', w, [255 255 255], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);

% Draw pixel trigger
pixelTrigger = double(session.stimuli.triggers.fixation);
glRasterPos2d(session.params.stimuli.pos.CTR(1), session.params.stimuli.pos.CTR(2)-200);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));


%% Display fixation

% wait until expected display time is reached
while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    lapse = t_now-Trial.ImTime;
    if lapse > session.params.timing.ImDurForFlip
        break % break one frame before target frame
    end
end

sendTriggers(session.triggers,Trial,'fix');  % send TTL at the next register write

Datapixx('SetMarker');                       % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);     % register write exactly when the pixels appear on screen

Trial.FixTime_ptb = Screen('Flip',w);        % present fixation

Datapixx('RegWrRd');                         % must read the register before getting the marker
Trial.FixTime = Datapixx('GetMarker');       % retrieve the saved timing from the register
WaitSecs(0.004);

Trial.ImDur = Trial.FixTime - Trial.ImTime;  % calculate the exact stimuli duration
Trial.ImDur_ptb = Trial.FixTime_ptb - Trial.ImTime_ptb; % also for ptb timing

%% Collect Response

% Set response time limit which is also the time for the next trial to begin
tempFixDur = rand(1)*session.params.timing.addFix + session.params.timing.minFix;
fixFrames = round(tempFixDur/session.params.timing.ifi);
Trial.ExpImTime = Trial.FixTime + session.params.timing.ifi*(fixFrames-0.5);

% wait until the time limit for two response events (press and release)
% [Response, RTfromStart] = ResponsePixx('GetLoggedResponses',2,1,session.params.timing.ifi*(fixFrames-0.5)-0.05);
[Trial.Response, Trial.RTfromStart] = getResponse(session.params.timing.ifi*(fixFrames-0.5)-0.05,session.triggers(1).Resp_START);

% if ~any(Response) %no response
%     Trial.Response = -1;
% else              % save only button press and not the release
%     Trial.Response=Response(1,:);
%     Trial.RTfromStart = RTfromStart(1);
% end

% decode each trial's logged response based on the response box mapping done at parameters initiation
[Trial] = saveResponse(session,Trial,phase);
% send response triggers
sendTriggers(session.triggers,Trial,'resp');

ResponsePixx('StopNow',1); % stop response collection

end