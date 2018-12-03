%% averages - single target
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
     [Velocity_NR(:,:,ii),Velocity_R(:,:,ii)] = velocityPreviousOutcomeSingle(data,params);
     
end

aveVelocity_NR = nanmean(Velocity_NR,3);
aveVelocity_R = nanmean(Velocity_R,3);

ts = -params.time_before:params.time_after;
for p=1:length(probabilities)
    figure; 
    plot (ts,aveVelocity_NR(p,:)); hold on
    plot (ts,aveVelocity_R(p,:))
    legend ('NR', 'R')
    title (['P = ' probabilities{p}])
end

%% averages - choice

params.time_before = 200;
params.time_after = 300;
params.smoothing_margins = 100;
params.SD = 5;

probabilities = {'0','25','50','75','100'};
combNum = length(probabilities)*(length(probabilities)-1)/2;

data_dir = 'C:\noga\Albert behavior\Data\ProbablisticChoice\';
files = dir (data_dir); files = files (3:end);


HVelocity_NR = nan(combNum,2,params.time_before+params.time_after+1,length(files));
VVelocity_NR = nan(combNum,2,params.time_before+params.time_after+1,length(files));
HVelocity_R = nan(combNum,2,params.time_before+params.time_after+1,length(files));
VVelocity_R = nan(combNum,2,params.time_before+params.time_after+1,length(files));

for ii=1:length(files)
    
     data = importdata ([data_dir files(ii).name]);
     [HVelocity_NR(:,:,:,ii),VVelocity_NR(:,:,:,ii),HVelocity_R(:,:,:,ii), VVelocity_R(:,:,:,ii)]...
         = velocityPreviousOutcomeChoice(data,params);
     
end

aveHVelocity_NR = nanmean(HVelocity_NR,4);
aveVVelocity_NR = nanmean(VVelocity_NR,4);
aveHVelocity_R = nanmean(HVelocity_R,4);
aveVVelocity_R = nanmean(VVelocity_R,4);

% remove baselinec = 1;

ts = params.time_before+(1:params.time_after);
aveHVelocity_NR = aveHVelocity_NR(:,:,ts) - nanmean(nanmean(aveHVelocity_NR(:,1:params.time_before)));
aveVVelocity_NR = aveVVelocity_NR(:,:,ts) - nanmean(nanmean(aveVVelocity_NR(:,1:params.time_before)));
aveHVelocity_R = aveHVelocity_R(:,:,ts) - nanmean(nanmean(aveHVelocity_R(:,1:params.time_before)));
aveVVelocity_R = aveVVelocity_R(:,:,ts) - nanmean(nanmean(aveVVelocity_R(:,1:params.time_before)));

c=1;
for ps=1:length(probabilities)
    for pl=(ps+1):length(probabilities)
figure;
    
plot(squeeze(aveHVelocity_R(c,:,:))',squeeze(aveVVelocity_R(c,:,:))'); hold on
plot(squeeze(aveHVelocity_NR(c,:,:))',squeeze(aveVVelocity_NR(c,:,:))')
title ([probabilities{pl} ' vs ' probabilities{ps} ])
c = c+1;

legend ('R','R','NR','NR')
    end
end
