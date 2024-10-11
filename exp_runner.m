% clc, clearvars
% finding all the tables
figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');
% (Estimate Fluxes) , 

% the tables and their field names are 
% table 25 is the edit experiment tables

exp_table = tables(25);
exp_table_data = exp_table.Data;

% iterating over the experiments present in the table
num_flux_estimate_clicks = 5;

for exp = 1:size(exp_table_data, 1)

    % for sanity reason, unchecking all the exps, just to make sure or if the user interupts the UI
    for i = 1:size(exp_table_data, 1)
        exp_table_data{i, 4} = false;
    end

    % clicking on updating the data #update model data button is 16th button # all the buttons are listed in UI controls text file
    % the button wont be available for the first run
    if exp > 1
        update_data_button = buttons(16);
        callbackFunction = update_data_button.Callback;
        callbackFunction(update_data_button, []);
    end
    
    % once the exp box is checked, we need to run the experiment
    for iters = 1:num_flux_estimate_clicks

        exp_table_data{exp, 4} = true;  % 4th column is the active checkbox column
        % updating the table data
        exp_table.Data = exp_table_data;

        % estimated fluxes button is 17th button . #all the buttons are listed in UI controls text file
        estimated_fluxes_button = buttons(17);
        callbackFunction = estimated_fluxes_button.Callback;
        callbackFunction(estimated_fluxes_button, []);

        % clicking on updating the data #update model data button is 16th button # all the buttons are listed in UI controls text file
        update_data_button = buttons(16);
        callbackFunction = update_data_button.Callback;
        callbackFunction(update_data_button, []);

    end

    % once experiment is done we need to save the metadata and the fluxes
    % the fluxes are populated in table 7 # list of all tables are in the tables text file
    flux_table = tables(7);
    flux_table_data = flux_table.Data;
    % write this table data to a csv file
    writecell(flux_table_data, strcat('exp_', num2str(exp), '_fluxes.csv'));

    % fetching the fit information
    fit_info = buttons(20); % 20th button is the fit information button, checkout the list of buttons in the UI controls text file
    textCells = get(fit_info, 'String');
    % write the fit information to a text file in append mode
    fit_info_file = fopen('fit_info2.txt', 'a');
    fprintf(fit_info_file, 'Experiment num %d:\n', exp);
    fprintf(fit_info_file, 'Experiment  %s\n', exp_table_data{exp, 2});
    for line = 1:length(textCells)
        fprintf(fit_info_file, '%s\n', textCells{line});
    end
    fclose(fit_info_file);
end