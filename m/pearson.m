function rho = pearson(X, Y)
%PEARSON calculate the pearson correlation coefficient between two random
%variables.
%
%Syntax: 
% rho = PEARSON(X, Y)
%
% X, Y: (vector, nx1) random variable.
%
%  rho: the pearson correlation coefficient.
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

if nargin == 1
    Y = X;
end

if length(X) ~= length(Y)
    error('The dimision of X and Y is not equal.');
end

N = length(X);

numerator = sum(X.*Y) - sum(X)*sum(Y)/N;
denomiator= sqrt((sum(X.^2) - sum(X)^2/N)*(sum(Y.^2) - sum(Y)^2/N));

rho = numerator / denomiator;
%--------------------------------------------------------------------------
end