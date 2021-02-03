function stimuli = initStimuli(params)
% Initiate all experimental stimuli and create their texture

global w

% Fixation
stimuli.fixation.fix    = imread(sprintf('%s%c%s%cfixation.tif',params.defaultpath,filesep, params.stimuli.stimFolder, filesep));
stimuli.fixation.fixTex = Screen('MakeTexture',w,stimuli.fixation.fix);

% Pixel triggers - for Vpixx to identify and mark the timing of the stimuli being presented.
% Should be at least 8 pixels. Here it is 24 pixels lated divided into 3 different triggers.
vpix_trig=uint8([255 0 255 0 255 0 255 0 0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0]);
vpix_trig(:,:,2)=uint8([0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 0 0 0 0 0 0 0]);
vpix_trig(:,:,3)=uint8([0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0 0 255 0 255 0 255 0 255]);

stimuli.triggers.image = vpix_trig(:,1:8,:);       % image trigger
stimuli.triggers.imageTex = Screen('MakeTexture',w,stimuli.triggers.image);
stimuli.triggers.fixation = vpix_trig(:,9:16,:);   % fixation trigger
stimuli.triggers.fixationTex = Screen('MakeTexture',w,stimuli.triggers.fixation);
stimuli.triggers.info = vpix_trig(:,17:24,:);      % instructions trigger

% Discs
stimuli.Disc.Vertical      =  imread(sprintf('%s%c%s%cdisc_modified.tif',params.defaultpath,filesep, params.stimuli.stimFolder, filesep));
stimuli.Disc.VerticalTex   =  Screen('MakeTexture',w,stimuli.Disc.Vertical);
stimuli.Disc.Horizontal    =  imrotate(stimuli.Disc.Vertical,90);
stimuli.Disc.HorizontalTex =  Screen('MakeTexture',w,stimuli.Disc.Horizontal);
stimuli.Disc.discSize      =  [0,0,size(stimuli.Disc.Vertical,1),size(stimuli.Disc.Vertical,2)];

% Images
for idx = 1:3 % face/house/noise
    for ind = 1:params.procedure.numStim
        imName = sprintf('%s%c%s%c%d_%d.pcx',params.defaultpath,...
            filesep, params.stimuli.stimFolder, filesep, idx,ind);
        image = imread(imName);
        imTex =  Screen('MakeTexture',w,image);
        if idx == 1
            stimuli.image(ind).face = imTex;
        elseif idx == 2
            stimuli.image(ind).house = imTex;
        else
            stimuli.image(ind).noise = imTex;
        end
    end
end

end

