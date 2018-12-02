function [aveVelocity_NR,aveVelocity_R] = velocityPreviousOutcome(data,params)


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