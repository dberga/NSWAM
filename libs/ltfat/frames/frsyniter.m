function [f,relres,iter]=frsyniter(F,c,varargin)
%FRSYNITER  Iterative synthesis
%   Usage:  f=frsyniter(F,c);
%           f=frsyniter(F,c,Ls);
%           [f,relres,iter]=frsyniter(F,c,...);
%
%   Input parameters:
%         F       : Frame   
%         c       : Array of coefficients.
%         Ls      : length of signal.
%   Output parameters:
%         f       : Signal.
%         relres  : Vector of residuals.
%         iter    : Number of iterations done.
%
%   f=FRSYNITER(F,c) iteratively inverts the analysis operator of F, so
%   FRSYNITER always performs the inverse operation of FRANA, even
%   when a perfect reconstruction is not possible by using FRSYN.
%
%   [f,relres,iter]=FRSYNITER(...) additionally returns the relative
%   residuals in a vector relres and the number of iteration steps iter.
%  
%   *Note:* If it is possible to explicitly calculate the canonical dual
%   frame then this is usually a much faster method than invoking
%   FRSYNITER.
%
%   FRSYNITER takes the following parameters at the end of the line of
%   input arguments:
%
%     'tol',t      Stop if relative residual error is less than the
%                  specified tolerance. Default is 1e-9 (1e-5 for single precision)
%
%     'maxit',n    Do at most n iterations.
%
%     'cg'         Solve the problem using the Conjugate Gradient
%                  algorithm. This is the default.
%
%     'pcg'        Solve the problem using the Preconditioned Conjugate Gradient
%                  algorithm.
%
%     'print'      Display the progress.
%
%     'quiet'      Don't print anything, this is the default.
%
%   Examples
%   --------
%
%   The following example shows how to rectruct a signal without ever
%   using the dual frame:
%
%      F=frame('dgtreal','gauss',10,20);
%      c=frana(F,bat);
%      [r,relres]=frsyniter(F,c,'tol',1e-14);
%      norm(bat-r)/norm(bat)
%      semilogy(relres);
%      title('Conversion rate of the CG algorithm');
%      xlabel('No. of iterations');
%      ylabel('Relative residual');
%
%   See also: frame, frana, frsyn, franaiter
%
%   Url: http://ltfat.github.io/doc/frames/frsyniter.html

% Copyright (C) 2005-2015 Peter L. Soendergaard <peter@sonderport.dk>.
% This file is part of LTFAT version 2.1.0
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
  
% AUTHORS: Nicki Holighaus & Peter L. Søndergaard
    
complainif_notenoughargs(nargin,2,'FRSYNITER');
complainif_notvalidframeobj(F,'FRSYNITER');

  tolchooser.double=1e-9;
  tolchooser.single=1e-5;

  definput.keyvals.Ls=[];
  definput.keyvals.tol=tolchooser.(class(c));
  definput.keyvals.maxit=100;
  definput.flags.alg={'cg','pcg'};
  definput.keyvals.printstep=10;
  definput.flags.print={'quiet','print'};

  [flags,kv,Ls]=ltfatarghelper({'Ls'},definput,varargin);
  
  % Determine L from the first vector, it must match for all of them.
  L=framelengthcoef(F,size(c,1));

  F=frameaccel(F,L);
  
  A=@(x) F.frsyn(F.frana(x));

  % It is possible to specify the initial guess, but this is not
  % currently done
  
  if flags.do_pcg
      d=framediag(F,L);
      M=spdiags(d,0,L,L);
      
      [f,flag,~,iter,relres]=pcg(A,F.frsyn(c),kv.tol,kv.maxit,M);
  else
      
      [f,flag,~,iter,relres]=pcg(A,F.frsyn(c),kv.tol,kv.maxit);          
  end;
  
  if nargout>1
      relres=relres/norm(c(:));
  end;
  
      
  % Cut or extend f to the correct length, if desired.
  if ~isempty(Ls)
      f=postpad(f,Ls);
  else
      Ls=L;
  end;


if 0
    
    % This code has been disabled, as the PCG algorithm is so much faster.
      if flags.do_unlocbox

      % Get the upper frame bound (Or an estimation bigger than the bound)
      [~,B]=framebounds(F,L,'a'); 
      
      % Set the parameter for the fast projection on a B2 ball
      param.At=@(x) frsyn(F,x);     % adjoint operator
      param.A=@(x)  frana(F,x);     % direct operator
      param.y=c;                    % coefficient
      param.tight=0;                % It's not a tight frame
      param.max_iter=kv.maxit;
      param.tol=kv.tol; 
      param.nu=B;
      
      % Display parameter 0 nothing, 1 summary at convergence, 2 all
      % steps
      if flags.do_print
          param.verbose=1;
      else
          param.verbose=0;
      end;
      
      % Make the projection. Requires UNLocBOX
      [f, ~] = fast_proj_B2(zeros(L,1), 0, param);
      
      % compute the residue
      res = param.A(f) - param.y; norm_res = norm(res(:), 2);
      relres=norm_res/norm(c(:), 2);
      
      iter=0; % The code of the fast_proj_B2 is not yet compatible with this
  end;

end;

    

