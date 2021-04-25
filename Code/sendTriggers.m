function sendTriggers(BIOSEMI, BIO_LPT_ADDRESS, trigCode)
% Send biosemi triggers

io64(BIOSEMI,BIO_LPT_ADDRESS,trigCode);
WaitSecs(0.001);
io64(BIOSEMI,BIO_LPT_ADDRESS,0);
WaitSecs(0.001);

end

