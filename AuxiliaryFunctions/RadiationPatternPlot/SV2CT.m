function [Pt]=SV2CT(Sv,hs)
% Funcion que trasforma angulos de vision del satelite en coordenadas cartesianas en tierra.
% Se supone el satelite en (0,0) a una altura hs. Sv(1,:) se tomara 1000 en el programa
% Uso: [Pt]=SV2CT(Sv,hs)

        Rt=6378.2;      % Radio de la Tierra en Km
        rad=pi/180;     % Conversion de grados a radianes

        % En primer lugar se transforman los angulos de vision en cartesianas del satelite
        
        Sv(1,:)=1.000;
        Ps=SV2CS(Sv);
        
        % Ahora las cartesianas del satelite se trasforman en cartesianas en tierra
        
        Pe=CS2CT(Ps,hs);
        
        % Se determina ahora el punto de interseccion sobre tierra de la linea de vision desde el satelite
        
        A=(Pe(1,:)-(Rt+hs)).^2+Pe(2,:).^2+Pe(3,:).^2;
        B=2*Pe(1,:)*(Rt+hs)-2*(Rt+hs)^2;
        C=(Rt+hs)^2-Rt^2;
        K1=(-B+sqrt(B.^2-4*A.*C))./(2*A);
        K2=(-B-sqrt(B.^2-4*A.*C))./(2*A);
        N=size(Sv',1);
        
        % ¿Que hacer cuando no hay interseccion, K es complejo?
        for i=1:N
            if K1(i)<K2(i)
                K(i)=K1(i);
            else
                K(i)=K2(i);
            end
        end
        Pt=Pe;
        Pt(1,:)=(Rt+hs)+ K.*(Pe(1,:)-(Rt+hs));
        Pt(2,:)=K.*Pe(2,:);
        Pt(3,:)=K.*Pe(3,:);
