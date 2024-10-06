% SCRIPTNAME - 
        %
        %%%%%%%%%%%
        %Author: Juan Andres Vasquez Peralvo
        %Date: 5/23/2023
        %Version: 2.0
        % This code allows to calculate the AF using matrix product
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % Descriptions
        %To have an idea of what this code does, it uses the steervec
        %function to generate the values of the array in each pointing
        %angle and the just sum it as in the array factor formula. In
        %addition, this code uses only matrices and not loops, eventhough
        %the time is the same.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Input%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%position of the antennas: pos in meters
%angle range: angspanAz. angspanEl 
%weigth matrix: w in vector form
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Array factor aF
%Array factor complex form: aF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Example%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%positions = [a;b;c] a z positions, b: y positions c: x positions
%[AF] = arrayFactorMatlab(positions, ones(1, length(positions))', -90:0.5:90);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Add Required Paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------------------------------------
%                            Main function Logic
% ------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Initiate constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%% Code Here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [aF, aFC] = arrayFactorMatlab(pos, wc, angspanAz, angspanEl)

if nargin <4
    angspanEl = angspanAz;
end

    if length(angspanAz)== 1 || length(angspanEl) == 1
    %%  This case is for cuts
     if numel(angspanEl) == 1
        aFC = sum(steervec(pos, [angspanAz;angspanEl ...
                *ones(1,numel(angspanAz))]).* permute(wc,[1 3 2]),1);
     else
        aFC = sum(steervec(pos, [angspanAz*ones(1, numel(angspanEl));angspanEl ...
                ]).* permute(wc,[1 3 2]),1);
     end

     aF = mag2db(abs(aFC)); 
    else
        %%This case is for 3D patterns
     aFC = zeros(length(angspanAz), length(angspanAz));
        for i = 1 : length(angspanAz) 
            
            aFC(i,:) = sum(steervec(pos, [angspanAz;angspanEl(i) ...
                *ones(1,numel(angspanAz))]).* permute(wc,[1 3 2]),1);
        end
      aF = mag2db(abs(aFC)); 
      aF(aF<-50) = 0; %% Here we add 0.1 to eliminate really low values
    
    end
end

