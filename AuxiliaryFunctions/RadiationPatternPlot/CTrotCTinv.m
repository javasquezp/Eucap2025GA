 function [Ppt]=CTrotCTinv(Pt,Lo,La)
 % Funcion que gira los puntos del vector Pt en el sistema cartesiano terrestre de manera que el punto
 % de coordenadas Lo,La pasa a estar en (0,0). Pt debe tener dimensiones (3,N).
 % Uso:     [Ppt]=CTrotCT(Pt,Lo,La)  
 
        rad=pi/180;     % Conversion de grados a radianes
        B=[cos(Lo*rad), sin(Lo*rad), 0 ; -sin(Lo*rad),cos(Lo*rad),0 ; 0, 0, 1];
        C=[cos(La*rad), 0, sin(La*rad) ; 0, 1, 0; -sin(La*rad), 0, cos(La*rad)];
        A=C*B;
        Ppt=A'*Pt;
%         Rt=6378.2;
% %        A=Rt*cos(Lo1*rad)*cos(La1*rad)-Rt*(Lo*rad)*cos(La*rad);
% %        B=Rt*cos(Lo1*rad)*sin(La1*rad)-Rt*(Lo*rad)*sin(La*rad);
% %        C=Rt*sin(Lo1*rad)-Rt*sin(Lo*rad);
% %        Ppt(1,:)=A*cos(Lo*rad)+B*sin(Lo*rad);
% %        Ppt(2,:)=-A*sin(Lo*rad)+B*cos(Lo*rad);
% %        Ppt(3,:)=C;

% [A1]=LoLa2CT([Rt Lo La]');
%        
%        Ppt=Pt-A1;
 end
        
        
