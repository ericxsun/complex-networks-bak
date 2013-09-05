classdef progress_bar_console < handle
%PROGRESS_BAR_CONSOLE provide an indication of the long running operations 
%using text. It is possible to measure the elapsed and remained time.
%
%Syntax: 
% cpb = PROGRESS_BAR_CONSOLE()
%
%Example:
% see progress_bar_console_example.m
%
%Ref:
% The code coded by Evgeny Prilepin
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: progress_bar_console_example, progress_bar_gui, waitbar

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------
properties(GetAccess = public, SetAccess = private)
    left_margin  = 1;    %left margin in characters
    top_margin   = 1;    %top margin in rows
    progress_len = 50;   %length of progress bar in characters
    minimum_value= 0;    
    maximum_value= 100;
    current_value= 0;
    
    text = '';
    text_visible  = true;
    text_position = 'right';   %'left' or 'right'
    
    percentage_visible = true;
    percentage_position= 'left';    %'left' or 'right'
    
    elapsed_time_visible = false;
    elapsed_time_position= 'right';
    
    remained_time_visible = false;
    remained_time_position= 'right';
    
    percentage  = 0;
    elapsed_time = 0;    %in seconds
    remained_time= inf;  %in seconds
end

properties(Access = private)
    started = false;
    
    bar_buffer = '';
    bar_str = '';
    bar_prev_string_len= 0;
    
    time_start = 0;
    time_stamp = [];
    pct_stamp  = [];    %percentage stamp
end

