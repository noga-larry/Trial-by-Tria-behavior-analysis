
%% Get cell information from excel sheet

excel_file_adress = ['C:\noga\Albert behavior' '\' 'task_database_monkey '];
dir_to = ['C:\noga\Albert behavior' '\' 'session_info'];
get_excel_info( excel_file_adress, dir_to )

%% Get and organize data - single

focus_task = '4DirectionsProbablisticRewardEccentricQue';
% folder where the raw trials are stored 
dir_data_from = 'C:\noga\Albert behavior\Maestro Data';
% folder in which to store organized data
dir_data_to = 'C:\noga\Albert behavior\Data';
get_data(dir_data_from, dir_data_to, 'albert',focus_task  )


%% find previous trial outcome (same type)

data_dir = 'C:\noga\Albert behavior\Data\4DirectionsProbablisticRewardEccentricQue\';
files = dir (data_dir); files = files (3:end);

for ii=1:length(files)
    data = importdata ([data_dir files(ii).name]);
    data = addPreviousTrial (data);
    save ([data_dir files(ii).name], 'data')
    ii
end

%% Get and organize data - choice

focus_task = 'ProbablisticChoice';
% folder where the raw trials are stored 
dir_data_from = 'C:\noga\Albert behavior\Maestro Data';
% folder in which to store organized data
dir_data_to = 'C:\noga\Albert behavior\Data';
get_data(dir_data_from, dir_data_to, 'albert',focus_task  )

%% find previous trial outcome (same type)

data_dir = 'C:\noga\Albert behavior\Data\ProbablisticChoice\';
files = dir (data_dir); files = files (3:end);

for ii=1:length(files)
    data = importdata ([data_dir files(ii).name]);
    data = addPreviousTrial (data);
    save ([data_dir files(ii).name], 'data')
    ii
end
