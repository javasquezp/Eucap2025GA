function [Ps]=CT2CS(Pt,hs)
% Funcion que trasforma coordenadas cartesianas en la tierra a coordenadas cartesianas en
% el satelite. hs es la altura de la orbita del satelite supuesto en 0,0

        Rt=6378.2;      % Radio de la Tierra en Km
        Ps(1,:)=Pt(1,:)-(Rt+hs);
        Ps(2,:)=Pt(2,:);
        Ps(3,:)=Pt(3,:);
end

