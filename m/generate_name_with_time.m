function name = generate_name_with_time(prefix, suffix)
%GENERATE_NAME_WITH_TIME generate name with respect to current time.
%
%Syntax: 
% name = GENERATE_NAME_WITH_TIME(prefix, suffix)
%
% prefix: (string or null)
% suffix: (string or null)
%
%   name: prefix-year-month-day-hour-miniute-sec+mssuffix.
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
%History: Dec 18, 2012 2012 created

%--------------------------------------------------------------------------

if nargin == 0
    prefix = '';
    suffix = '';
elseif nargin == 1
    suffix = '';
end

t = clock();

if strcmp(prefix, '') == 1
    name = '';
else
    name = [prefix, '-'];
end

name = [name,                             ...
        num2str(t(1),            '%04d'), ...   %year
        num2str(t(2:3),         '-%02d'), ...   %-month-day
        num2str(t(4:5),         '-%02d'), ...   %-hour-minute
        num2str(fix(t(6)*1000), '-%05d')];      %-sec+ms

if strcmp(suffix, '') ~= 1
    name = [name, suffix];
end    
%--------------------------------------------------------------------------
end