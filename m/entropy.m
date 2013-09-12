function H = entropy(X, DIM)
%ENTROPY returns entropy of X along the dimension DIM.
%
%Syntax: 
% H = ENTROPY(X)
% H = ENTROPY(X, DIM)
%
%     X: (matrix)data to be analyzed.
%   DIM: (integer)dimension
%
%     H: (in bits)the entropy of X.
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
%History: Sept 12 16:00 2013 created

%--------------------------------------------------------------------------

if nargin == 1
    DIM = 1;
end

if DIM == 2
    X = X';
end

[n, m] = size(X);

H = zeros(1, m);

for j = 1 : m
    Xj  = X(:, j);
    X1  = diff([Xj; max(Xj) + 1]);
    cnt = diff(find([1; X1]));
    frq = cnt / n;
    
    H(j) = - frq' * log2(frq);
end

if DIM == 2
    H = H';
end
%--------------------------------------------------------------------------
end
