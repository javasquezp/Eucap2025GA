function [] = map2(Lami,Lama,Lomi,Loma,LatNA,LonNA,mapvar)
               %worldmap ([Lami-2 Lama+2],[Lomi-2 Loma+2]);
               
               axesm('mercator','maplatlimit',[Lami Lama],'maplonlimit',[Lomi Loma])
               %setm('MapLatLimit',[Lami Lama],'MapLonLimit',[Lomi Loma])
               %axesm('mercator');
               load geoid
               colormap('jet');
               
               geoshow(LatNA,LonNA,mapvar,'DisplayType', 'texturemap')
               load coast
               plotm(lat, long)
               colorbar;
end

