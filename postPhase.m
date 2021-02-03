function [Ans] = postPhase(session)

global debug
debug = 1;

%% First question
if session.subject.gender=='f'
    Q1 = 'חלק מהמשתתפים הוקצו באופן רנדומלי לתנאי בו הופיעו גירויים נוספים מלבד העיגולים והרעש. האם הבחנת במשהו נוסף במהלך ביצוע המשימה? אם כן, פרטי מה ראית. היי מדויקת עד כמה שניתן. אם לא, כתבי זאת.';
else
    Q1 = 'חלק מהמשתתפים הוקצו באופן רנדומלי לתנאי בו הופיעו גירויים נוספים מלבד העיגולים והרעש. האם הבחנת במשהו נוסף במהלך ביצוע המשימה? אם כן, פרט מה ראית. היה מדויק עד כמה שניתן. אם לא, כתוב זאת.';
end
tmp = inputdlg(Q1,'Notes',10);
Ans.n1 = tmp{1};

%% Second question
Q2 = 'אילו אכן הבחנתם בגירויים נוספים מלבד העיגולים והרעש, באיזה שלב בניסוי הבחנתם בהם?';
tmp = inputdlg(Q2,'Notes',10);
Ans.n2 = tmp{1};

%% Third question

% initiate keys
KbName('UnifyKeyNames');
One = KbName('1!');
Two = KbName('2@');
Three = KbName('3#');
Four = KbName('4$');
Five = KbName('5%');

w = initScreen();
for im = 1:2 % images to be asked about with the question already displayed on top
    % display image with confidance question
    imName = sprintf('%s%c%s%c%s_%d_conf.tif',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep,session.subject.gender, im);
    image = imread(imName);
    imageTex = Screen('MakeTexture',w,image);
    Screen('DrawTexture',w, imageTex);
    Screen('Flip',w);
    
    % wait for response
    KbWait([],2);
    [keyIsDown, ~, Resp]=KbCheck;
    while keyIsDown
        if Resp(One)
            Ans.n3(im).confidance = 1;
            break
        elseif Resp(Two)
            Ans.n3(im).confidance = 2;
            break
        elseif Resp(Three)
            Ans.n3(im).confidance = 3;
            break
        elseif Resp(Four)
            Ans.n3(im).confidance = 4;
            break
        elseif Resp(Five)
            Ans.n3(im).confidance = 5;
            break
        end
        KbWait([],2);
        [keyIsDown, ~, Resp]=KbCheck;
    end
    
    % display the same image with frequency question
    imName = sprintf('%s%c%s%c%s_%d_freq.tif',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep,session.subject.gender, im);
    image = imread(imName);
    imageTex = Screen('MakeTexture',w,image);
    Screen('DrawTexture',w, imageTex);
    Screen('Flip',w);
    
    % wait for response
    KbWait([],2);
    [~, ~, Resp]=KbCheck;
    while keyIsDown
        if Resp(One)
            Ans.n3(im).frequency = 1;
            break
        elseif Resp(Two)
            Ans.n3(im).frequency = 2;
            break
        elseif Resp(Three)
            Ans.n3(im).frequency = 3;
            break
        elseif Resp(Four)
            Ans.n3(im).frequency = 4;
            break
        elseif Resp(Five)
            Ans.n3(im).frequency = 5;
            break
        end
        KbWait([],2);
        [keyIsDown, ~, Resp]=KbCheck;
    end
end
sca

%% Fourth question
Q4 = 'אם ראיתם תמונות, האם הבחנתם במשהו מיוחד לגביהן?';
tmp = inputdlg(Q4,'Notes',10);
Ans.n4 = tmp{1};

%% Fifth question
if session.subject.gender=='f'
    Q5 = 'אם ראית תמונות, פרטי מה היה נושא התמונה. כתבי כמה שיותר.';
else
    Q5 = 'אם ראית תמונות, פרט מה היה נושא התמונה. כתוב כמה שיותר.';
end
tmp = inputdlg(Q5,'Notes',10);
Ans.n5 = tmp{1};

%% Sixth question
if session.subject.gender=='f'
    Q6 = 'אם יש לך הערות נוספות לגבי הניסוי, הרגישי חופשי לפרט אותן כאן:';
else
    Q6 = 'אם יש לך הערות נוספות לגבי הניסוי, הרגש חופשי לפרט אותן כאן:';
end
tmp = inputdlg(Q6,'Notes',10);
Ans.n6 = tmp{1};

 end

