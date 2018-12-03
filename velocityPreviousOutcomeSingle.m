function [aveVelocity_NR,aveVelocity_R] = velocityPreviousOutcomeSingle(data,params)

% This function calculates the average speeds of trials with different
% outcomes in the previous trails, as difined in the field
% data.trials.prvious_outcome. This function runs on  single target sessions,
% in contrast to velocityPreviousOutcomeChoice. It returns the average
% velocity for different targets averafed over directions
% It does not include failed trials. The function returns only the
% conponents of eye velocity in the direcion of trahet movement (it assumes
% the orthogonal direction is noise).
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
% Outputs:    aveVelocity_NR
%                          A matrix containing the eye velocities for
%                          trials with no reward in the previous trial. 
%                          Its first dimesion is target, the second is 
%                          time.
%             aveVelocity_R 
%                          A matrix containing the eye velocities for
%                          trials with reward in the previous trial

boolNR = [data.trials.previous_outcome]==0;
boolR = [data.trials.previous_outcome]==1;

rot = data.trials(1).screen_rotation;
probabilities = {'0', '25', '50', '75' '100'};
[~,match_p] = getProbabilities (data);
[directions,match_d] = getDirections (data);
boolFailed = [data.trials.fail];

aveVelocity_NR = nan(length(probabilities),params.time_before+params.time_after+1);
aveVelocity_R = nan(length(probabilities),params.time_before+params.time_after+1);

for p=1:length(probabilities)
    rotated_NR = nan(length(directions),params.time_before+params.time_after+1);
    rotated_R = nan(length(directions),params.time_before+params.time_after+1);

    for d=1:length(directions)
    
        boolProb = strcmp(probabilities{p},match_p);
        boolDir = strcmp(directions{d},match_d);
        indNR = find(~boolFailed.*boolNR.*boolProb.*boolDir);
        indR = find(~boolFailed.*boolR.*boolProb.*boolDir);
        [H_NR,V_NR] = meanVelocities(data,params,indNR);
        [H_R,V_R] = meanVelocities(data,params,indR);
        
        rotated_NR(d,:) = rotateEyeMovement(H_NR, V_NR,-rot-str2double(directions{d}));
        rotated_R(d,:) = rotateEyeMovement(H_R, V_R,-rot-str2double(directions{d}));
                
    end
    
    aveVelocity_NR(p,:) = mean(rotated_NR,1);
    aveVelocity_R(p,:) = mean(rotated_R,1);
    

end

end