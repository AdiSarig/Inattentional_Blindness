function [Trial]=run_trial(session,Trial, prevTrial)

% The script below is identical to the one used for the Biderman & Mudrik,
% 2017 study (includng sections which could have probably been programmed
% better; we only added comments to help researchers who are interested
% in using the code find their way in it.

% -----------------------------------------------------
% this script presents the stimulation sequence in Exp. 1s. It gets many input
% variables from the experimental script, which define the different trial
% parameters and presentation conditions. It returns the codes of the
% events which were presented and their timings. The events codes are built
% such that each trial gets a certain code (ttl), according to it's
% characteristics. Then, an additional number is added, which marks the
% specific event: is it a fixation, a mask, a blank or a prime.

% L.M., August 2017

% -----------------------------------------------------
% https://www.vpixx.com/manuals/psychtoolbox/html/DigitalIODemo5.html
% https://www.vpixx.com/manuals/psychtoolbox/html/PROPixxDemo5.html
% https://vpixx.com/vocal/introduction-to-registers-and-schedules/

global w phase

%% definitions
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);             % this enables us to use the alpha transparency
ResponsePixx('Close');
ResponsePixx('Open');
ResponsePixx('StartNow',1);

%% Read stimuli

% image
image      =  imread(Trial.imName);
imTex      =  Screen('MakeTexture',w,image);

%% Draw STIMULI - Image + discs

Screen('DrawTexture',w, imTex,[],[],[],[], session.params.stimuli.stimContrast);

position = session.params.stimuli.pos;
% discSize=[0,0,size(Trial.discs.n1,1),size(Trial.discs.n1,2)];
disc1Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.ULdisc(1),position.ULdisc(2));
Screen('DrawTexture',w, Trial.discs.n1,[],disc1Loc,[],[], session.params.stimuli.stimContrast);
disc2Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.URdisc(1),position.URdisc(2));
Screen('DrawTexture',w, Trial.discs.n2,[],disc2Loc,[],[], session.params.stimuli.stimContrast);
disc3Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.LLdisc(1),position.LLdisc(2));
Screen('DrawTexture',w, Trial.discs.n3,[],disc3Loc,[],[], session.params.stimuli.stimContrast);
disc4Loc=CenterRectOnPointd(session.stimuli.Disc.discSize,position.LRdisc(1),position.LRdisc(2));
Screen('DrawTexture',w, Trial.discs.n4,[],disc4Loc,[],[], session.params.stimuli.stimContrast);

Screen('DrawTexture',w,session.stimuli.triggers.imageTex,[],[0 0 8 1]);
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-400 session.params.stimuli.pos.CTR+400],2);

%% Present stimuli

Datapixx('EnablePixelMode');
Datapixx('RegWr');

pixelTrigger = double([session.stimuli.triggers.image(:,:,1);session.stimuli.triggers.image(:,:,2);session.stimuli.triggers.image(:,:,3)]);
Datapixx('SetMarker');
Datapixx('RegWrPixelSync',pixelTrigger);

% Screen('Flip',w,start_exp_ptb-start_exp_vpixx+nextImTime);             % present the stimulus
Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',prevTrial.ExpImTime));

Datapixx('RegWrRd');
Trial.ImTime = Datapixx('GetMarker');

delta = Trial.ImTime-prevTrial.FixTime;
numberOfFrames = ceil(delta*session.params.timing.refreshRate);
Trial.FixDur = numberOfFrames/session.params.timing.refreshRate;

%% Fixation

Screen('DrawTexture',w, session.stimuli.fixation.fixTex);
Screen('DrawTexture',w, session.stimuli.triggers.fixationTex,[],[0 0 8 1]);
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-400 session.params.stimuli.pos.CTR+400],2);

pixelTrigger = double([session.stimuli.triggers.fixation(:,:,1);session.stimuli.triggers.fixation(:,:,2);session.stimuli.triggers.fixation(:,:,3)]);
Datapixx('SetMarker');
Datapixx('RegWrPixelSync',pixelTrigger);

% Screen('Flip',w,start_exp_ptb-start_exp_vpixx+Tim+ImDurForFlip);
Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',Trial.ImTime+session.params.timing.ImDurForFlip));

Datapixx('RegWrRd');
Trial.FixTime=Datapixx('GetMarker');
delta=Trial.FixTime-Trial.ImTime;

numberOfFrames = ceil(delta*session.params.timing.refreshRate);
Trial.ImDur = numberOfFrames/session.params.timing.refreshRate;

%% Get Response

tempFixDur=rand(1)*session.params.timing.addFix + session.params.timing.minFix;
fixFrames = round(tempFixDur/session.params.timing.ifi);
Trial.ExpImTime=Trial.FixTime + session.params.timing.ifi*(fixFrames-0.5);
% respTime = 0;Response = 0;

[Response, RTfromStart] = ResponsePixx('GetLoggedResponses',2,1,session.params.timing.ifi*(fixFrames-0.5)-0.05);

% while ~any(Response) && respTime < nextImTime 
%     [Response,respTime] = ResponsePixx('GetButtons');
% end

if ~any(Response) %no response
    Trial.Accuracy = -1;
    Trial.Response = -1; 
    Trial.RT = -1;
    Trial.RTfromStart = -1;
else
    Response=Response(1,:);
    Trial.RTfromStart = RTfromStart(1);
    Trial.RT = Trial.RTfromStart - Trial.ImTime - 0.005; % there is a deviation between markers and the display, stimuli are actually presented 5ms after marker time
    if phase==3  % face/house/noise responses
        if find(Response) == session.params.response.face %face stim
            Trial.Response=1;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        elseif find(Response) == session.params.response.house %house stim
            Trial.Response=2;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        elseif find(Response) == session.params.response.noise %noise stim
            Trial.Response=3;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        else % wrong button
            Trial.Response = 99;
            Trial.Accuracy = 0;
        end
    else
        if find(Response) == session.params.response.discSame % same orientation
            Trial.Response=1;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        elseif find(Response) == session.params.response.discDiff % changed orientation
            Trial.Response=2;
            Trial.Accuracy = +(Trial.CorrAns==Trial.Response);
        else % wrong button
            Trial.Response = 99;
            Trial.Accuracy = 0;
        end
    end
end  

  ResponsePixx('StopNow',1);
  ResponsePixx('Close');
end