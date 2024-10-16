% clc, clearvars;
% finding all the tables
import java.awt.Robot;
import java.awt.event.KeyEvent;
robot = Robot;

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
num_tabs = 3;
tab_stroke(num_tabs, robot )
space_stroke(robot)
pause(0.5)

for exp = 1: 16%size(exp_table_data, 1)

    % have to resort to manual click, as Its nearly impossible to figure out the input of the celleditcallback of the table

    num_tabs = 4*exp;                                                                                                                            ;
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


    % once the exp box is checked, we need to run the experiment
    for iters = 1:num_flux_estimate_clicks

        % estimated fluxes button is 17th button . #all the buttons are listed in UI controls text file
        estimated_fluxes_button = buttons(17);
        callbackFunction = estimated_fluxes_button.Callback;
        callbackFunction(estimated_fluxes_button, []);
        pause(3);


        update_model_button = buttons(16);
        callbackFunction2 = update_model_button.Callback;
        callbackFunction2(update_model_button, []);

        pause(2);
    end
    
    % fprintf("Before unclicking\n")
    % fprintf("================\n")
    % pause(10);

    % have to resort to manual click, as Its nearly impossible to figure out the input of the celleditcallback of the table
    % unchekcing
    tab_stroke(num_tabs, robot )                            
    space_stroke(robot)

    tab_stroke(4, robot )                            
    space_stroke(robot)

    % once experiment is done we need to save the metadata and the fluxes
    % the fluxes are populated in table 7 # list of all tables are in the tables text file
    flux_table = tables(7);
    flux_table_data = flux_table.Data;
    % write this table data to a csv file
    writecell(flux_table_data, strcat('output/exp_num_', num2str(exp), '_exp_id_',(exp_name_from_table), '_fluxes.csv'));

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
    fprintf("=================\n")
    pause(5);                                                                       
end

function tab_stroke(n, robot)
    import java.awt.event.KeyEvent;
    for i=1:n
        robot.keyPress(KeyEvent.VK_TAB);
        robot.keyRelease(KeyEvent.VK_TAB);
    end
    pause(2)

end

function space_stroke(robot)
    import java.awt.event.KeyEvent;
    robot.keyPress(KeyEvent.VK_SPACE);
    robot.delay(100);
    robot.keyRelease(KeyEvent.VK_SPACE);
    robot.delay(100);
    pause(2)
end