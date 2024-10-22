clc, clear;

start_time = datetime('now');
figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');

% the tables and their field names are 
% table 25 is the edit experiment tables
exp_table = tables(25);

% iterating over the experiments present in the table
num_flux_estimate_clicks = 3;             
pause(2)
ssr_table = table();

for exp = 1: 20%size(exp_table.Data, 1)

    % Mock-up of the CellEditData structure
    
    fprintf("===================\n")                                                                                                 ;
    fprintf("beginning the experiment %s\n", exp_table.Data{exp, 2})
    exp_table = tables(25);
    exp_checkbox(exp_table, exp, true) 
    drawnow;
    % checking how many boxes ticked in 4th column
    num_boxes_ticked = sum(cell2mat(exp_table.Data(:, 4)));

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

    temp_table_data = exp_table.Data;
    filtered_data = temp_table_data([temp_table_data{:,4}] == true, :);
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
        drawnow;

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

    parsed_ssr_string = strjoin(string(parsed_ssr), ',');
    ssr_record = table(string(exp), string(exp_name_from_table), string(exp_table.Data{exp, 2}), string(smallest_ssr), parsed_ssr_string, string(index) , 'VariableNames', {'exp_num', 'exp_name_from_table', 'exp_name_sanity_check', 'smallest_ssr', 'all_ssr', 'chosen_ssr'});
    
    ssr_table = [ssr_table; ssr_record]; %#ok<AGROW>
    writecell(flux_table_data_cellarray{index}, strcat('output/exp_num_', num2str(exp), '_exp_id_',(exp_name_from_table), '_fluxes.csv'));

    % write the fit information to a text file in append mode
    fit_info_file = fopen('fit_info.txt', 'a');
    fprintf(fit_info_file, '========================\n');
    fprintf(fit_info_file, 'Experiment num :: %d\n', exp);
    fprintf(fit_info_file, 'Experiment ID ::  %s\n', exp_table.Data{exp, 2});
    textCells = ssr_data_cellarray{index};
    for line = 1:length(textCells)
        fprintf(fit_info_file, '%s\n', textCells{line});
    end
    fprintf(fit_info_file, '\n');
    fclose(fit_info_file);
    fprintf("=================\n")
    writetable(ssr_table, "ssr_stats.csv");

    exp_table = tables(25);
    exp_checkbox(exp_table, exp, false)

end

end_time = datetime('now');
fprintf("total time taken is %s\n", end_time - start_time)



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

function exp_checkbox(exp_table, exp, value)

    event = struct;
    event.Indices = [exp, 4];  % The original indices before sorting
    event.DisplayIndices = [exp, 4];  % The indices as displayed, assuming no sorting
    event.PreviousData = exp_table.Data(exp, 4);  % Capture previous data, assuming it exists
    event.EditData = value;  % The user's input
    event.NewData = value;  % What MATLAB will attempt to write to the Data array
    event.Error = '';  % Start with no error
    event.Source = exp_table;  % Component executing the callback
    event.EventName = 'CellEdit';  % The type of event
    exp_table.Data{exp, 4} = value;

    % Check if the callback is set to a function handle before calling
    if isa(exp_table.CellEditCallback, 'function_handle')
        feval(exp_table.CellEditCallback, exp_table, event);
    else
        error('CellEditCallback is not set to a valid function handle.');
    end

end