function resp=getInput(varargin)resp=[];while isempty(resp)	if nargin==1		resp=input(varargin{1});    elseif varargin{2}		resp=input(varargin{1},varargin{2});    else        resp=input(varargin{1});	end	if nargin>2		if isempty(find(varargin{3}==resp))			disp('Invalid entry.');			resp=[];		end	endend