function [disc1,disc2,disc3,disc4] = rotateDiscs(orientation,change,location)
% This function assignes each disc it's right orientation based on the
% trial specifications.

global defaultpath ImFol

disc=imread(sprintf('%s%c%s%cdisc_modified.tif',defaultpath,filesep, ImFol, filesep));
if orientation==2 % change to horizontal
    disc=imrotate(disc,90);
end
disc1=disc;disc2=disc;disc3=disc;disc4=disc;

if change==2 % rotate one of the discs at the location set
    switch location
        case 1
            disc1=imrotate(disc1,90);
        case 2
            disc2=imrotate(disc2,90);
        case 3
            disc3=imrotate(disc3,90);
        case 4
            disc4=imrotate(disc4,90);
    end
end

end

