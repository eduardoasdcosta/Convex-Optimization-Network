function [R, c] = generateParams(nLinks, nFlows, minC, maxC)

    midC = (maxC-minC)/2; %average of maximum and minimum capacity

    c = (minC + midC) + midC * (2*rand(nLinks, 1) - 1); %generates a vector of random capacities between the given thresolds of minC and maxC
    R = randi([0 1], nLinks, nFlows); %generates a random binary routing matrix
   
    %guarantees that every flow passes by at least 1 link, otherwise the problem is not optimizable
    for i = 1:nFlows
        if max(R(:,i)) == 0
            R(ceil(nLinks * rand()), i) = 1;
        end
    end

    save('networkParams.mat', 'nLinks', 'nFlows', 'R', 'c');
end