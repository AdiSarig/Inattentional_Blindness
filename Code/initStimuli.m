function stimuli = initStimuli(params)
% Initialize all experimental stimuli and create their textures

global w

% Fixation
stimuli.fixation.fix    = imread(sprintf('%s%c%s%cfix.tif',params.defaultpath,filesep, params.stimuli.stimFolder, filesep));
stimuli.fixation.fixTex = Screen('MakeTexture',w,stimuli.fixation.fix);

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

% Background noise
for ind = 1:params.procedure.numStim
    bgnoiseName = sprintf('%s%c%s%cbgnoise_%d_g80.pcx',params.defaultpath,...
        filesep, params.stimuli.stimFolder, filesep, ind);
    bgnoise = imread(bgnoiseName);
    stimuli.bgNoise(ind) = Screen('MakeTexture',w,bgnoise);
end

end

