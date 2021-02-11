function session = initSession(paradigm)session = [];subjnum=getInput('Enter the subject number: ');if SubjExists(subjnum)   % Check if the subject already exists in data folder	error('Script aborted.');endRespCounterBalance=getInput('Change response keys? (y/n) ','s',['y','n']);subjage=getInput('Enter the subject''s age: ');subjgend=getInput('Enter the subject''s gender: (f/m/n) ','s',['m','f','n']);subjhand=getInput('Enter the subject''s handedness: (r/l) ','s',['r','l']);% create session objectsession = struct('paradigm',paradigm,'datetime',datestr(now),...					'version',version,'subjnum',subjnum,'RespCounterBalance',RespCounterBalance,'params',[],...					'subject',struct('age',subjage,'gender',subjgend,'hand',subjhand),...					'notes','');                tmp = inputdlg('Notes','Notes',7);session.notes = tmp{1};session.params = initParams(session);session.triggers = initBIO(session);end