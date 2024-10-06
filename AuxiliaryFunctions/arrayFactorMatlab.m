%%%%This code allows to calculate the AF using matrix product%%%%%%%
%Author: Juan Andres Vasquez Peralvo
%Date: 5/23/2023
%Version: V1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Input%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%position of the antennas: pos
%angle range: angspanAz. angspanEl 
%weigth matrix: w
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Array factor aF
%Array factor complex form: aF

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

%%%%%%%%%%%%%%%%%%%%%%%%%
%To have an idea of what this code does, it uses the steervec function to
%generate the values of the array in each pointing angle and the just sum
%it as in the array factor formula. 
%In addition, this code uses only matrices and not loops, eventhough the
%time is the same. this is part of the code that uses loops
% aFC = zeros(length(angspanAz), length(angspanAz));
%         for i = 1 : length(angspanAz) 
%             
%             aFC(i,:) = sum(steervec(pos, [angspanAz;angspanEl(i) ...
%                 *ones(1,numel(angspanAz))]).* permute(wc,[1 3 2]),1);

% [azM, elM] = meshgrid(angspanAz, angspanEl);
% 
%      aFC = sum(steervec(pos, [azM(:)';elM(:)']).* permute(wc,[1 3 2]),1);
% %         end
%      aFC = reshape(transpose(aFC), [numel(angspanAz), numel(angspanEl)]);  