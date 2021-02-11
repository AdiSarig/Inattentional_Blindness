function [Trial]=run_trial(session,Trial, prevTrial)

% Inattentional Blindness paradigm:
% Each trial includes presentation of the stimuli followed by a fixation.
% The stimuli are all displayed at once and include an image
% (face/house/noise) at the center of the screen and four discs (half red 
% half green) at each corner of the image. Subjects are asked either
% regarding the discs' orientation or the image type. Response collection
% occurs during fixation presentation.

% L.M., August 2017

global w phase

%% definitions
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % this enables us to use the alpha transparency
ResponsePixx('StartNow',1);

%% Draw STIMULI - Image + discs

Screen('DrawTexture',w, Trial.imTex,[],[],[],[], session.params.stimuli.stimContrast);

position = session.params.stimuli.pos;
disc1Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.ULdisc(1),position.ULdisc(2));
Screen('DrawTexture',w, Trial.discTex.n1,[],disc1Loc,[],[], session.params.stimuli.stimContrast);
disc2Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.URdisc(1),position.URdisc(2));
Screen('DrawTexture',w, Trial.discTex.n2,[],disc2Loc,[],[], session.params.stimuli.stimContrast);
disc3Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.LLdisc(1),position.LLdisc(2));
Screen('DrawTexture',w, Trial.discTex.n3,[],disc3Loc,[],[], session.params.stimuli.stimContrast);
disc4Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.LRdisc(1),position.LRdisc(2));
Screen('DrawTexture',w, Trial.discTex.n4,[],disc4Loc,[],[], session.params.stimuli.stimContrast);

Screen('DrawTexture',w,session.stimuli.triggers.imageTex,[],[0 0 8 1]);
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-400 session.params.stimuli.pos.CTR+400],2);

%% Display stimuli

% Send TTL at the next register write
Datapixx('SetDoutValues', session.triggers(1).Trial_START);

% Register write exactly when the pixels appear on screen
pixelTrigger = double([session.stimuli.triggers.image(:,:,1);session.stimuli.triggers.image(:,:,2);session.stimuli.triggers.image(:,:,3)]);
Datapixx('RegWrPixelSync',pixelTrigger,3);

Datapixx('SetMarker');                % save the onset of the next register write
Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',prevTrial.ExpImTime+0.005));% present the stimulus
Datapixx('RegWrRd');                  % must read the register before getting the marker
Trial.ImTime = Datapixx('GetMarker'); % retrieve the saved timing

sendTriggers(session.triggers,Trial,'image'); % trial info triggers - sent after the flip
% Calculate the exact timing according to the refresh rate
delta = Trial.ImTime-prevTrial.FixTime;
% numberOfFrames = ceil(delta*session.params.timing.refreshRate);
% Trial.FixDur = numberOfFrames/session.params.timing.refreshRate;
Trial.FixDur = delta;

%% Draw fixation

Screen('DrawTexture',w, session.stimuli.fixation.fixTex);
Screen('DrawTexture',w, session.stimuli.triggers.fixationTex,[],[0 0 8 1]);
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-400 session.params.stimuli.pos.CTR+400],2);

%% Display fixation

% Send TTL at the next register write
sendTriggers(session.triggers,Trial,'fix');

% Register write exactly when the pixels appear on screen
pixelTrigger = double([session.stimuli.triggers.fixation(:,:,1);session.stimuli.triggers.fixation(:,:,2);session.stimuli.triggers.fixation(:,:,3)]);
Datapixx('RegWrPixelSync',pixelTrigger,3);

Datapixx('SetMarker');               % save the onset of the next register write
Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',Trial.ImTime+session.params.timing.ImDur+0.005));
Datapixx('RegWrRd');                 % must read the register before getting the marker
Trial.FixTime=Datapixx('GetMarker'); % retrieve the saved timing

% Calculate the exact timing according to the refresh rate
delta=Trial.FixTime-Trial.ImTime;
% numberOfFrames = ceil(delta*session.params.timing.refreshRate);
% Trial.ImDur = numberOfFrames/session.params.timing.refreshRate;
Trial.ImDur = delta;

%% Collect Response

% Set response time limit which is also the time for the next trial to begin
tempFixDur=rand(1)*session.params.timing.addFix + session.params.timing.minFix;
fixFrames = round(tempFixDur/session.params.timing.ifi);
Trial.ExpImTime=Trial.FixTime + session.params.timing.ifi*(fixFrames-0.5);

% wait until the time limit for two response events (press and release)
[Response, RTfromStart] = ResponsePixx('GetLoggedResponses',2,1,session.params.timing.ifi*(fixFrames-0.5)-0.05);

if ~any(Response) %no response
    Trial.Response = -1;
else              % save only button press and not the release
    Trial.Response=Response(1,:);
    Trial.RTfromStart = RTfromStart(1);
end

% decode each trial's logged response based on the response box mapping done at parameters initiation
[Trial] = saveResponse(session,Trial,phase);
% send response triggers
sendTriggers(session.triggers,Trial,'resp');

ResponsePixx('StopNow',1);

end