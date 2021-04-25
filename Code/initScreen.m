function [w,wRect,bgColour] = initScreen()

global debug

% psychtoolbox screen initialization
screens         =  Screen('Screens');
screenNumber    =  max(screens);
bgColour            =  GrayIndex(screenNumber);
if debug
    [w, wRect]  =  PsychImaging('OpenWindow',screenNumber, bgColour, [0 0 1000 800]);
else
    [w, wRect]  =  PsychImaging('OpenWindow',screenNumber, bgColour);
    HideCursor;
end

Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % this enables us to use the alpha transparency

end

