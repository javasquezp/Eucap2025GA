function [Pt]=CS2CT(Ps,hs)
% Funcion que trasforma coordenadas cartesianas en el satelite a coordenadas cartesianas en
% la tierra. hs es la altura de la orbita del satelite supuesto en 0,0

        Rt=6378.2;      % Radio de la Tierra en Km
        Pt(1,:)=Ps(1,:)+(Rt+hs);
        Pt(2,:)=Ps(2,:);
        Pt(3,:)=Ps(3,:);
end

