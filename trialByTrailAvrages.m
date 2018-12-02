%% averages 
probabilities = {'0' '25' '50' '75' '100'};
previousOutcome = {'NR','R'};

params.time_before = 0;
params.time_after = 400;
params.smoothing_margins = 100;
params.SD = 5;

data_dir = 'C:\noga\Albert behavior\Data\4DirectionsProbablisticRewardEccentricQue\';
files = dir (data_dir); files = files (3:end);


Velocity_NR = nan(length(probabilities),params.time_before+params.time_after+1,length(files));
Velocity_R = nan(length(probabilities),params.time_before+params.time_after+1,length(files));
for ii=1:length(files)
    
     data = importdata ([data_dir files(ii).name]);
     [Velocity_NR(:,:,ii),Velocity_R(:,:,ii)] = velocityPreviousOutcome(data,params);
     
end

aveVelocity_NR = nanmean(Velocity_NR,3);
aveVelocity_R = nanmean(Velocity_R,3);

ts = -params.time_before:params.time_after;
for p=1:length(probabilities)
    figure; 
    plot (aveVelocity_NR(p,:)); hold on
    plot (aveVelocity_R(p,:))
    legend ('NR', 'R')
    title (['P = ' probabilities{p}])
end

%% 
