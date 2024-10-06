function [BW ValueBW] = beamwidthCalculation(theta,Directivity,points)

% Author Juan Andres Vasquez Peralvo
% Date = 7/14/2022
%BW = Beamwidth
% ValueBW = actual value in the radiation pattern
% theta = angles for evaluation
% directivity = values for evaluaiton
% points = -x dB where to evaluate

%This code allows to calculate the BW of any radiation pattern given the
%angles, radiation pattern and the value where we want to evauluate the
%beamwidth.
%Avoid repeated values
Directivity = Directivity+rand(numel(Directivity),1)*max(Directivity)/1e4;
%Avoid inf numbers
Directivity(isinf(Directivity)) = -500 ;

 if((sum(abs(Directivity))<1e-6))
                BW(1) = Inf;
 else
%%% Test if there is an infinite value%%%
%Directivity(isinf(Directivity)) = Directivity(circshift(isinf(Directivity),1))-0.00003;
    [MaxDirectivity positionMax]  = max(Directivity);
%    [position] = find(Directivity(positionMax:end)<MaxDirectivity);
    ValueBW = MaxDirectivity+points;
    if Directivity(positionMax) == Directivity(positionMax-1);
        %BW = interp1(Directivity(positionMax+1:end),theta(positionMax+1:end),ValueBW)*2;
         for i = 1 : size(Directivity,2)
             aux = interp1(Directivity(positionMax+1:end,i),theta(positionMax+1:end),ValueBW)*2;
             BW(i) = aux;
        end
    else 
        for i = 1 : size(Directivity,2)
            if isinf(Directivity(:,i))
                BW(i) = Inf;
           
            else
             %Directivity = unique(Directivity);
            % theta = linspace(theta(1), theta(end), numel(Directivity));
            if (numel(Directivity(positionMax:end,i)) >1)
             aux1 = interp1(Directivity(positionMax:end,i),theta(positionMax:end),ValueBW(i));
             aux1 = abs(aux1 -theta(positionMax));
            end
            if (numel(Directivity(1:positionMax,i)) >1)
             aux2 = interp1(Directivity(1:positionMax,i),theta(1: positionMax),ValueBW(i));
             aux2 = abs(aux2 -theta(positionMax));
            end
            if ((numel(Directivity(positionMax:end,i)) >1) & numel(Directivity(1:positionMax,i))>1)
             BW(i) = aux1(1)+aux2(1);
            else
                BW(i) = 100;
            end
            end
        end
    end
 end
end