methods(Access = public)
    function obj = progress_bar_console()
        %create an instance of console progress bar
        %
        %usage:
        % obj = progress_bar_console_()
        %
        
        narginchk(0, 0);
    end
    
    function start(obj)
        %initialize and start new progress bar
        %
        %usage:
        % obj.start()
        % start(obj)
        %
        
        narginchk(1, 1);
        
        obj.stop();
        
        obj.started = true;
        
        obj.update();
        obj.reset_time();
    end
    
    function stop(obj)
        %stop the current progress bar
        %
        %usage:
        % obj.stop()
        % stop(obj)
        %
        
        narginchk(1, 1);
        
        obj.bar_str = '';
        obj.bar_prev_string_len = 0;
        
        obj.started = false;
        obj.shift2newline(); 
    end
    
    function reset(obj)
        %reset progress bar to the minimum value
        %
        %usage:
        % obj.reset()
        % reset(obj)
        %
        
        narginchk(1, 1);
        
        obj.set_value(obj.minimum_value);
        obj.reset_time();
    end
    
    function set_length(obj, len)
        %set the length of progress bar to len
        %
        %usage:
        % obj.set_length(len)
        % set_length(obj, len)
        %
        %input:
        % len -length in characters
        %
        
        narginchk(2, 2);
        
        validateattributes(len, {'numeric'}, ...
                           {'scalar', '>=', 10, '<=', 500}, ...
                           mfilename('fullpath'), 'progress bar length');
    
        obj.progress_len = len;
        obj.update();
    end
    
    function set_left_margin(obj, margin)
        %set margin of the left edge of the command window
        %
        %usage:
        % obj.set_left_margin(margin)
        % set_left_margin(obj, margin)
        %
        %input:
        % margin -margin in characters
        %
        
        narginchk(2, 2);

        validateattributes(margin, {'numeric'}, ...
                           {'scalar', '>=', 0, '<=', 100}, ...
                           mfilename('fullpath'), 'left margin'); 
                       
        obj.left_margin = margin;
        obj.update();
    end
    
    function set_top_margin(obj, margin)
        %set the number of lines shift progress bar down
        %
        %usage:
        % obj.set_top_margin(margin)
        % set_top_margin(obj, margin)
        %
        %input:
        % margin -margin in rows
        %
        
        narginchk(2, 2);

        validateattributes(margin, {'numeric'}, ...
                           {'scalar', '>=', 0, '<=', 10}, ...
                           mfilename('fullpath'), 'top margin'); 
                       
        obj.top_margin = margin;
    end    

    function set_value(obj, value)
        %set current value of progress bar
        %
        %usage:
        % obj.set_value(value)
        % set_value(obj, value)
        %
        %input:
        % value -the current value of progress in range [minimum maximum]
        %
        
        narginchk(2, 2);

        validateattributes(value, {'numeric'}, ...
                           {'scalar', '>=', obj.minimum_value, ...
                                      '<=', obj.maximum_value}, ...
                           mfilename('fullpath'), 'progress value'); 
                       
        obj.current_value = value;
        obj.update();
        obj.measure_time();
    end  

    function set_minimum_value(obj, value)
        %set minimum value of progress bar
        %
        %usage:
        % obj.set_minimum_value(value)
        % set_minimum_value(obj, value)
        %
        %input:
        % value -the minimum value of progress in range [minimum maximum]
        %
        
        narginchk(2, 2);

        validateattributes(value, {'numeric'}, ...
                           {'scalar', '<', obj.maximum_value}, ...
                           mfilename('fullpath'), 'minimum value'); 
                       
        obj.minimum_value = value;
        
        if(obj.current_value < obj.minimum_value)
            obj.current_value = obj.minimum_value;
        end
        
        obj.update();
    end  

    function set_maximum_value(obj, value)
        %set maximum value of progress bar
        %
        %usage:
        % obj.set_maximum_value(value)
        % set_maximum_value(obj, value)
        %
        %input:
        % value -the minimum value of progress in range [minimum maximum]
        %
        
        narginchk(2, 2);

        validateattributes(value, {'numeric'}, ...
                           {'scalar', '>', obj.minimum_value}, ...
                           mfilename('fullpath'), 'maximum value'); 
                       
        obj.maximum_value = value;
        
        if(obj.current_value > obj.maximum_value)
            obj.current_value = obj.maximum_value;
        end
        
        obj.update();
    end 
    
    function set_text(obj, value)
        %set text, which will be displayed
        %
        %usage:
        % obj.set_text(value)
        % set_text(obj, value)
        %
        %input:
        % value -the minimum value of progress in range [minimum maximum]
        %
        
        narginchk(2, 2);

        validateattributes(value, {'char'}, {'row'}, ...
                           mfilename('fullpath'), 'text'); 
                       
        value = regexprep(value, sprintf('(\n|\r)'), '');
        obj.text = value;
        
        obj.update();
    end
    
    function set_text_visible(obj, flag)
        %usage:
        % obj.set_text_visible(flag)
        % set_text_visible(obj, flag)
        %
        %input:
        % flag -true for visible, false-for invisible
        %
        
        narginchk(2, 2);
        
        validateattributes(flag, {'numeric', 'logical'}, ...
                           {'scalar', '>=', 0, '<=', 1}, ...
                           mfilename('fullpath'), 'text visible');

        obj.text_visible = flag;
        obj.update();
        obj.show_progress_bar();
    end
    
    function set_text_position(obj, pos)
        %usage:
        % obj.set_text_position(pos)
        % set_text_position(obj, pos)
        %
        %input:
        % pos -text position, 'left' or 'right'
        %
        
        narginchk(2, 2);
        
        pos = validatestring(lower(pos), {'left', 'right'}, ...
                             mfilename('fullpath'), 'text position');

        obj.text_position = pos;
        obj.update();
    end
    
    function set_percentage_visible(obj, flag)
        %usage:
        % obj.set_percentage_visible(flag)
        % set_percentage_visible(obj, flag)
        %
        %input:
        % flag -percentage visible flag, true for visible, false for 
        %invisible
        %
        
        narginchk(2, 2);
        
        validateattributes(flag, {'numeric', 'logical'}, ...
                           {'scalar', '>=', 0, '<=', 1}, ...
                           mfilename('fullpath'), ...
                           'percentage text visible');
                       
        obj.percentage_visible = flag;
        obj.update();
    end
    
    function set_percentage_position(obj, pos)
        %usage:
        % obj.set_percentage_position(pos)
        % set_percentage_position(obj, pos)
        %
        %input:
        % pos -percentage text position, 'left' or 'right'
        %
        
        narginchk(2, 2);
        
        pos = validatestring(lower(pos), {'left', 'right'}, ...
                             mfilename('fullpath'), ...
                             'percentage text position');
                         
        obj.percentage_position = pos;
        obj.update();
    end
    
    function set_elapsed_time_visible(obj, flag)
        %usgae:
        % obj.set_elapsed_time_visible(flag)
        % set_elapsed_time_visible(obj, flag)
        %
        %input:
        % flag -elapsed_time text visible flag, true for visible, false for
        % invisible
        %
        
        narginchk(2, 2);
        
        validateattributes(flag, {'numeric', 'logical'}, ...
                           {'scalar', '>=', 0, '<=', 1}, ...
                           mfilename('fullpath'), ...
                           'elapsed_time text visible');
                       
        obj.elapsed_time_visible = flag;
        obj.update();
    end
    
    function set_elapsed_time_position(obj, pos)
        %usage:
        % obj.set_elapsed_time_position(pos)
        % set_elapsed_time_position(obj, pos)
        %
        %input:
        % pos -elaspedtime text position, 'left' or 'right'
        %
        
        narginchk(2, 2);
        
        pos = validatestring(lower(pos), {'left', 'right'}, ...
                             mfilename('fullpath'), ...
                             'elapsed_time text position');
                             
        obj.elapsed_time_position = pos;
        obj.update();
    end
    
    function set_remained_time_visible(obj, flag)
        %usgae:
        % obj.set_remained_time_visible(flag)
        % set_remained_time_visible(obj, flag)
        %
        %input:
        % flag -remained_time text visible flag, true for visible, false for
        % invisible
        %
        
        narginchk(2, 2);
        
        validateattributes(flag, {'numeric', 'logical'}, ...
                           {'scalar', '>=', 0, '<=', 1}, ...
                           mfilename('fullpath'), ...
                           'remained_time text visible');
                       
        obj.remained_time_visible = flag;
        obj.update();
    end
    
    function set_remained_time_position(obj, pos)
        %usage:
        % obj.set_remained_time_position(pos)
        % set_remained_time_position(obj, pos)
        %
        %input:
        % pos -elaspedtime text position, 'left' or 'right'
        %
        
        narginchk(2, 2);
        
        pos = validatestring(lower(pos), {'left', 'right'}, ...
                             mfilename('fullpath'), ...
                             'remained_time text position');
                             
        obj.remained_time_position = pos;
        obj.update();
    end
        
    function str = get_elapsed_time_str(obj, format)
        %usage:
        % obj.get_elapsed_time_str(format)
        % get_elapsed_time_str(obj, format)
        %
        %input:
        % format: DATESTR supported format
        %
        %example:
        % str = obj.get_elapsed_time_str('HH:MM:SS.FFF')
        %
        
        narginchk(2, 2);
        
        elapsed_time_num = datenum([0 0 0 0 0 obj.elapsed_time]);
        str = datestr(elapsed_time_num, format);
    end
    
    function str = get_remained_time_str(obj, format)
        %usage:
        % obj.get_remained_time_str(format)
        % get_remained_time_str(obj, format)
        %
        %input:
        % format: DATESTR supported format
        %
        %example:
        % str = obj.get_remained_time_str('HH:MM:SS.FFF')
        %
        
        narginchk(2, 2);
        
        if ~isinf(obj.remained_time)
            remained_time_num = datenum([0 0 0 0 0 obj.remained_time]);
            str = datestr(remained_time_num, format);
        else
            str = '--/--';
        end
    end    
