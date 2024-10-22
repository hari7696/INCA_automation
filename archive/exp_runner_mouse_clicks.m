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
num_flux_estimate_clicks = 3;

for exp = 1: 7%size(exp_table_data, 1)

    % have to resort to manual click, as Its nearly impossible to figure out the input of the celleditcallback of the table
    robot.mouseMove(xPosition, yPosition);  
    robot.delay(300)
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.delay(300);  % Delay to ensure the click is registered
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
    robot.delay(200);
    pause(0.5)

    fprintf("beginning the experiment %s\n", exp_table_data{exp, 2})
    % once the exp box is checked, we need to run the experiment
    for iters = 1:num_flux_estimate_clicks


        % estimated fluxes button is 17th button . #all the buttons are listed in UI controls text file
        estimated_fluxes_button = buttons(17);
        callbackFunction = estimated_fluxes_button.Callback;
        callbackFunction(estimated_fluxes_button, []);
        pause(5);


        update_model_button = buttons(16);
        callbackFunction2 = update_model_button.Callback;
        callbackFunction2(update_model_button, []);

        pause(2);
    end

                % have to resort to manual click, as Its nearly impossible to figure out the input of the celleditcallback of the table
    robot.mouseMove(xPosition, yPosition);  
    robot.delay(300)
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.delay(300);  % Delay to ensure the click is registered
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
    robot.delay(200);
    pause(0.5)
    
    % Down button
    x_down = 904;
    y_down = 399;
    % Move the mouse and click
    robot.mouseMove(x_down, y_down);
    robot.delay(200);
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.delay(200);  % Delay to ensure the click is registered
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
    robot.delay(100);


    fprintf("experiment done")

    % once experiment is done we need to save the metadata and the fluxes
    % the fluxes are populated in table 7 # list of all tables are in the tables text file
    flux_table = tables(7);
    flux_table_data = flux_table.Data;
    % write this table data to a csv file
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