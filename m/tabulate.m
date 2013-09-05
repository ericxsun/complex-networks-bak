function T = tabulate(X)
%TABULATE calculate the frequency of each value in X
%
%Syntax: 
% T = TABULATE(X)
%
% X: (single, double, arrary, string)a categorical variable
%
% T: frequency table, 1-unique value in X, 2-count, 3-frequence
%
%Example:
%
%Ref:
% Rewrite the same function supported by MATLAB. But only consider the 
% avaiable values in X. That means:
% example: x = [1, 1, 3]
% For tabulate supported by MATLAB, tabulate(x) will be:
% 1 2 66.67%
% 2 0  0.00%
% 3 1 33.33%
% But in this function, the frequence/count for value 2 won't be recorded.
%
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

if isnumeric(X) 
    if min(size(X)) > 1
        error('Vector required.');
    end
    
    X   = X(:); 
    X   = X(~isnan(X)); 
    Xid = []; 
else
    [X, Xid] = grp2idx(X); 
end 

X = sort(X(:));    
m = length(X); 

X1  = diff([X; max(X) + 1]);

X_u = X(X1 ~= 0);
cnt = diff(find([1; X1]));

if isempty(Xid)
    T = [X_u, cnt, cnt/m];
else
    T = [Xid, num2cell([cnt, cnt/m])];
end
%--------------------------------------------------------------------------
end