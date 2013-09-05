function progress_bar_console_example()
%examples for progress bar console demo.
%>>type progress_bar_console_example
%

fprintf('console progress bar Demo:\n\n')

% Create instance progress bar
cpb = progress_bar_console();

% Set progress bar parameters
cpb.set_left_margin(4);   % progress bar left margin
cpb.set_top_margin(1);    % rows margin

cpb.set_length(40);      % progress bar length: [.....]
cpb.set_minimum_value(0);      % minimum value of progress range [min max]
cpb.set_maximum_value(100);    % maximum value of progress range [min max]

% Set text position
cpb.set_percentage_position('left');
cpb.set_text_position('right');

% 3 Console Progress Bars
fprintf('\n\n----------------------------------------------------------\n')
fprintf('3 Console Progress Bars:')

for i = 1:3
    % Start new progress bar
    cpb.start();
    
    for k = 0:100
        text = sprintf('Progress %d: %d/%d', i, k, 100);
        
        cpb.set_value(k);  	% update progress value
        cpb.set_text(text);  % update user text
        
        pause(0.025)
    end
end

% Stop progress bar
cpb.stop();


% 1 Progress Bar with 2 replaces
fprintf('\n\n----------------------------------------------------------\n')
fprintf('1 Console Progress Bar with 2 replaces:')

% Start new progress bar
cpb.start();

for i = 1:2
    for k = 0:100
        text = sprintf('Progress %d: %d/%d', i, k, 100);
        
        cpb.set_value(k);
        cpb.set_text(text);
        
        pause(0.025)
    end
end

cpb.stop();

% Elapsed time and remaining time display
fprintf('\n\n----------------------------------------------------------\n')
fprintf('Elapsed time and remaining time display:')

min_val = 0;
max_val = 1000;

cpb.set_minimum_value(min_val);
cpb.set_maximum_value(max_val);

cpb.set_elapsed_time_visible(1);
cpb.set_remained_time_visible(1);

cpb.set_elapsed_time_position('left');
cpb.set_remained_time_position('right');

cpb.start();

for k = min_val:max_val
    
%     text = sprintf('Progress: %d/%d', k, max_val);
    
    cpb.set_value(k);
    cpb.set_text(text);
    
    pause(0.01)
end

cpb.stop();

end