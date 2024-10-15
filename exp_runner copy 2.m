
figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');

exp_table = tables(25);
exp_table_data = exp_table.Data;

% for sanity reason, unchecking all the exps, just to make sure or if the user interupts the UI
for i = 1:size(exp_table_data, 1)
    exp_table_data{i, 4} = false;
end
% updating the table data
exp_table_data{7, 4} = true;  % 4th column is the active checkbox column
exp_table.Data = exp_table_data;
pause(1);
table_edit_callback =exp_table.CellEditCallback;
table_edit_callback(exp_table, []);
drawnow;
pause(2);

exp_table.Enable = 'off';
drawnow;
exp_table.Enable = 'on';
drawnow;



fprintf("checking the table before begining the experiment\n")
exp_table = tables(25);
exp_table_data = exp_table.Data;
disp(exp_table_data)
pause(5);


figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');

% estimated fluxes button is 17th button . #all the buttons are listed in UI controls text file
fprintf("clicking estimated fluxes button\n");
estimated_fluxes_button = buttons(17);
eventData = struct('Source', estimated_fluxes_button, 'EventName', 'Action');
estimated_fluxes_button.Callback(estimated_fluxes_button, eventData);
fprintf("Estimated fluxes button clicked\n");
pause(5); % Wait for processing (adjust based on your application's needs)
drawnow;
pause(2);


figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');
% clicking on updating the data #update model data button is 16th button # all the buttons are listed in UI controls text file
fprintf("calling update button\n");
update_model_button = buttons(16);
updateEventData = struct('Source', update_model_button, 'EventName', 'Action');
update_model_button.Callback(update_model_button, updateEventData);
fprintf("update button clicked")
pause(10);
drawnow;

exp_table = tables(25);
exp_table_data = exp_table.Data;
disp(exp_table_data)

