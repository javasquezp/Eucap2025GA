 function [Pps]=CSrotCS(Ps,Theta,Phi)
  % Uso:     [Pps]=CSrotCS(Ps,Theta,Phi)  
 % Funcion que gira los puntos del vector Ps en el sistema cartesiano satelite de manera que el punto
 % subsatelite pasa a estar en (Theta,Phi). Pt debe tener dimensiones (3,N).
 
        rad=pi/180;     % Conversion de grados a radianes
        % Primero un giro entorno al eje x  de valor Phi
        B=[1, 0, 0; 0, cos(Phi*rad), -sin(Phi*rad); 0, sin(Phi*rad),cos(Phi*rad)];
        % Despues un giro Theta respecto al nuevo eje y
        C=[cos(Theta*rad), 0, sin(Theta*rad) ; 0, 1, 0;-sin(Theta*rad), 0 , cos(Theta*rad)];
        %C=[cos(Theta*rad), sin(Theta*rad), 0 ; -sin(Theta*rad), cos(Theta*rad), 0; 0, 0, 1];
        A=C*B;
        Pps=A*Ps;
 end
 
