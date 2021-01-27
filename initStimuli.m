function stimuli = initStimuli(params)

global w

% Fixation
stimuli.fixation.fix    = imread(sprintf('%s%c%s%cfixation.tif',params.defaultpath,filesep, params.stimuli.stimFolder, filesep));
stimuli.fixation.fixTex = Screen('MakeTexture',w,stimuli.fixation.fix);

% Pixel triggers
vpix_trig=uint8([255 0 255 0 255 0 255 0 0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0]);
vpix_trig(:,:,2)=uint8([0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 0 0 0 0 0 0 0]);
vpix_trig(:,:,3)=uint8([0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0 0 255 0 255 0 255 0 255]);

stimuli.triggers.image = vpix_trig(:,1:8,:);
stimuli.triggers.imageTex = Screen('MakeTexture',w,stimuli.triggers.image);
stimuli.triggers.fixation = vpix_trig(:,9:16,:);
stimuli.triggers.fixationTex = Screen('MakeTexture',w,stimuli.triggers.fixation);
stimuli.triggers.info = vpix_trig(:,17:24,:);

% Discs
stimuli.Disc.Vertical      =  imread(sprintf('%s%c%s%cdisc_modified.tif',params.defaultpath,filesep, params.stimuli.stimFolder, filesep));
stimuli.Disc.VerticalTex   =  Screen('MakeTexture',w,stimuli.Disc.Vertical);
stimuli.Disc.Horizontal    =  imrotate(stimuli.Disc.Vertical,90);
stimuli.Disc.HorizontalTex =  Screen('MakeTexture',w,stimuli.Disc.Horizontal);
stimuli.Disc.discSize      =  [0,0,size(stimuli.Disc.Vertical,1),size(stimuli.Disc.Vertical,2)];


end

