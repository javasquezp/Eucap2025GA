%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Written by Juan A. Vasquez-Peralvo
%Luxembourg-Luxembourg
%5/12/2023
%Modified 5/12/2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sllAz, sllEl] = sllExtraction(azCut, elCut)

pksAz = arrayfun(@(k)findpeaks(azCut(:,k),'NPeaks',2,'SortStr','descend'),...
    1:size(azCut,2),'UniformOutput',false);
%Avoiding Errors
        for i = 1 : size(pksAz,2)
            if size(pksAz{i},1) ~=2
                pksAz{i} = [0 0];
            end
        end
pksEl = arrayfun(@(k)findpeaks(elCut(:,k),'NPeaks',2,'SortStr','descend'),...
    1:size(elCut,2),'UniformOutput',false);
%Avoid Errors
        for i = 1 : size(pksEl,2)
            if size(pksEl{i},1) ~=2
                pksEl{i} = [ 0 0];
            end
        end
sllAz = cellfun(@(x)x(1)-x(2),pksAz);
sllEl = cellfun(@(x)x(1)-x(2),pksEl);

end