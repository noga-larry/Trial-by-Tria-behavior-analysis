function [ H_NR,V_NR,H_R, V_R] = ...
    velocityPreviousOutcomeChoice(data,params)
% This function calculates the average speeds of trials with different
% outcomes in the previous trails, as difined in the field
% data.trials.prvious_outcome. This function runs on target choice sessions,
% in contrast to velocityPreviousOutcomeSingle. It returns the average
% velocity for different target combinaions, horizontal and vertical
% movements (rotated) only in trials in which the first target in the trial
% namr was choen (the more rewarding target). It does not include failed
% trials.
% Note: This function works on probablistic targets 
% {'0','25','50','75','100'} but can be easily modified to other cases. 
%
% Inputs:     data         A structure containig session trials, needs to
%                          contain the field data.trials.prvious_outcome
%                          (see addPreviousTrial).       
%             params       A data struture that contains different
%                          parameter for behavior analysis:
%             .time_before How much time to display before target movement
%                          (ms)
%             .time_after  How much time to display after target movement
%                          (ms)
%             .params.smoothing_margins
%                          Size of margins to prevent end effect in
%                          smoothing (ms)
%             .SD          Strandard deviation for Gaussian smoothing
%                          window 
% Outputs:    H_NR         A matrix containing the horizontal eye 
%                          velocities for trials with no reward in the
%                          previous trial. Its first dimesion is target
%                          conbination, the second is different directions
%                          (large target move horizontaly or verticaly - 
%                          after accounting for screan rotation) and the
%                          third is time. 
%             V_NR         A matrix containing the vertical eye 
%                          velocities for trials with no reward in the
%                          previous trial. 
%             H_NR         A matrix containing the horizontal eye 
%                          velocities for trials with reward in the
%                          previous trial. 
%             V_NR         A matrix containing the vertical eye 
%                          velocities for trials with reward in the
%                          previous trial. 


probabilities = {'0','25','50','75','100'};


boolNR = [data.trials.previous_outcome]==0;
boolR = [data.trials.previous_outcome]==1;

rot = data.trials(1).screen_rotation;
combNum = length(probabilities)*(length(probabilities)-1)/2;
[~,match_p] = getProbabilities (data);
[directions,match_d] = getDirections (data);
boolFailed = [data.trials.fail];
boolChoice = [data.trials.choice]==1;

H_NR = nan(combNum,length(directions),params.time_before+params.time_after+1);
V_NR = nan(combNum,length(directions),params.time_before+params.time_after+1);
H_R = nan(combNum,length(directions),params.time_before+params.time_after+1);
V_R = nan(combNum,length(directions),params.time_before+params.time_after+1);
c = 1;
for ps=1:length(probabilities)
    for pl=(ps+1):length(probabilities)
        
        for d=1:length(directions)
            
            boolProbL = strcmp(probabilities{pl},match_p(1,:));
            boolProbS = strcmp(probabilities{ps},match_p(2,:));
            boolDir = strcmp(directions{d},match_d(1,:));
            indNR = find(~boolFailed.*boolNR.*boolProbL.*boolProbS.*boolChoice.*boolDir);
            indR = find(~boolFailed.*boolR.*boolProbL.*boolProbS.*boolChoice.*boolDir);
            [pH_NR,pV_NR] = meanVelocities(data,params,indNR);
            [pH_R,pV_R] = meanVelocities(data,params,indR);
            
            [Hrotated_NR(d,:),Vrotated_NR(d,:)] = rotateEyeMovement(pH_NR, pV_NR,-rot);
            [Hrotated_R(d,:),Vrotated_R(d,:)]  = rotateEyeMovement(pH_R, pV_R,-rot);
            
        end
        H_NR(c,:,:) = Hrotated_NR;
        V_NR(c,:,:) = Vrotated_NR;
        H_R(c,:,:) = Hrotated_R;
        V_R(c,:,:) = Vrotated_R;
        c = c+1;
    end
end



end