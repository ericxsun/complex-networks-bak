function H = heterogeneity(degSeq)
%HETEROGENEITY is used to calculate the normalized heterogeneity 
%coefficient
%
%Note:
%The same as std(degSeq), but normalized
%
%Syntax: 
% H = HETEROGENEITY(degSeq)
%
% degSeq: the degree sequence(n x 1)
%
%      H: the normalized heterogeneity coefficient 
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------
len    = length(degSeq);
ExpDeg = mean(degSeq);

S = zeros(1, len);

for i = 1 : len,
    S(i) = sum(abs(degSeq(i) - degSeq(:)));
end

H = sum(S)/(2*len^2*ExpDeg);
%--------------------------------------------------------------------------
end
