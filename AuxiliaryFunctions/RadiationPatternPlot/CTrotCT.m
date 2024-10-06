 function [Ppt]=CTrotCT(Pt,Lo,La)
 % Funcion que gira los puntos del vector Pt en el sistema cartesiano terrestre de manera que el punto
 % de coordenadas Lo,La pasa a estar en (0,0). Pt debe tener dimensiones (3,N).
 % Uso:     [Ppt]=CTrotCT(Pt,Lo,La)  
 
        rad=pi/180;     % Conversion de grados a radianes
        B=[cos(Lo*rad), sin(Lo*rad), 0 ; -sin(Lo*rad),cos(Lo*rad),0 ; 0, 0, 1];
        C=[cos(La*rad), 0, sin(La*rad) ; 0, 1, 0; -sin(La*rad), 0, cos(La*rad)];
        A=C*B;
        Ppt=A*Pt;
 end
        
        
