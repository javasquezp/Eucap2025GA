function binary_matrix = seedGeneratorConstrained(x, y, r, center_x, center_y, inside_ones_percentage, outside_ones_percentage, N, max_sum_limit)
    % Initialize the binary matrix and sum tracker
    num_points = length(x);
    binary_matrix = zeros(N, num_points);  % Matrix to store the generated vectors
    total_sum = zeros(1, num_points);      % Sum tracker to ensure we don't exceed the limit

    % Calculate the distance from the center for each point
    distances = sqrt((x - center_x).^2 + (y - center_y).^2);
    
    % Logical vector: 1 if point is inside the circle, 0 if outside
    base_vector = distances <= r;
    
    % Get indices of points inside and outside the circle
    inside_indices = find(base_vector == 1);
    outside_indices = find(base_vector == 0);

    % Calculate the number of 1's based on the percentages independently
    inside_ones = round(inside_ones_percentage * length(inside_indices));
    outside_ones = round(outside_ones_percentage * length(outside_indices));

    % Loop to generate N binary vectors
    for i = 1:N
        valid_vector = false;  % Flag to indicate if the generated vector is valid
        
        while ~valid_vector
            % Initialize a temporary binary vector
            binary_vector = zeros(1, num_points);
            
            % Randomly select 'inside_ones' positions inside the circle
            if inside_ones > 0 && ~isempty(inside_indices)
                shuffled_inside_indices = inside_indices(randperm(length(inside_indices)));
                % Ensure we don't exceed the available inside indices
                selected_inside = shuffled_inside_indices(1:min(inside_ones, length(shuffled_inside_indices)));
                binary_vector(selected_inside) = 1;
            end

            % Randomly select 'outside_ones' positions outside the circle
            if outside_ones > 0 && ~isempty(outside_indices)
                shuffled_outside_indices = outside_indices(randperm(length(outside_indices)));
                % Ensure we don't exceed the available outside indices
                selected_outside = shuffled_outside_indices(1:min(outside_ones, length(shuffled_outside_indices)));
                binary_vector(selected_outside) = 1;
            end

            % Check if adding this binary vector would exceed the max sum limit
            if all(total_sum + binary_vector <= max_sum_limit)
                % If valid, accept the vector and update the total sum
                binary_matrix(i, :) = binary_vector;
                total_sum = total_sum + binary_vector;
                valid_vector = true;
            end
        end
    end
end
