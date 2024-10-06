function index = findClosest(vector, target)
%FINDCLOSEST Finds the index of the closest value to target in vector.

    % Calculate the absolute differences between the target and each value in the vector
    differences = abs(vector - target);
    
    % Find the minimum difference and its index
    [~, index] = min(differences);
    
end

