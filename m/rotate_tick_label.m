function h = rotate_tick_label(h, tick, rotation)
%ROTATE_TICK_LABEL rotate the tick label according to the parameters
%
%Syntax: 
% h = ROTATE_TICK_LABEL(h, tick, rotation)
%
%        h: axes handle
%     tick: 'xtick' or 'ytick'
% rotation: angle of rotation
%
%        h: axes handle
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

if isempty(h) || ~ishandle(h)
    error('Wrong handle.');
end

tick = validatestring(lower(tick), {'xtick', 'ytick'}, ...
                      mfilename('fullpath'), 'tick');

if nargin == 2
    rotation = 90;
end

while rotation > 360
    rotation = rotation - 360;
end

while rotation < 0
    rotation = rotation + 360;
end

if strcmp(tick, 'xtick')
    a = get(h, 'xticklabel');
    set(h, 'xticklabel', []);
    b = get(h, 'xtick');
    c = get(h, 'ytick');
elseif strcmp(tick, 'ytick')
    a = get(h, 'yticklabel');
    set(h, 'ytickalbe', []);
    b = get(h, 'ytick');
    c = get(h, 'xtick');
else
    error('Only for xtick or ytick');
end

%make new tick labels
if rotation < 180
    h = text(b, repmat(c(1), [1, length(b)]), a, ...
             'horizontalalignment', 'right', 'rotation', rotation, ...
             'fontsize', 12);
else
    h = text(b, repmat(c(1), [1, length(b)]), a, ...
             'horizontalalignment', 'left', 'rotation', rotation, ...
             'fontsize', 12);
end
%--------------------------------------------------------------------------
end