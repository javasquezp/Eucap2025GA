function [lB] = linkBudget(gReceiver, frequency, hS, tR, rS, azUser, elUser)
% FUNCTIONNAME - This code allows to compute the normalized link budget in
    % a satellite communication system
    %
    % Syntax: [AF, theta, phi, U, V] = radiationPatternCalculation(nAntennas, ...
    % thetaMax, w, granularity, p, efficiency, ploteron)
    %
    % Inputs:
    %   input - gReceiver : Gain of the receiver
    %           frequency : Operational frequency
    %           hS        : satellite altitude.
    %           tR        : Receiver temperature
    %           rS        : Symbol rate
    %           theta     : theta angle where the user is located

    %   output - theta coordinates
    %
    % Example:
    %   [lB] = linkBudget(100, 19e9, 8000000, 100, 1e9, 19)
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
    kB = 1.380649e-23; % Boltzmann constant in J/K
    rE = 6371e3; % Average radius in kilometers
    T = 298; % Temperature in Kelvin
    cSpeed = 3e8; %Speed of Ligth m/s
    lambda = cSpeed./frequency; % wavelength
    phitheta = azel2phitheta([azUser; elUser]);
    theta = phitheta(2);
    theta = theta   *   pi/180;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% Computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nR  =   kB  *   tR  *   rS; % Noise receiver
    %Angle from the horizont
    alpha = acos( sin(theta)    *   ( rE    +   hS  )   ./  rE   ); 
    r = ((rE    +   hS   ).^2   +   rE.^2   -   2   *   rE  *   ...
        (   rE +    hS )    *   sin(alpha)  +   asin(   rE  ./  (   rE  +   hS) ) ...
        .*cos(alpha)).^0.5; % slant range
    PhaseUE = exp(-1i*2*pi*r/lambda);
    lFreeSpace = (  (  4*pi.*  r    )./     (lambda)  ).^2; % Free Space Loss
    lB = gReceiver  *   PhaseUE  ./    (   lFreeSpace *   nR); %Link budget
end  