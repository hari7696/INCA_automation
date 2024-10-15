% clc, clearvars
% finding all the tables
figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');
% (Estimate Fluxes) , 

% the tables and their field names are 
% table 25 is the edit experiment tables

exp_table = tables(25);
exp_table_data = exp_table.Data

% iterating over the experiments present in the table
num_flux_estimate_clicks = 3;

for exp = 1:size(exp_table_data, 1)

    for i = 1:size(exp_table_data, 1)
        exp_table_data{i, 4} = false;
    end

    exp_table_data{4, 4} = true;  % 4th column is the active checkbox column
    exp_table.Data = exp_table_data;
    pause(2);
    drawnow;

    fprintf("beginning the experiment")

    for iters = 1:num_flux_estimate_clicks

        figs = findall(groot, 'Type', 'Figure');
        tables = findall(figs, 'Type', 'uitable');
        buttons = findall(figs, 'Type', 'UIControl');
        
        fprintf("======== Beginning of the iteration =========\n")
        pause(2);

        fprintf("clicking estimated fluxes button\n");
        estimated_fluxes_button = buttons(17);
        eventData = struct('Source', estimated_fluxes_button, 'EventName', 'Action');
        estimated_fluxes_button.Callback(estimated_fluxes_button, eventData);
        fprintf("Estimated fluxes button clicked\n");


        pause(5); % Wait for processing (adjust based on your application's needs)
        drawnow;
        fprintf("clicking on update model button\n");
        update_model_button = buttons(16);
        callbackFunction2 = update_model_button.Callback;
        callbackFunction2(update_model_button, []);
        fprintf("update model button clicked")
        pause(2);
        fprintf("======== End of the iteration =========\n")


    end

    fprintf("experiment done")


    flux_table = tables(7);
    flux_table_data = flux_table.Data;
    writecell(flux_table_data, strcat('output/exp_num_', num2str(exp), '_exp_id_',(exp_table_data{exp, 2}), '_fluxes.csv'));

    % fetching the fit information
    fit_info = buttons(20); % 20th button is the fit information button, checkout the list of buttons in the UI controls text file
    textCells = get(fit_info, 'String');
    % write the fit information to a text file in append mode
    fit_info_file = fopen('fit_info.txt', 'a');
    fprintf(fit_info_file, 'Experiment num :: %d\n', exp);
    fprintf(fit_info_file, 'Experiment ID ::  %s\n', exp_table_data{exp, 2});
    for line = 1:length(textCells)
        fprintf(fit_info_file, '%s\n', textCells{line});
    end
    fprintf(fit_info_file, '========================\n\n');
    fclose(fit_info_file);
    pause(10);
end