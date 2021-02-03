function [session] = saveCodes(session)
% save all codes used for running the experiment in a unique folder for
% each subject

cl = clock;
prf = sprintf('sub-%d-%s-%d-%d-%d',session.subjnum, date,cl(4),cl(5),round(cl(6)));
status(1) = copyfile(sprintf('..%c%s%c*.m',filesep,session.params.expFolder,filesep),sprintf('%s%ccodes%c%s%c',session.params.defaultpath, filesep, filesep, prf,filesep));
status(2) = copyfile(sprintf('..%c%s%c*.mat',filesep,session.params.expFolder,filesep),sprintf('%s%ccodes%c%s%c',session.params.defaultpath, filesep, filesep, prf,filesep));

if ~all(status)
    session.error = 'Codes not saved';
end

end

