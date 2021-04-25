function [Ans] = postPhase(session)

global debug
debug = 0;

ListenChar(1) % so participants will be able to type
figure('Position',[0 0 session.params.screen.dim.pix]); % open empty bg figure

%% First question
Q1 = {'\fontsize{12} ???? ??? ????????? (?? ????!), ????? ??????? ?????? ???? ???????? ?????? ????? ????. ????????????????? ???? ????? ????? ?????????? ??, ????????.??????,??????????????. ??? ??? ?????????? ??? ?????.'};
defaultans = {''}; 
opts.Interpreter = 'tex';
tmp = inputdlg(Q1,'Notes',[10 120],defaultans, opts);
Ans.n1 = tmp{1};

%% Second question
Q2 = {'\fontsize{12} ?? ??? ?????? ???????? ?????? ???? ???????? ?????, ????? ??? ?????? ?????? ????'};
defaultans = {''}; 
opts.Interpreter = 'tex'; 
tmp = inputdlg(Q2,'Notes',10,defaultans, opts);
Ans.n2 = tmp{1};

close('all')
%% Third question

% initiate keys
KbName('UnifyKeyNames');
One = KbName('1!');
Two = KbName('2@');
Three = KbName('3#');
Four = KbName('4$');
Five = KbName('5%');

% define stimuli to present
imNum = randi(session.params.procedure.numStim,[1 2]);
imName = {sprintf('%s%c%s%capple_modified.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep)};      % apple
imName(2) = {sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep,1,imNum(1))}; % face
imName(3) = {sprintf('%s%c%s%cfish_modified.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep)};    % fish
imName(4) = {sprintf('%s%c%s%celephant_modified.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep)};% elephant
imName(5) = {sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep,2,imNum(2))}; % house
imName(6) = {sprintf('%s%c%s%cTV_modified.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep)};      % TV

% save their names
images_cell = {'Apple' ['Face_' num2str(imNum(1))] 'Fish' 'Elephant' ['House_' num2str(imNum(2))] 'TV'};
[Ans.n3(1:length(images_cell)).images] = images_cell{:};

ListenChar(2) % don't allow typing
w = initScreen();
for ind = 1:length(images_cell) % images to be asked about with the question already displayed on top
    
    % display confidance question
    confPath = sprintf('%s%c%s%cconf.tif',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep);
    conf = imread(confPath);
    confTex = Screen('MakeTexture',w,conf);
    Screen('DrawTexture',w, confTex);
    
    % display image
    image = imread(imName{ind});
    imageTex = Screen('MakeTexture',w,image);
    Screen('DrawTexture',w, imageTex);
    
    Screen('Flip',w);
    
    % wait for response
    KbWait([],2);
    [keyIsDown, ~, Resp]=KbCheck;
    while keyIsDown
        if Resp(One)
            Ans.n3(ind).confidance = 1;
            break
        elseif Resp(Two)
            Ans.n3(ind).confidance = 2;
            break
        elseif Resp(Three)
            Ans.n3(ind).confidance = 3;
            break
        elseif Resp(Four)
            Ans.n3(ind).confidance = 4;
            break
        elseif Resp(Five)
            Ans.n3(ind).confidance = 5;
            break
        end
        KbWait([],2);
        [keyIsDown, ~, Resp]=KbCheck;
    end
    
    % display the same image with frequency question
    freqPath = sprintf('%s%c%s%cfreq.tif',session.params.defaultpath,filesep, session.params.stimuli.stimFolder,filesep);
    freq = imread(freqPath);
    freqTex = Screen('MakeTexture',w,freq);
    Screen('DrawTexture',w, freqTex);
    
    % display image
    image = imread(imName{ind});
    imageTex = Screen('MakeTexture',w,image);
    Screen('DrawTexture',w, imageTex);
    
    Screen('Flip',w);
    
    % wait for response
    KbWait([],2);
    [~, ~, Resp]=KbCheck;
    while keyIsDown
        if Resp(One)
            Ans.n3(ind).frequency = 1;
            break
        elseif Resp(Two)
            Ans.n3(ind).frequency = 2;
            break
        elseif Resp(Three)
            Ans.n3(ind).frequency = 3;
            break
        elseif Resp(Four)
            Ans.n3(ind).frequency = 4;
            break
        elseif Resp(Five)
            Ans.n3(ind).frequency = 5;
            break
        end
        KbWait([],2);
        [keyIsDown, ~, Resp]=KbCheck;
    end
end
sca

ListenChar(1) % so participants will be able to type
figure('Position',[0 0 session.params.screen.dim.pix]); % open empty bg figure

%% Fourth question
Q4 = {'\fontsize{12} ?? ????? ??????, ??? ?????? ????? ????? ???????'};
defaultans = {''}; 
opts.Interpreter = 'tex'; 
tmp = inputdlg(Q4,'Notes',10,defaultans, opts);
Ans.n4 = tmp{1};

%% Fifth question
Q5 = {'\fontsize{12} ?? ????? ??????, ??? ???? ?? ??? ???? ??????. ???? ??? ?????.'};
defaultans = {''}; 
opts.Interpreter = 'tex'; 
tmp = inputdlg(Q5,'Notes',10,defaultans, opts);
Ans.n5 = tmp{1};

%% Sixth question
Q6 = {'\fontsize{12} ?? ?? ??? ????? ?????? ???? ??????, ?????? ????? ???? ???? ???:'};
defaultans = {''}; 
opts.Interpreter = 'tex'; 
tmp = inputdlg(Q6,'Notes',10,defaultans, opts);
Ans.n6 = tmp{1};

close('all') % close bg figure
ListenChar(2) % don't allow typing

 end

