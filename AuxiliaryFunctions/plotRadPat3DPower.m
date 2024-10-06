%------------------------------------------------------------------------%
%                           MATLAB File Header                            %
%------------------------------------------------------------------------%
%
% File Name:   plotRadPat3DPower.m
% Author:      Juan Vasquez
% Date:        May 25, 2023
% Version:     1.0
% Description: This function allows to plot a 3D represetnation of an
% antenna
% Input: azimuth and elevations in vector form, pattern3D Matrix form
% Output: plot
%------------------------------------------------------------------------%

function plotRadPat3DPower(azimuth, elevation, pattern3D, typeG)
    figure1 = figure;
    axes1 = axes('Parent',figure1);
    surf(azimuth, elevation', (pattern3D)); xlabel('azimuth (\circ)'); 
    ylabel('elevation (\circ)'); grid minor; 
    shading interp
    view([0 90])
    aux1 = colorbar;
    
    %caxis([-50, max(max(pat_azel))])
    [max_num, max_idx]=max(pattern3D(:));
    [X,Y]=ind2sub(size(pattern3D),max_idx);
    hold on
    maxRadPatt = max(max((pattern3D)));
    plot3(   azimuth(Y), elevation(X), max(max((pattern3D))), 'o', 'MarkerFaceColor','k');
    set(axes1,'FontName','Times','FontSize',18);
    xlim([azimuth(1) azimuth(end)]);%set axis limits
    ylim([elevation(1) elevation(end)]);%set axis limits
    [C,h] = contour3(azimuth, elevation, pattern3D, [max(pattern3D(:)) ...
        max(pattern3D(:))-3], '-k', 'LineWidth',4, 'ShowText','on', 'LabelSpacing',300);
    clabel(C,h,'FontSize',18,'Color',[0 0 0]);

    if typeG == 'power'
        maxRad = sprintf('Maximum = %f dB', maxRadPatt);
        legend('power Radiation pattern', maxRad, '\theta_{-3dB}');
        aux1.Label.String = 'Power Normalized (dB)';
        
    else
        legend('Gain radiation Pattern', maxRad, '\theta_{-3dB}');
        aux1.Label.String = 'Gain (dBi)';
        maxRad = sprintf('Maximum = %f dBi', maxRadPatt);
    end
    %title('Radiation Pattern of the subarray')
    axes1.SortMethod = 'childorder';
    x0=10;
    y0=10;
    width=900;
    height=700;
    set(gcf,'position',[x0,y0,width,height])

end