%% create disc stimulus:

disc=imread(sprintf('..%cstimuli%cdisc.tif',filesep, filesep));
disc_noise=imread(sprintf('..%cstimuli%cdisc_noise.pcx',filesep, filesep));
disc_noise = disc_noise+1;
disc = imresize(disc,[118 118]);
disc(:,59,2)=0;
disc(:,60,1)=0;
disc(disc>0)=255;
mask=disc(:,:,4)==0;
rdisc=disc(:,:,1);rdisc(mask)=disc_noise(mask);disc(:,:,1)=rdisc;
gdisc=disc(:,:,2);gdisc(mask)=disc_noise(mask);disc(:,:,2)=gdisc;
bdisc=disc(:,:,3);bdisc(mask)=disc_noise(mask);disc(:,:,3)=bdisc;
imshow(disc(:,:,1:3))
imwrite(disc(:,:,1:3),sprintf('..%cstimuli%cdisc_modified.tif',filesep, filesep));


%% create fixation:
% figure()
% fixation=uint8(ones(30,30)*128);
% fixation(10:20,15)=255;
% fixation(15,10:20)=255;
% imshow(fixation);
% imwrite(fixation,sprintf('..%cstimuli%cfixation.tif',filesep, filesep));

%cross fixation
fixSize = 30;
fixation=uint8(ones(fixSize)*128);
fixation(:,round(fixSize/2))=255;
fixation(round(fixSize/2),:)=255;
imshow(fixation);
imwrite(fixation,sprintf('..%cstimuli%cfix.tif',filesep, filesep));

% dot fixation
fix = imresize(disc,[8 8]);
fix = fix(:,:,4);
fix(fix>0) = 255;
fix(fix==0) = 128;
imshow(fix);
imwrite(fix,sprintf('..%cstimuli%cfix.tif',filesep, filesep));


%% Practice Trial List

im_level=ones(5,1)*3;
im_num=randperm(5)';
orientation=[1;1;2;1;2];
flipDisc=[1;2;1;2;2];
locFlip=[0;2;0;3;1];
PracList=[im_level,im_num,orientation,flipDisc,locFlip];
save('PracList.mat','PracList');

%% Edit post phase images
% load image
[compare,m]=imread(sprintf('..%cstimuli%c2_5.pcx',filesep, filesep)); % for color map

% use either one:
% im=imread(sprintf('..%cstimuli%cfish.pcx',filesep, filesep));
% im=imread(sprintf('..%cstimuli%capple.pcx',filesep, filesep));
% im=imread(sprintf('..%cstimuli%cstar.pcx',filesep, filesep));
% im=imread(sprintf('..%cstimuli%cTV.pcx',filesep, filesep));
% im=imread(sprintf('..%cstimuli%ccar.pcx',filesep, filesep));
im=imread(sprintf('..%cstimuli%celephant.pcx',filesep, filesep));

im = imresize(im,[175 175]); % match the other stimuli
im = im(:,:,1);
% im = 255-im; % convert black and white
im(im<200.5) = 0;
im(im>200.5) = 255;

pFlip = 0.25; % precentage of pixels to flip
gray = 80;    % change to gray (either remove or add 80 to the pixel value)

dotflip = rand(size(im))<pFlip; % which pixels to flip
nim = im;
nim(dotflip) = 255-nim(dotflip); % flip pixels

% change to gray
nim(nim==255) = 255-gray;
nim(nim==0) = 0+gray;

% display image
imshow(compare)
figure()
imshow(nim)

% save image (use either one)
% imwrite(nim,m,sprintf('..%cstimuli%capple_modified.pcx',filesep, filesep));
% imwrite(nim,m,sprintf('..%cstimuli%cfish_modified.pcx',filesep, filesep));
% imwrite(nim,m,sprintf('..%cstimuli%cstar_modified.pcx',filesep, filesep));
% imwrite(nim,m,sprintf('..%cstimuli%cTV_modified.pcx',filesep, filesep));
% imwrite(nim,m,sprintf('..%cstimuli%ccar_modified.pcx',filesep, filesep));
% imwrite(nim,m,sprintf('..%cstimuli%celephant_modified.pcx',filesep, filesep));
imwrite(nim,sprintf('..%cstimuli%celephant_modified.tif',filesep, filesep));