clc, clear;
% finding all the tables
import java.awt.Robot;
import java.awt.event.KeyEvent;
robot = Robot;

start_time = datetime('now');

figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');
% (Estimate Fluxes) , 

% the tables and their field names are 
% table 25 is the edit experiment tables

exp_table = tables(25);
exp_table_data = exp_table.Data;

% iterating over the experiments present in the table
num_flux_estimate_clicks = 3;             
pause(6)
ssr_table = table();

for exp = 1: 20%size(exp_table_data, 1)
                                                                                                                        ;
    fprintf("beginning the experiment %s\n", exp_table_data{exp, 2})

    % sanity checks
    exp_table = tables(25);
    exp_table_data = exp_table.Data;
    % checking how many boxes ticked in 4th column
    num_boxes_ticked = sum(cell2mat(exp_table_data(:, 4)));

    % getting the experiment name from the table which is in 2nd column and 4th column needs to be checked
    % Filter rows where the 4th column equals true
    if num_boxes_ticked == 0
        fprintf("No box ticked, please check the table. Somethign went wrong with clicks\n")
        % braking the loop
        break
    end

    if num_boxes_ticked > 1
        fprintf("More than one box ticked, please check the table. Somethign went wrong with clicks\n")
        % braking the loop
        break
    end

    filtered_data = exp_table_data([exp_table_data{:,4}] == true, :);
    exp_name_from_table = filtered_data(:, 2);
    exp_name_from_table = exp_name_from_table{1};

    % holding each experiment result in cell array and save the one that have the best SSR
    flux_table_data_cellarray = {};
    ssr_data_cellarray = {};
    parsed_ssr = [];

    % once the exp box is checked, we need to run the experiment
    for iters = 1:num_flux_estimate_clicks

        % estimated fluxes button is 17th button . #all the buttons are listed in UI controls text file
        estimated_fluxes_button = buttons(17);
        callbackFunction = estimated_fluxes_button.Callback;
        callbackFunction(estimated_fluxes_button, []);
        pause(1);

        update_model_button = buttons(16);
        callbackFunction2 = update_model_button.Callback;
        callbackFunction2(update_model_button, []);
        pause(1);

        flux_table = tables(7);
        flux_table_data = flux_table.Data;
        flux_table_data_cellarray{end+1} = flux_table_data; %#ok<SAGROW>

        fit_info = buttons(20); % 20th button is the fit information button, checkout the list of buttons in the UI controls text file
        textCells = get(fit_info, 'String');
        ssr_data_cellarray{end+1} = textCells; %#ok<SAGROW>
        parsed_ssr(end+1) = parse_ssr(textCells); %#ok<SAGROW>
    end

    [smallest_ssr, index] = min(parsed_ssr);
    fprintf("ssr array is %s\n", mat2str(parsed_ssr))
    fprintf("Smallest SSR is %f at iteration %d\n", smallest_ssr, index);
    disp(string(exp));
    disp(string(exp_name_from_table));
    disp(string(exp_table_data{exp, 2}));
    disp(string(smallest_ssr));
    disp(mat2str(parsed_ssr));
    disp(string(index));

    parsed_ssr_string = strjoin(string(parsed_ssr), ',');
    ssr_record = table(string(exp), string(exp_name_from_table), string(exp_table_data{exp, 2}), string(smallest_ssr), parsed_ssr_string, string(index) , 'VariableNames', {'exp_num', 'exp_name_from_table', 'exp_name_sanity_check', 'smallest_ssr', 'all_ssr', 'chosen_ssr'});
    
    ssr_table = [ssr_table; ssr_record]; %#ok<AGROW>
    % have to resort to manual click, as Its nearly impossible to figure out the input of the celleditcallback of the table
    % unchekcing
    tab_stroke(4, robot)

    arrow_stroke(exp-1, robot )                            
    space_stroke(robot)

    arrow_stroke(1, robot )                            
    space_stroke(robot)

    % write this table data to a csv file
    writecell(flux_table_data_cellarray{index}, strcat('output/exp_num_', num2str(exp), '_exp_id_',(exp_name_from_table), '_fluxes.csv'));

    % write the fit information to a text file in append mode
    fit_info_file = fopen('fit_info.txt', 'a');
    fprintf(fit_info_file, '========================\n');
    fprintf(fit_info_file, 'Experiment num :: %d\n', exp);
    fprintf(fit_info_file, 'Experiment ID ::  %s\n', exp_table_data{exp, 2});
    textCells = ssr_data_cellarray{index};
    for line = 1:length(textCells)
        fprintf(fit_info_file, '%s\n', textCells{line});
    end
    fprintf(fit_info_file, '\n');
    fclose(fit_info_file);
    fprintf("=================\n")
    % clear flux_table_data_cellarray;
    % clear ssr_data_cellarray;
    % clear parsed_ssr;
    pause(1);
    writetable(ssr_table, "ssr_stats.csv");                                                                 
end

end_time = datetime('now');
fprintf("total time taken is %s\n", end_time - start_time)

function arrow_stroke(n, robot)
    import java.awt.event.KeyEvent;
    for i=1:n
        robot.keyPress(KeyEvent.VK_DOWN);
        robot.keyRelease(KeyEvent.VK_DOWN);
    end
    pause(1)

end

function space_stroke(robot)
    import java.awt.event.KeyEvent;
    robot.keyPress(KeyEvent.VK_SPACE);
    robot.delay(100);
    robot.keyRelease(KeyEvent.VK_SPACE);
    robot.delay(100);
    pause(0.2)
end

function tab_stroke(n, robot)
    import java.awt.event.KeyEvent;
    for i=1:n
        robot.keyPress(KeyEvent.VK_TAB);
        robot.keyRelease(KeyEvent.VK_TAB);
        robot.delay(20)
    end
end

function p_ssr = parse_ssr(textcellsdata)

    for i = 1:length(textcellsdata)
        currentLine = textcellsdata{i}; % Get the current line
        % Check if the current line contains "SSR"
        if contains(currentLine, 'SSR = ')
            break;
        end
    end
    numbers = regexp(currentLine, '\d+(\.\d+)?', 'match');
    p_ssr = str2double(numbers{1});
    % parsing the ssr data
end