end

methods(Access = private)
    function update(obj)
        if obj.started
            obj.calculate_percentage();
            obj.fill_progress_bar();
            obj.update_progress_str();
            obj.show_progress_bar();
        end
    end
    
    function calculate_percentage(obj)
        assert(obj.maximum_value > obj.minimum_value);
        
        rate = 100 / (obj.maximum_value - obj.minimum_value);
        
        obj.percentage = (obj.current_value - obj.minimum_value) * rate;
    end
    
    function fill_progress_bar(obj)
        obj.bar_buffer = repmat('-', [1 obj.progress_len]);
        
        filled_part = round(obj.progress_len * obj.percentage / 100);
        
        if filled_part > 0
            obj.bar_buffer(1 : filled_part - 1) = '=';
            obj.bar_buffer(filled_part) = '>';
        end
        
        obj.bar_buffer = ['[', obj.bar_buffer, ']'];
    end
    
    function update_progress_str(obj)
        obj.bar_prev_string_len = length(obj.bar_str);
        obj.bar_str = obj.bar_buffer;
        
        obj.add_percentage_str();
        obj.add_time_str();
        obj.add_text_str();
        
        obj.bar_str = [blanks(obj.left_margin), obj.bar_str];        
    end
    
    function add_percentage_str(obj)
        if obj.percentage_visible
            percentage_text = sprintf('%d%%', fix(obj.percentage));
            margin_blanks   = blanks(4 - length(percentage_text));
            
            switch obj.percentage_position
                case 'left'
                    obj.bar_str = [margin_blanks, percentage_text, ...
                                      ' ', obj.bar_str];
                case 'right'
                    obj.bar_str = [obj.bar_str,' ',  ...
                                      margin_blanks, percentage_text];
            end
        end
    end   

    function add_time_str(obj)
        if all(strcmpi('left', {obj.elapsed_time_position, ...
                               obj.remained_time_position}))
            cat_fun = @(e, r, es, rs)[e, es, r, rs, obj.bar_str];
        elseif all(strcmpi('right', {obj.elapsed_time_position, ...
                                    obj.remained_time_position}))
            cat_fun = @(e, r, es, rs)[obj.bar_str, es, e, rs, r];
        elseif all(strcmpi({'left', 'right'}, {obj.elapsed_time_position, ...
                                              obj.remained_time_position}))
            cat_fun = @(e, r, es, rs)[e, es, obj.bar_str, rs, r];
        elseif all(strcmpi({'right', 'left'}, {obj.elapsed_time_position, ...
                                              obj.remained_time_position}))
            cat_fun = @(e, r, es, rs)[r, rs, obj.bar_str, es, e];
        end
        
        elapsed_time_str = '';
        remained_time_str= '';
        es = '';
        rs = '';
        
        to_vec = @(s)datevec(datenum([0 0 0 0 0 round(s)]));
        to_str = @(h, m, s)sprintf('%02d:%02d:%02d', h, m, s);
        
        if obj.elapsed_time_visible
            dv = to_vec(obj.elapsed_time);
            elapsed_time_str = ['E ', to_str(dv(4), dv(5), dv(6))];
            es = ' ';
        end
        
        if obj.remained_time_visible
            if ~isinf(obj.remained_time)
                dv = to_vec(obj.remained_time);
                remained_time_str = ['R ', to_str(dv(4), dv(5), dv(6))];
            else
                remained_time_str = 'R --/--';
            end
            
            rs = ' ';
        end
        
        obj.bar_str = cat_fun(elapsed_time_str, remained_time_str, ...
                                 es, rs);
    end
    
    function add_text_str(obj)
        if obj.text_visible
            switch obj.text_position
                case 'left'
                    obj.bar_str = [obj.text, ' ', obj.bar_str];
                case 'right'
                    obj.bar_str = [obj.bar_str, ' ', obj.text];
            end
        end
    end
    
    function show_progress_bar(obj)
        backspace = sprintf('\b');
        backspace = backspace(ones(1, obj.bar_prev_string_len));
        
        fprintf('%s%s', backspace, obj.bar_str);
    end
    
    function shift2newline(obj)
        newline = sprintf('\n');
        newline = newline(ones(1, obj.top_margin));
        
        fprintf(newline);
    end
    
    function reset_time(obj)
        obj.time_start = tic;
        
        obj.elapsed_time = 0;
        obj.remained_time= inf;
        
        obj.time_stamp = [];
        obj.pct_stamp  = [];
    end
    
    function measure_time(obj)
        obj.elapsed_time = toc(obj.time_start);
        
        %accumulate time and percentage
        obj.time_stamp = horzcat(obj.time_stamp, obj.elapsed_time);
        obj.pct_stamp  = horzcat(obj.pct_stamp,  obj.percentage);
        
        %predict remained time(simple linear least square estimation)
        %y = k*x + b, b == 0
        if length(obj.time_stamp) > 1
            xy = sum(obj.time_stamp .* obj.pct_stamp);
            x2 = sum(obj.pct_stamp .* obj.pct_stamp);
            
            predicted_time = (xy / x2) * 100;
            
            obj.remained_time = abs(predicted_time - obj.elapsed_time);
        end            
    end
end

%--------------------------------------------------------------------------
end
