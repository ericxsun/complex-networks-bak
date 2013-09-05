function progress_bar_gui(varargin)
%PROGRESS_BAR_GUI provide an indication of the long running operations
%using graphics and text.
%
%Syntax: 
% see progress_bar_gui_example.m
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: progress_bar_gui_example, progress_bar_console, waitbar

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------
persistent progfig progdata lastupdate;

if nargin > 0
    input = varargin;
    ninput= nargin;
else
    input = {0};
    ninput= 1;
end

if input{1} == 1
    if ishandle(progfig)
        delete(progfig);    %close progress bar
    end
    
    clear progfig progdata lastupdate;
    drawnow;
    
    return;
end

reset = false;

if ischar(input{1})
    reset = true;
end

if input{1} == 0
    if all([input{:}] == 0) && length([input{:}]) == ninput
        reset = true;
    end
end

if ninput > length(progdata)
    reset = true;
end

%if reset, close figure and forget old data
if reset
    if ishandle(progfig)
        delete(progfig);
    end
    
    progfig  = [];
    progdata = [];
end

%create new progress bar if needed
if isempty(progfig) || ~ishandle(progfig)
    %figure size and axes padding for the single bar case
    height = 0.05;
    width  = height * 8;
    
    hpad = 0.02;
    vpad = 0.25;
    
    %
    n_bars = max(ninput, length(progdata));
    
    %adjust figure size and axes padding
    height_factor = (1 - vpad) * n_bars + vpad;
    
    height = height * height_factor;
    vpad   = vpad / height_factor;
    
    %initialize bar
    left   = (1 - width) / 2;
    bottom = (1 - height) / 2;
    
    progfig = figure('units', 'normalized', ...
                     'position', [left, bottom width height], ...
                     'numbertitle', 'off', ...
                     'resize', 'off', ...
                     'menubar', 'none');
                 
    %initialize axes, patch, text for each bar
    left = hpad;
    width= 1 - 2 * hpad;
    vpad_total = vpad * (n_bars + 1);
    height = (1 - vpad_total) / n_bars;
    
    for i = 1 : n_bars
        %creat axes, patch, text
        bottom = vpad + (vpad + height) * (n_bars - i);
        
        progdata(i).progaxes = axes(...
                            'position', [left, bottom, width, height], ...
                            'xlim', [0 1], 'ylim', [0 1], 'box', 'on', ...
                            'xtick', [], 'ytick', []);
        progdata(i).progpatch = patch('xdata', [0 0 0 0], ...
                                      'ydata', [0 0 1 1]);
        progdata(i).progtext = text(0.99, 0.5, '', ...
                                    'horizontalalignment', 'right', ...
                                    'fontunits', 'normalized', ...
                                    'fontsize', 0.7);
        progdata(i).proglabel = text(0.01, 0.5, '', ...
                                     'horizontalalignment', 'left', ...
                                     'fontunits', 'normalized', ...
                                     'fontsize', 0.7);
        
        if ischar(input{i})
            set(progdata(i).proglabel, 'string', input{i})
            input{i} = 0;
        end
        
        %Set callbacks to change color on mouse click
        set(progdata(i).progaxes,  'buttondownfcn', ...
            {@change_color, progdata(i).progpatch})
        set(progdata(i).progpatch, 'buttondownfcn', ...
            {@change_color, progdata(i).progpatch})
        set(progdata(i).progtext,  'buttondownfcn', ...
            {@change_color, progdata(i).progpatch})
        set(progdata(i).proglabel, 'buttondownfcn', ...
            {@change_color, progdata(i).progpatch})
        
        % Pick a random color for this patch
        change_color([], [], progdata(i).progpatch)
                        
        %set starting time
        if ~isfield(progdata(i), 'starttime') || isempty(progdata(i).starttime)
            progdata(i).starttime = clock;
        end
    end
    
    %set time of last update to ensure a redraw
    lastupdate = clock - 1;            
end

%process inputs and update state of progdata
for i = 1 : ninput
    if ~isempty(input{i})
        progdata(i).fraction_done = input{i};
        progdata(i).clock = clock;
    end
end

%enforce a minimum time interval between graphics updates
myclock = clock;
if abs(myclock(6) - lastupdate(6)) < 0.01
    return;
end

%update progress patch
for i = 1 : length(progdata)
    set(progdata(i).progpatch, 'xdata', ...
        [0, progdata(i).fraction_done, progdata(i).fraction_done, 0]);
end

%update progress text if there is more than one bar
if length(progdata) > 1
    for i = 1 : length(progdata)
        set(progdata(i).progtext, 'string', ...
            sprintf('%ld%%', floor(100 * progdata(i).fraction_done)));
    end
end

%update progress figure titile bar
if progdata(1).fraction_done > 0
    runtime = etime(progdata(1).clock, progdata(1).starttime);
    remained_time = runtime / progdata(1).fraction_done - runtime;
    remained_time_str = sec2time_str(remained_time);
    title_bar_str = sprintf('%2d%%    %s remaining', ...
                            floor(100 * progdata(1).fraction_done), ...
                            remained_time_str);
else
    title_bar_str = ' 0%';
end
set(progfig, 'name', title_bar_str);

%force redraw to show changes
drawnow;

%record time of update
lastupdate = clock;
%--------------------------------------------------------------------------
end

function time_str = sec2time_str(sec)
% Convert a time measurement from seconds into a human readable string.

% Convert seconds to other units
w   = floor(sec / 604800); %weeks
sec = sec - w * 604800;
d   = floor(sec / 86400);  %days
sec = sec - d * 86400;
h   = floor(sec / 3600);   %hours
sec = sec - h * 3600;
m   = floor(sec / 60);     %minutes
sec = sec - m * 60;
s   = floor(sec);          %seconds

% Create time string
if w > 0
    if w > 9
        time_str = sprintf('%d w', w);
    else
        time_str = sprintf('%d w, %d d', w, d);
    end
elseif d > 0
    if d > 9
        time_str = sprintf('%d d', d);
    else
        time_str = sprintf('%d d, %d h', d, h);
    end
elseif h > 0
    if h > 9
        time_str = sprintf('%d h', h);
    else
        time_str = sprintf('%d h, %d m', h, m);
    end
elseif m > 0
    if m > 9
        time_str = sprintf('%d m', m);
    else
        time_str = sprintf('%d m, %d s', m, s);
    end
else
    time_str = sprintf('%d s', s);
end

end

function change_color(~, ~, progpatch)
% Change the color of the progress bar patch

% Prevent color from being too dark or too light
min_color = 1.5;
max_color = 2.8;

this_color = rand(1, 3);
while (sum(this_color) < min_color) || (sum(this_color) > max_color)
    this_color = rand(1, 3);
end

set(progpatch, 'facecolor', this_color)
end