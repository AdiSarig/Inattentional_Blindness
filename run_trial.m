function [FixTime,ImTime, RT, Resp, corr, Tim, Tfix,nextImTime]=run_trial(imName, disc1, disc2, disc3,...
    disc4,Tfix, nextImTime, CorrAns, Resp1im, Resp2im,...
    Resp3im,Resp1d,Resp2d)

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

global ImCont refreshRate ImDurForFlip ifi
global w center fixation vpix_trig phase
global addFix minFix start_exp_ptb start_exp_vpixx

%% definitions
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);             % this enables us to use the alpha transparency
ResponsePixx('StartNow',1);

%% Read stimuli

% image
image      =  imread(imName);
imTex      =  Screen('MakeTexture',w,image);

% discs
disc1Tex   =  Screen('MakeTexture',w,disc1);
disc2Tex   =  Screen('MakeTexture',w,disc2);
disc3Tex   =  Screen('MakeTexture',w,disc3);
disc4Tex   =  Screen('MakeTexture',w,disc4);

fixTex=Screen('MakeTexture',w,fixation);

vpix_trig_im_tex=Screen('MakeTexture',w,vpix_trig(:,1:8,:));
vpix_trig_fix_tex=Screen('MakeTexture',w,vpix_trig(:,9:16,:));

%% Draw STIMULI - Image + discs

Screen('DrawTexture',w, imTex,[],[],[],[], ImCont);

discSize=[0,0,size(disc1,1),size(disc1,2)];
disc1Loc=CenterRectOnPointd(discSize,center(1)-200,center(2)-200);
Screen('DrawTexture',w, disc1Tex,[],disc1Loc,[],[], ImCont);
disc2Loc=CenterRectOnPointd(discSize,center(1)+200,center(2)-200);
Screen('DrawTexture',w, disc2Tex,[],disc2Loc,[],[], ImCont);
disc3Loc=CenterRectOnPointd(discSize,center(1)-200,center(2)+200);
Screen('DrawTexture',w, disc3Tex,[],disc3Loc,[],[], ImCont);
disc4Loc=CenterRectOnPointd(discSize,center(1)+200,center(2)+200);
Screen('DrawTexture',w, disc4Tex,[],disc4Loc,[],[], ImCont);

Screen('DrawTexture',w,vpix_trig_im_tex,[],[0 0 8 1]);

%% Present stimuli

Datapixx('EnablePixelMode');
Datapixx('RegWr');

pixelTrigger = [255 0 255 0 255 0 255 0;0 255 0 255 0 255 0 255;0 0 0 0 0 0 0 0];
Datapixx('SetMarker');
Datapixx('RegWrPixelSync',pixelTrigger);

% Screen('Flip',w,start_exp_ptb-start_exp_vpixx+nextImTime);             % present the stimulus
Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',nextImTime));

Datapixx('RegWrRd');
Tim=Datapixx('GetMarker');

delta = Tim-Tfix;
numberOfFrames = ceil(delta*refreshRate);
FixTime = numberOfFrames/refreshRate;

%% Fixation

Screen('DrawTexture',w, fixTex);
Screen('DrawTexture',w, vpix_trig_fix_tex,[],[0 0 8 1]);

pixelTrigger = [0 0 0 0 0 0 0 0;0 255 0 255 0 255 0 255;255 0 255 0 255 0 255 0];
Datapixx('SetMarker');
Datapixx('RegWrPixelSync',pixelTrigger);

% Screen('Flip',w,start_exp_ptb-start_exp_vpixx+Tim+ImDurForFlip);
Screen('Flip',w,PsychDataPixx('FastBoxsecsToGetsecs',Tim+ImDurForFlip));

Datapixx('RegWrRd');
Tfix=Datapixx('GetMarker');
delta=Tfix-Tim;

numberOfFrames = ceil(delta*refreshRate);
ImTime = numberOfFrames/refreshRate;
Screen('close');

%% Get Response

fixDur=rand(1)*addFix + minFix;
fixFrames = round(fixDur/ifi);
nextImTime=Tfix + ifi*(fixFrames-0.5);
% respTime = 0;Response = 0;

[Response, respTime] = ResponsePixx('GetLoggedResponses',2,1,ifi*(fixFrames-0.5));

% while ~any(Response) && respTime < nextImTime 
%     [Response,respTime] = ResponsePixx('GetButtons');
% end

if ~any(Response) %no response
    corr = -1;
    Resp = -1; 
    RT = -1;
else
    Response=Response(1,:);
    RT = respTime(1) - Tfix - 0.005; % there is a deviation between markers and the display, stimuli are actually presented 5ms after marker time
    if phase==3  % face/house/noise responses
        if find(Response) == Resp1im %face stim
            Resp=1;
            corr = +(CorrAns==Resp);
        elseif find(Response) == Resp2im %house stim
            Resp=2;
            corr = +(CorrAns==Resp);
        elseif find(Response) == Resp3im %noise stim
            Resp=3;
            corr = +(CorrAns==Resp);
        else % wrong button
            Resp = 99;
            corr = 0;
        end
    else
        if find(Response) == Resp1d % same orientation
            Resp=1;
            corr = +(CorrAns==Resp);
        elseif find(Response) == Resp2d % changed orientation
            Resp=2;
            corr = +(CorrAns==Resp);
        else % wrong button
            Resp = 99;
            corr = 0;
        end
    end
end  

  ResponsePixx('StopNow',1);
end