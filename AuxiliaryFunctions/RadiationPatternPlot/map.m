function [] = map(Lami,Lama,Lomi,Loma,LatNA,LonNA,mapvar,cmin,cmax)
               worldmap ([Lami Lama],[Lomi Loma]);
               load geoid
               colormap('jet');
              
               geoshow(LatNA,LonNA,mapvar,'DisplayType', 'texturemap','FaceColor','flat')
               load coast
               plotm(lat, long)
               colorbar;
               caxis([cmin,cmax])
               
               
               
               
               
end

