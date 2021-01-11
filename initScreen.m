function [w,wRect,bgColour] = initScreen()

global debug

% psychtoolbox screen initialization
screens         =  Screen('Screens');
screenNumber    =  max(screens);
bgColour            =  GrayIndex(screenNumber);
if debug
    [w, wRect]  =  Screen('OpenWindow',screenNumber, bgColour, [100 100 600 600]);
else
    [w, wRect]  =  Screen('OpenWindow',screenNumber, bgColour);
    HideCursor;
end
% ScreenWidth     =  wRect(3);
% ScreenHeight    =  wRect(4);
% center          =  [ScreenWidth/2; ScreenHeight/2];
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % this enables us to use the alpha transparency

end

