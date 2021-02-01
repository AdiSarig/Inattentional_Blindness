function [Ans] = postPhase(session)

global debug
debug = 1;

%% First question
Q1 = 'some participants were randomly assigned to a condition in which items other than the circles and random symbols appeared on the screen. Did you notice anything other than the circles and random symbols while you were completing the task? If so, please describe below. Be as detailed as possible. If not, please indicate that.';
tmp = inputdlg(Q1,'Notes',10);
Ans.n1 = tmp{1};

%% Second question
Q2 = 'If you did notice items other than the circles and symbols, at what point in the phase did you notice them?';
tmp = inputdlg(Q2,'Notes',10);
Ans.n2 = tmp{1};

%% Third question
KbName('UnifyKeyNames');
One = KbName('1!');
Two = KbName('2@');
Three = KbName('3#');
Four = KbName('4$');
Five = KbName('5%');

conf = 1; freq = 2;
w = initScreen();
for im = 1:3
    imName = sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep, im,conf);
    image = imread(imName);
    imageTex = Screen('MakeTexture',w,image);
    Screen('DrawTexture',w, imageTex,[],[],[],[], session.params.stimuli.stimContrast);
    Screen('Flip',w);
    
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
    
    imName = sprintf('%s%c%s%c%d_%d.pcx',session.params.defaultpath,filesep, session.params.stimuli.stimFolder, filesep, im,freq);
    image = imread(imName);
    imageTex = Screen('MakeTexture',w,image);
    Screen('DrawTexture',w, imageTex,[],[],[],[], session.params.stimuli.stimContrast);
    Screen('Flip',w);
    
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
Q4 = 'If you saw words, did you notice anything special about them?';
tmp = inputdlg(Q4,'Notes',10);
Ans.n4 = tmp{1};

%% Fifth question
Q5 = 'If you saw words, please jot down as many as you can remember.';
tmp = inputdlg(Q5,'Notes',10);
Ans.n5 = tmp{1};

%% Sixth question
Q6 = 'If you have any other comments about the phase or experiment, feel free to write them below.';
tmp = inputdlg(Q6,'Notes',10);
Ans.n6 = tmp{1};

 end

