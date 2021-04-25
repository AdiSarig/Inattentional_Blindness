function [disc1,disc2,disc3,disc4] = rotateDiscs(orientation,change,location,discs)
% This function assignes each disc it's right orientation texture based on the
% trial specifications.

if orientation==1 % default orientation is vertical
    disc = discs.VerticalTex;
    disc1=disc;disc2=disc;disc3=disc;disc4=disc;
    if change==2  
        switch location
            case 1
                disc1=discs.HorizontalTex;
            case 2
                disc2=discs.HorizontalTex;
            case 3
                disc3=discs.HorizontalTex;
            case 4
                disc4=discs.HorizontalTex;
        end
    end
else             % default orientation is horizontal
    disc = discs.HorizontalTex;
    disc1=disc;disc2=disc;disc3=disc;disc4=disc;
    if change==2 % rotate one of the discs at the specified location
        switch location
            case 1
                disc1=discs.VerticalTex;
            case 2
                disc2=discs.VerticalTex;
            case 3
                disc3=discs.VerticalTex;
            case 4
                disc4=discs.VerticalTex;
        end
    end
end

end

