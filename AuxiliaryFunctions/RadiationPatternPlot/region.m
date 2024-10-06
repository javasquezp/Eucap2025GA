function [LatNA,LonNA,Ef_Area] = region( Lami,Lama,Lomi,Loma,Lat,Lon,AreaR)

   L1= (10*(90-(Lama)))+1;
   L2= (10*(90-(Lami)))+1;
   if Lomi>=0 & Loma>=0 
    L3=(10*(Lomi))+1;
    L4=(10*(Loma))+1;
    LatNA=Lat(L1:L2,L3:L4);
    LonNA=Lon(L1:L2,L3:L4);
    Ef_Area=AreaR(L1:L2,L3:L4);
   end
   if Lomi<0 & Loma<0 
    L3=(10*(360+(Lomi)))+1;
    L4=(10*(360+(Loma)))+1;
    LatNA=Lat(L1:L2,L3:L4);
    LonNA=Lon(L1:L2,L3:L4);
    Ef_Area=AreaR(L1:L2,L3:L4);
   end
    
   if Lomi<0 & Loma>=0 
    L3=(10*(360+(Lomi)))+1;
    L4=(10*(Loma))+1;
    LatNA=[Lat(L1:L2,L3:3600) Lat(L1:L2,1:L4)];
    LonNA=[Lon(L1:L2,L3:3600) Lon(L1:L2,1:L4)];
    Ef_Area=[AreaR(L1:L2,L3:3600) AreaR(L1:L2,1:L4)];
   end
   
end

