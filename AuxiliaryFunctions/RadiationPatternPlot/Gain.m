function [LatNA, LonNA,Ef_Area,GX,Ang_3dB,Nb_r] = Gain(frq,LatMin,LatMax,LonMin,LonMax,DmA)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
[Latitud,Longitud,AreaR] = read_data( );
[LatNA,LonNA,Ef_Area] = region( LatMin,LatMax,LonMin,LonMax,Latitud,Longitud,AreaR);
land=(3*10^8)/(frq*10^9);
Ang_3dB=(70*land)/DmA;
A_A=pi*((DmA/2)^2);
Fa_G=10*log10(0.5*((4*pi*A_A)/(land^2)));
beta=Ang_3dB/2;
re=6631;
El=acosd((42242/re)*sind(beta));
gamma= (80/90)*(90-El);
r=gamma*10;
B=size(LatNA(:,1));
C=size(LonNA(1,:));

r2=r^2;
FacLat=round(r*cosd(45));
FacLon=round(r*cosd(45));
FacLat1=FacLat;
FacLon1=FacLon;
v1=FacLat;
con=1;
con2=0;
for i=1:1:B(1)
    v2=FacLon;
    if mod(con,2)==0
        L1=round(v1/2);
    else
        L1=0;
    end
    for j=1:1:C(2)
        v3=((v1-i)^2)+((v2-L1-j)^2);
        if v3<=r2
            if v3==0
                con2=con2+1;
                lat(con2)=i;%% posiciones del centro de haz
                lon(con2)=j;
            end
            Dia(i,j)=1-((0.7*v3)/r2);
        else
            Dia(i,j)=0.7;
            if i< (v1+FacLat1)
            v2=v2+2*FacLat1;
            else
                v1=v1+2*FacLon1;
                con=con+1;
            end
            
        end
         GainX(i,j)= Fa_G + (10*log10(Dia(i,j)));
      end
    
end
[GX] = EfficA(Ef_Area,GainX);
Nb_r=0;
for i=1:1:con2
    L22=lat(i);
    L23=lon(i);
    if GX(L22,L23)~=0
        Nb_r=Nb_r+1;
    else
        
     if (L22+round(FacLat/4))<=size(GX) 
         if (round(FacLat/4)+L23)<=size(GX')
                    if GX(L22+round(FacLat/4),L23)~=0 || GX(L22-round(FacLat/4),L23)~=0 || GX(L22,round(FacLat/4)+L23)~=0 || GX(L22,-round(FacLat/4)+L23)~=0 
                        Nb_r=1+Nb_r;
                    end
         end
      end

    end
end



end
