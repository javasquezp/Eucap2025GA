function P=atan4(Y,X)
% Calcula el arco tangente de Y./X dando el resultado
% en el margen [0, 2pi]
P=atan2(Y,X);
for i=1:size(P)
    if P(i)<0.0
        P(i)=P(i)+2*pi;
    end
end

        