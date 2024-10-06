function [Pt]=LoLa2CT(Pg)
% Funcion que trasforma coordenadas geograficas en cartesianas
%      Pt y Pg tienen dimensiones (3,N)
%      El valor del radio en Pg(1,:) puede ser cualquiera. Se usa Rt=6378.2
% Uso:  [Pt]=LoLa2CT(Pg)

        Rt=6378.2;      % Radio de la Tierra en Km
        rad=pi/180;     % Conversion de grados a radianes
        %Pt=Pg;          % Simplemente inicializo las dimensiones de la matriz
        Pt(1,:)=Rt*cos(Pg(3,:)*rad).*cos(Pg(2,:)*rad);
        Pt(2,:)=Rt*cos(Pg(3,:)*rad).*sin(Pg(2,:)*rad);
        Pt(3,:)=Rt*sin(Pg(3,:)*rad);
        

