clear all 
close all
clc

%%
%Load Data
addpath('./../../../AuxiliaryFunctions/')
addpath('./../../AuxiliaryFunctions/')
addpath('./../../AuxiliaryFunctions/utils')
addpath('./../../matFiles')
load('ResultsNoActCon.mat');
%Load antenna
load('antenna.mat') %Load the antenna radiaiton pattern that was desinged 

%%
cSpeed = physconst('LightSpeed'); %Speed of light
frequency = 19e9; % operational frequency
lambda = cSpeed / frequency;
nElements = 8; %radius of the antenna in lambdas
elementSpacing = 0.74*lambda; % interelement space
az0 = [0    6.17058137197424    -6.17058137197424    3.06600559354344 ...
   -3.06600559354346    3.12304325657409    -3.12304325657412]*2; %Steering angles for the beams
el0 = [0    0.0368473026481440    0.0368473026480987    4.77263541602628 ...  
    4.77263541602627    -4.75399052081361    -4.75399052081359]*2; %steering angle
%az0 = [4.92950301754649	11.1000850622344	-1.24107767416516	8.00688422531144	1.87493635164924	8.06383202893744	1.81780950111841	5.03015683329522	11.0104054785483	-0.952055933873104	8.06898273757428	2.14101039530983	8.00880327826114	1.94060824912418	17.0079465197861	22.6717708279336	11.0527302065512	19.7669594565384	13.9988894198825	20.0098191068903	14.1344471237059	-7.12613637933164	-1.17091352205402	-12.7899428560082	-4.05082320594902	-9.82137380902261	-4.27543437177432	-10.1507642921094];
%el0 = [0	0.0366881205822324	0.0369157419503900	4.75941189321285	4.77405913759429	-4.74068313212926	-4.75554463050429	14.0029616413993	13.9141973896410	13.9981985421713	18.3064382985559	18.3612542984856	9.43562770552519	9.46440313309354	4.76332375236587	4.78531143548735	4.75713241166500	9.26068846955873	9.36515334245036	0.221029172190598	0.0817765335742237	4.82144241929695	4.78637800151678	4.87164805421414	9.45048367660518	9.39979007914382	0.0825352642286943	0.224408716444367];
%az0 = 2*[4.92950301754649	11.1000850622344	-1.24107767416516	8.00688422531144	1.87493635164924	8.06383202893744	1.81780950111841	5.03015683329522	11.0104054785483	-0.952055933873104	8.06898273757428	2.14101039530983	8.00880327826114	1.94060824912418	17.0079465197861	22.6717708279336	11.0527302065512	19.7669594565384];
%el0 = 2*[0	0.0366881205822324	0.0369157419503900	4.75941189321285	4.77405913759429	-4.74068313212926	-4.75554463050429	14.0029616413993	13.9141973896410	13.9981985421713	18.3064382985559	18.3612542984856	9.43562770552519	9.46440313309354	4.76332375236587	4.78531143548735	4.75713241166500	9.26068846955873];


granularity = 800; % Number of points
dEl = 180/granularity;
dAz = 360/granularity;
angRangeEl = [-90:dEl:90]; %it has to be in this range
angRangeAz = [-180:dAz:180]; %it has to be in this range
u = [-1: 1/granularity:1];
v = [-1: 1/granularity:1];
[angRangeAzM, angRangeElM] = meshgrid(angRangeAz, angRangeEl); 
latitudeSat = 49.62 ;
longitudeSat = 6.5;
altSat = 600000;
nBeams = length(az0); % count number of beams
ploteron3D = 1; %Activate or deactivate plots in 3D
ploteron2D = 1; %Activate or deactivate plots in 3D
totalPower = 10; %Total power
%maxPower = 10; %maximum power consuption

powerPerElement = totalPower/(nElements^2); %Total power per element
%maxPowerPerElement = maxPower / (nElements^2); %maximm power per element
powerPerElelemntPerBeam = powerPerElement/7; %power per element per beam
%maxPowerPerElementPerBeam = maxPowerPerElement/nBeams; %restricted power

array = phased.URA('Size',[nElements nElements], 'Lattice','Triangular', ...
    'ArrayNormal','x','ElementSpacing',elementSpacing, ...
    'ArrayNormal', 'x', 'Element', antenna);
positionsArray = array.getElementPosition; %%% Position of the antennas

%%
% Position of the arrays
numElements = length(positionsArray);
steeringAngles = [az0;el0];
svAngles = steervec(positionsArray/lambda, steeringAngles);
activeElements = 0;
for i =1 : nBeams
          wPattern(:,i) = wf((i-1)*numElements+1:i*numElements)'.*svAngles(:,i);
          activeElements = activeElements + abs(wPattern(:,i));
% Plot 2d azimuth graph
format = 'uv';
cutAngle = 0;
plotType = 'directivity';
plotStyle = 'Overlay';
%figure;
%Get the azimuth cut
[patternUV(:, :, i), u, v] = pattern(array, frequency, u, v, 'PropagationSpeed', cSpeed,...
    'CoordinateSystem', format ,'weights', wPattern(:,i), ...
    'Type', plotType, 'PlotStyle', plotStyle);
