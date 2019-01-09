%-------------------------------------------------------------------------------
function	[off,vout]=get_off(varargin)

% search for pairs <.off>/<value>

		off=zeros(1,3);
		io=0;
	for	mode={'xoff','yoff','zoff'};
		ix=strcmpi(varargin,mode);
	if	any(ix)
		io=io+1;
		yx=find(ix);
		ix(yx+1)=1;
		off(1,io)=varargin{yx(end)+1};
		varargin=varargin(xor(ix,1));
	end
	end
		vout=varargin;
end
%-------------------------------------------------------------------------------