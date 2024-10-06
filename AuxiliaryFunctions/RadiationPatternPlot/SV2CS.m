function [Ps]=SV2CS(Sv)
% Funcion que trasforma angulos de vision del satelite en cartesianas
% El valor de Sv(1,:) puede ser cualquiera. Se tomara como 1 en los calculos

        rad=pi/180;
        Ps(1,:)=-1*cos(Sv(2,:)*rad);
        Ps(2,:)=1*sin(Sv(2,:)*rad).*cos(Sv(3,:)*rad);
        Ps(3,:)=1*sin(Sv(2,:)*rad).*sin(Sv(3,:)*rad);
        
