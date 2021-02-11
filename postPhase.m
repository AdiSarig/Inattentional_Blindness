function [Ans] = postPhase(session)

global debug
debug = 0;

figure('Position',[0 0 session.params.screen.dim.pix]); % open empty bg figure

%% First question
Q1 = {'\fontsize{12} עבור חלק מהמשתתפים (לא כולם!), הצגנו גירויים נוספים מלבד העיגולים והדפוס הרועש ברקע. האם הבחנתם בגירוי נוסף במהלך ביצוע המשימה? אם לא, כתבו זאת. אם כן, פרטו מה ראיתם. אנא היו מדויקים עד כמה שניתן.'};
defaultans = {''}; 
opts.Interpreter = 'tex';
tmp = inputdlg(Q1,'Notes',[10 120],defaultans, opts);
Ans.n1 = tmp{1};

%% Second question
Q2 = {'\fontsize{12} אם אכן הבחנתם בגירויים נוספים מלבד העיגולים והרעש, באיזה שלב בניסוי הבחנתם בהם?'};
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

imNum = [randi(session.params.procedure.numStim,[1 2]) 1 1 1];
w = initScreen();
for ind = 1:length(imNum) % images to be asked about with the question already displayed on top
    if ind == 3, continue, end % don't display noise
    
    % display confidance question
    confPath = sprintf('%s%c%s%cconf.tif',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep);
    conf = imread(confPath);
    confTex = Screen('MakeTexture',w,conf);
    Screen('DrawTexture',w, confTex);
    
    % display image
    imName = sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep,ind,imNum(ind));
    image = imread(imName);
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
    imName = sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep,ind,imNum(ind));
    image = imread(imName);
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
Ans.n3(3) = []; % remove empty row
Ans.selectedImages.face = imNum(1);
Ans.selectedImages.house = imNum(2);
sca

figure('Position',[0 0 session.params.screen.dim.pix]); % open empty bg figure

%% Fourth question
Q4 = {'\fontsize{12} אם ראיתם תמונות, האם הבחנתם במשהו מיוחד לגביהן?'};
defaultans = {''}; 
opts.Interpreter = 'tex'; 
tmp = inputdlg(Q4,'Notes',10,defaultans, opts);
Ans.n4 = tmp{1};

%% Fifth question
Q5 = {'\fontsize{12} אם ראיתם תמונות, אנא פרטו מה היה נושא התמונה. כתבו כמה שיותר.'};
defaultans = {''}; 
opts.Interpreter = 'tex'; 
tmp = inputdlg(Q5,'Notes',10,defaultans, opts);
Ans.n5 = tmp{1};

%% Sixth question
Q6 = {'\fontsize{12} אם יש לכם הערות נוספות לגבי הניסוי, הרגישו חופשי לפרט אותן כאן:'};
defaultans = {''}; 
opts.Interpreter = 'tex'; 
tmp = inputdlg(Q6,'Notes',10,defaultans, opts);
Ans.n6 = tmp{1};

close('all') % close bg figure

 end

