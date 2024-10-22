eventdata = struct('Indices', [1, 4], 'NewData', true, 'PreviousData', false, 'Error', []);
exp_table.CellEditCallback(exp_table, eventdata);


figs = findall(groot, 'Type', 'Figure');
tables = findall(figs, 'Type', 'uitable');
buttons = findall(figs, 'Type', 'UIControl');
% (Estimate Fluxes) , 

% the tables and their field names are 
% table 25 is the edit experiment tables

exp_table = tables(25);

% Create a mock CellEditData object (event)
event = struct;
event.Indices = [1, 4];
event.PreviousData = exp_table.Data(1, 4);  % assuming some previous data
event.EditData = true;  % new data entered by the user
event.NewData = true;  % the new data MATLAB tries to save
event.Error = 'sad';  % assuming no error

% Call the callback function manually
rungui.editExpts(exp_table, event);

