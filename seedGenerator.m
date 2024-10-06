% function binary_matrix = seedGenerator(x, y, r, center_x, center_y, inside_ones_percentage, outside_ones_percentage, N)
%     % Inputs:
%     %   x: vector of x coordinates of the points
%     %   y: vector of y coordinates of the points
%     %   r: radius of the circle
%     %   center_x: x coordinate of the circle center (optional, default is 0)
%     %   center_y: y coordinate of the circle center (optional, default is 0)
%     %   inside_ones_percentage: percentage of 1's inside the circle
%     %   outside_ones_percentage: percentage of 1's outside the circle
%     %   N: number of binary vectors to generate
% 
%     % Check if center is provided, otherwise use default
%     if nargin < 4
%         center_x = 0;
%         center_y = 0;
%     end
% 
%     % Initialize the binary matrix
%     num_points = length(x);
%     binary_matrix = zeros(N, num_points);
% 
%     % Calculate the distance from the center for each point
%     distances = sqrt((x - center_x).^2 + (y - center_y).^2);
% 
%     % Logical vector: 1 if point is inside the circle, 0 if outside
%     base_vector = distances <= r;
% 
%     % Get indices of points inside and outside the circle
%     inside_indices = find(base_vector == 1);
%     outside_indices = find(base_vector == 0);
% 
%     % Calculate the number of 1's based on the percentages independently
%     inside_ones = round(inside_ones_percentage * length(inside_indices));
%     outside_ones = round(outside_ones_percentage * length(outside_indices));
% 
%     % Loop through N to generate multiple binary vectors
%     for i = 1:N
%         % Initialize a temporary binary vector
%         binary_vector = zeros(1, num_points);
% 
%         % Randomly select 'inside_ones' positions inside the circle
%         if inside_ones > 0 && ~isempty(inside_indices)
%             shuffled_inside_indices = inside_indices(randperm(length(inside_indices)));
%             selected_inside = shuffled_inside_indices(1:inside_ones);
%             binary_vector(selected_inside) = 1;
%         end
% 
%         % Randomly select 'outside_ones' positions outside the circle
%         if outside_ones > 0 && ~isempty(outside_indices)
%             shuffled_outside_indices = outside_indices(randperm(length(outside_indices)));
%             selected_outside = shuffled_outside_indices(1:outside_ones);
%             binary_vector(selected_outside) = 1;
%         end
% 
%         % Store the binary vector in the matrix
%         binary_matrix(i, :) = binary_vector;
%     end
% end

function binary_matrix = seedGenerator(x, y, r, center_x, center_y, total_ones_percentage, inside_ones_percentage, N)
    % Inputs:
    %   x: vector of x coordinates of the points
    %   y: vector of y coordinates of the points
    %   r: radius of the circle
    %   center_x: x coordinate of the circle center (optional, default is 0)
    %   center_y: y coordinate of the circle center (optional, default is 0)
    %   total_ones_percentage: percentage of total 1's to generate relative to total points
    %   inside_ones_percentage: percentage of 1's inside the circle relative to the total 1's
    %   N: number of binary vectors to generate

    % Check if center is provided, otherwise use default
    if nargin < 4
        center_x = 0;
        center_y = 0;
    end

    % Initialize the binary matrix
    num_points = length(x);
    binary_matrix = zeros(N, num_points);

    % Calculate the distance from the center for each point
    distances = sqrt((x - center_x).^2 + (y - center_y).^2);

    % Logical vector: 1 if point is inside the circle, 0 if outside
    base_vector = distances <= r;

    % Calculate the total number of 1's based on the total_ones_percentage
    total_ones = round(total_ones_percentage * num_points);

    % Calculate the number of 1's inside the circle based on inside_ones_percentage
    inside_ones = round(inside_ones_percentage * total_ones);

    % Loop through N to generate multiple binary vectors
    for i = 1:N
        % Initialize a temporary binary vector
        binary_vector = zeros(1, num_points);

        % Get indices of points inside the circle
        inside_indices = find(base_vector == 1);

        % Get indices of points outside the circle
        outside_indices = find(base_vector == 0);

        % Ensure the total number of inside_ones does not exceed available inside points
        inside_ones = min(inside_ones, length(inside_indices));

        % Ensure the total number of ones outside does not exceed available outside points
        outside_ones = total_ones - inside_ones;
        outside_ones = min(outside_ones, length(outside_indices));

        % Randomly select 'inside_ones' positions inside the circle
        if inside_ones > 0 && ~isempty(inside_indices)
            shuffled_inside_indices = inside_indices(randperm(length(inside_indices)));
            selected_inside = shuffled_inside_indices(1:inside_ones);
            binary_vector(selected_inside) = 1;
        end

        % Randomly select 'outside_ones' positions outside the circle
        if outside_ones > 0 && ~isempty(outside_indices)
            shuffled_outside_indices = outside_indices(randperm(length(outside_indices)));
            selected_outside = shuffled_outside_indices(1:outside_ones);
            binary_vector(selected_outside) = 1;
        end

        % Store the binary vector in the matrix
        binary_matrix(i, :) = binary_vector;
    end
end
