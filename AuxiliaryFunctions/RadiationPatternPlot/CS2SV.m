function [Sv]=CS2SV(Ps)
% Funcion que transforma coordenadas cartesianas en el satelite en angulos de vision

        rad=pi/180;     % Conversion de grados a radianes
        Sv(1,:)=sqrt(Ps(1,:).^2+Ps(2,:).^2+Ps(3,:).^2);
        Sv(2,:)=acos(-Ps(1,:)./Sv(1,:))/rad;
        Sv(3,:)=atan4(Ps(3,:),Ps(2,:))/rad;
        Sv(1,:)=1;
end

         
        
        