[patternAzEl(:, :, i), azV, elV] = pattern(array, frequency, angRangeAz   ,angRangeEl, 'PropagationSpeed', cSpeed,...
    'CoordinateSystem', 'rectangular' ,'weights', wPattern(:,i), ...
    'Type', plotType, 'PlotStyle', plotStyle);

 patternUV(:, :, i) = patternUV(:, :, i) + pow2db(sum(abs(wPattern(:,i)))* powerPerElelemntPerBeam);
  patternAzEl(:, :, i) = patternAzEl(:, :, i) + pow2db(sum(abs(wPattern(:,i)))* powerPerElelemntPerBeam);
%%
 % 
 % for i = 1 : nBeams
 %     figure
 % pattern(array, frequency, 'PropagationSpeed', cSpeed,...
 %    'CoordinateSystem', 'rectangular' ,'weights', wPattern(:,i), ...
 %    'Type', plotType, 'PlotStyle', plotStyle);
 % end
%%
end
%%

  figure1=figure('PaperUnits',  'inches','PaperSize', [4 6], 'Position', [100, 200, 650, 525]);
         axes1 = axes('Parent',figure1,"Units","pixels","Position",[105, 115, 500, 400]);
        % set(figure1,  'PaperPosition', [0 0 2 3] )
   %set(gcf, 'PaperSize', [0.5, 1])
        %b= axes(a)
        hold(axes1,'on');
        %Eliminate the antenna where the amplitude is 0
        positionsArrayGraph = positionsArray;
        %positionsArrayGraph(2, sum(wPattern, 2) ==0)=NaN;
        %positionsArrayGraph(3, sum(wPattern, 2) ==0)=NaN;
        s = scatter3(positionsArrayGraph(2,:)./lambda, positionsArrayGraph(3,:)./lambda,...
            sum(abs(wPattern), 2), [], sum(abs(wPattern), 2), 'filled', 'o', 'MarkerEdgeColor', 'k');
        box(axes1,'on');
        hold(axes1,'off');
        % Set the remaining axes properties
        %set(axes1,'CLim',[1 nBeams],...
          % 'Colormap',  [0.9769 0.9839 0.0805;0.9871 0.73475 0.24375;0.5044 0.7993 0.348;0.0704 0.7457 0.7258;0.154 0.5902 0.9218;0.278 0.3556 0.9777;0.2422 0.1504 0.6603],... 
        %colormap([1 1 1 ; 0.9769 0.9839 0.0805;0.9871 0.73475 0.24375;0.5044 0.7993 0.348;0.0704 0.7457 0.7258;0.154 0.5902 0.9218;0.278 0.3556 0.9777])
        colormap([1 1 1 ; 0.9769 0.9839 0.0805;0.9871 0.73475 0.24375;0.5044 0.7993 0.348;0.0704 0.7457 0.7258;0.154 0.5902 0.9218])
        %colormap([1 1 1 ; 0.9769 0.9839 0.0805;0.9871 0.73475 0.24375;0.5044 0.7993 0.348;0.0704 0.7457 0.7258;0.154 0.5902 0.9218;0.278 0.3556 0.9777; 0 0 0])
          %'FontName','Times New Roman','FontSize',18);
% Create colorbar
% colormap([1 1 1; % White for 0
%           0 0 1; % Blue for 1
%           0 1 1; % Magenta for 5
%            0 1 0; % Green for 2
%           1 1 0; % Yellow for 4
%           1 0 0; % Black
%           %0 0 0 ...
%           ]); % Red for 5; 
        clabel = colorbar(axes1,'Ticks',[0 1 2 3 4 5 6 7]);
        ylabel(clabel, 'Activation Instance','FontName','Times New Roman','FontSize',22)
        xlim([min(positionsArrayGraph(2,:)./lambda) max(positionsArrayGraph(2,:)./lambda) ]*1.2 )
        %colorbar
%        clim([1 max(sum(abs(wPattern),2))])
        s.SizeData = 100;
        set(axes1,'FontName','Times New Roman','FontSize',22);
        xlabel('x-positions (\lambda_0)')
        ylabel('y-positions (\lambda_0)')
        %title('DRA antenna layout')
         box on
        view([0 90])
        %%
        %Activation instances in table form
        activeElements = sum(abs(wPattern),2)
        resultsBeam = table();
        activeElementsBeam = [sum(activeElements==0), sum(activeElements==1), sum(activeElements==2),...
        sum(activeElements==3), sum(activeElements==4), sum(activeElements==5), ...
       sum(activeElements==6), sum(activeElements==7) ];  
     %resultsBeam.beamNumber = beamNumber';
     resultsBeam.activeElementsBeam = activeElementsBeam'; 
     resultsBeam.activatedNumber = [0:7]';
     disp('The number of times that each elelment are activated is shown below:\n')
    resultsBeam

%%
close all
figure
[U V] = meshgrid(u, v);
latitudeSat = 0 ;
longitudeSat = -78;
altSat = 500000;
plotOnMap(U, V, patternUV, -3, latitudeSat, longitudeSat, altSat);

