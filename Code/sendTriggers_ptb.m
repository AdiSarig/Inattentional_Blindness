function sendTriggers_ptb(triggers,Trial,partInTrial)
% Should be written according to biosemi, use code from Tamara

global phase

% 
% %----Image triggers-----
% if strcmp(partInTrial,'image')
%     % trial number 1:72
%     Datapixx('SetDoutValues', triggers(1).trialNum(Trial.TrialNum).numBin);
%     Datapixx('RegWrRd');
%     WaitSecs(0.001);
%     
%     % Image type
%     switch Trial.ImageType
%         case 1
%             Datapixx('SetDoutValues', triggers(1).Image_face);
%         case 2
%             Datapixx('SetDoutValues', triggers(1).Image_house);
%         case 3
%             Datapixx('SetDoutValues', triggers(1).Image_noise);
%     end
%     Datapixx('RegWrRd');
%     WaitSecs(0.001);
%     
%     % image number 1:12    111:122
%     Datapixx('SetDoutValues', triggers(1).imageNum(Trial.ImageNum).numBin);
%     Datapixx('RegWrRd');
%     WaitSecs(0.001);
%     
%     % discs orientation
%     switch Trial.DiscOrientation
%         case 1
%             Datapixx('SetDoutValues', triggers(1).Disc_vertical);
%         case 2
%             Datapixx('SetDoutValues', triggers(1).Disc_horizontal);
%     end
%     Datapixx('RegWrRd');
%     WaitSecs(0.001);
%     
%     % discs rotation (change orientation of one disc)
%     switch Trial.DiscRotation
%         case 1
%             Datapixx('SetDoutValues', triggers(1).Disc_same);
%         case 2
%             Datapixx('SetDoutValues', triggers(1).Disc_diff);
%     end
%     Datapixx('RegWrRd');
%     WaitSecs(0.001);
%     
%     % disc location 0:4 (total range: 140:144)
%     Datapixx('SetDoutValues', triggers(1).discLocNum(Trial.DiscLocation+1).numBin);
%     Datapixx('RegWrRd');
%     
%     
% %----Fixation triggers-----
% elseif strcmp(partInTrial,'fix')
%     switch Trial.ImageType
%         case 1
%             Datapixx('SetDoutValues', triggers(1).Fix_face);
%         case 2
%             Datapixx('SetDoutValues', triggers(1).Fix_house);
%         case 3
%             Datapixx('SetDoutValues', triggers(1).Fix_noise);
%     end
% % register write will be when flipping occures
%     
% 
% %----Response triggers-----
% elseif strcmp(partInTrial,'resp')
%     % Response content
%     if phase == 3
%         switch Trial.Response
%             case 1
%                 Datapixx('SetDoutValues', triggers(1).Resp_Image_face);
%             case 2
%                 Datapixx('SetDoutValues', triggers(1).Resp_Image_house);
%             case 3
%                 Datapixx('SetDoutValues', triggers(1).Resp_Image_noise);
%         end
%     else
%         switch Trial.Response
%             case 1
%                 Datapixx('SetDoutValues', triggers(1).Resp_Disc_same);
%             case 2
%                 Datapixx('SetDoutValues', triggers(1).Resp_Disc_diff);
%         end
%     end
%     Datapixx('RegWrRd');
%     WaitSecs(0.001);
%     
%     % response accuracy
%     if Trial.Response == 99
%         Datapixx('SetDoutValues', triggers(1).RESP_ERROR);
%         Datapixx('RegWrRd');
%         WaitSecs(0.001);
%         Datapixx('SetDoutValues', triggers(1).Resp_inCorr);
%     else
%         switch Trial.Accuracy
%             case 0
%                 Datapixx('SetDoutValues', triggers(1).Resp_inCorr);
%             case 1
%                 Datapixx('SetDoutValues', triggers(1).Resp_Corr);
%             case -1
%                 Datapixx('SetDoutValues', triggers(1).RESP_missing);
%         end
%     end
%     Datapixx('RegWrRd');
%     WaitSecs(0.001);
% end
% 


end

