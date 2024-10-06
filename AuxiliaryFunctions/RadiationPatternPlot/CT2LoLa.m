 function  [Pg]=CT2LoLa(Pt)      
 % Funcion que transforma coordenadas cartesianas (x,y,z) en geograficas (Rt,Lo,La) sobre la Tierra.
 %      Pt y Pg tienen dimensiones (3,N)
 
        Rt=6378.2;      % Radio de la Tierra en Km
        rad=pi/180;     % Conversion de grados a radianes
        Pg(1,:)=sqrt(Pt(1,:).^2+Pt(2,:).^2+Pt(3,:).^2);
        Pg(2,:)=atan2(Pt(2,:),Pt(1,:))/rad;
        Pg(3,:)=atan2(Pt(3,:),sqrt(Pt(1,:).^2+Pt(2,:).^2))/rad;
 end
 
