function stimuli = initStimuli(params)

stimuli.fixation = imread(sprintf('%s%c%s%cfixation.tif',params.defaultpath,filesep, params.stimFolder, filesep));

vpix_trig=uint8([255 0 255 0 255 0 255 0 0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0]);
vpix_trig(:,:,2)=uint8([0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 255 0 0 0 0 0 0 0 0]);
vpix_trig(:,:,3)=uint8([0 0 0 0 0 0 0 0 255 0 255 0 255 0 255 0 0 255 0 255 0 255 0 255]);

stimuli.triggers.image = vpix_trig(:,1:8,:);
stimuli.triggers.fixation = vpix_trig(:,9:16,:);
stimuli.triggers.info = vpix_trig(:,17:24,:);

end

