function trial = stopForMaintenance(session, trial)

global w GL

% Draw maintenance instructions
maintenanceIm = imread(session.params.procedure.instructions.maintenance);
maintenanceTex =  Screen('MakeTexture',w,maintenanceIm);
Screen('DrawTexture',w, maintenanceTex);

% Use im trigger to identify maintenance break
pixelTrigger = double(session.stimuli.triggers.image);
glRasterPos2d(session.params.stimuli.pos.CTR(1), session.params.stimuli.pos.CTR(2)-200);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));

% Wait fixation duration
while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > trial.ExpImTime
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', session.triggers(1).maintenance_break);
Datapixx('RegWrPixelSync',pixelTrigger);     % register write exactly when the pixels appear on screen

Screen('Flip',w);        % present fixation
WaitSecs(0.004);

KbWait([],2); % wait for any response after keys release


%% Continue exp
% Draw frame
Screen('FrameRect', w, [0 0 0 255*session.params.stimuli.stimContrast], [session.params.stimuli.pos.CTR-351 session.params.stimuli.pos.CTR+351],2);
% Draw fixation
Screen('DrawTexture',w, session.stimuli.fixation.fixTex);

% Draw pixel trigger
pixelTrigger = double(session.stimuli.triggers.fixation);
glRasterPos2d(session.params.stimuli.pos.CTR(1), session.params.stimuli.pos.CTR(2)-200);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));

Datapixx('SetDoutValues', session.triggers(1).maintenance_break_over); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

trial.FixTime_ptb = Screen('Flip',w);                        % present stimuli

Datapixx('RegWrRd');                                        % must read the register before getting the marker
trial.FixTime = Datapixx('GetMarker');                       % retrieve the saved timing from the register

WaitSecs(0.004);                                            % for triggers to be sent seperatly

tempFixDur = rand(1)*session.params.timing.addFix + session.params.timing.minFix;
fixFrames = round(tempFixDur/session.params.timing.ifi);
trial.ExpImTime = trial.FixTime + session.params.timing.ifi*(fixFrames-0.5);


end