function [gainsCSI] = gainUserEval(  gain, azUser, elUser, az, el )
% FUNCTIONNAME - This code allows  to compute the corresponding gain value
% of a user located in a (u,v) point. The gain of this user is computed ofr
% each of the generated beams and saved in a matrix that has dimensions [nUsers, nBeams]
    %
    % Syntax: [gainsCSI] = gainUserEval(  gain, UDisplaced, VDisplaced, theta, phi )
    % Inputs:
    %   input - 
    %           gain : gain multidimensional matrix that correspnds to each u, v point 
                       % for each beams the dimensions are [nupoints, nvpoints, nbeams]
    %           UDisplaced : vector of the u position of the user
    %           pattern :  matrix (evaluation points, evaluation points, #beams)
    %           beams : total beams
    %           xLabel : Label for the x Axis
    %           yLabel : Label for the y Axis
    %           title : title of the figure
    %           ploteron : on or off the figures
    %           Ucenter  : user Positions in U at the center of the beam
    %           Vcenter  : user Positions in V at the center of the beam
    %           bw        : beamwidth of the beam
    %          

    %   output - gainCSI: Gain of the users in the desired direction.
    %            thetadisplaced : Location in theta coordinate of the user.
    %
    % Example:
    % [gainsCSI, thetaDisplaced] = gainUserEval(  gain, UDisplaced, VDisplaced, theta, phi )
    %
    % Author: Juan Andrés Vásquez Peralvo
    % Date: Febreuary 4, 2024
    % Version: 1.0
    % This code is based on the paper A Pragmatic Approach to Massive MIMO 
    % for Broadband Communication Satellites
    % Function code goes here
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% Start of the Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Define Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nBeams = size(gain, 3);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% Computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    for m = 1 : length(azUser)
        azUserApproxIndex = findClosest(az, azUser(m));
        elUserApproxIndex = findClosest(el, elUser(m));
        %This line assigns to CSI the corresponing value of the user location
        gainsCSI(m,:)=  (reshape( gain(elUserApproxIndex ,...
            azUserApproxIndex ,  :    )  , 1, nBeams));
    end
        

    end
