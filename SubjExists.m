function yn = SubjExists(subjnum)% Check if the subject already exists in data folderif ~isfile(sprintf('..%cdata%cIB_Sub_%d.mat',filesep,filesep,subjnum))	yn = 0;else	r=input('File already exists for this subject.\nContinue anyway? (y/n)','s');	if ~(r=='y' | r=='Y')		yn = 1;	else		yn = 0;	endend