function [ InterX] = Inter_beams(frq,LatMin,LatMax,LonMin,LonMax,DmA,NColor,Pout_dB)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[LatNA, LonNA,Ef_Area,GainX,Ang_3dB,Nb_r] = Gain(frq,LatMin,LatMax,LonMin,LonMax,DmA);
B=size(LatNA(:,1));
C=size(LonNA(1,:));

P=(10^(Pout_dB/10))*0.01;
N1=(Nb_r)/(NColor*Pout_dB);
Inter=10*log10(P)+10*log10(N1)+GainX;
[InterX] = EfficA(Ef_Area,Inter);

for i=1:1:B(1)
    for j=1:1:C(2)
        if InterX(i,j)==0
            InterX(i,j)=NaN;
        end
    end
    
end

end

