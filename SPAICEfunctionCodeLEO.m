%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Written by Juan A. Vasquez-Peralvo
%Luxembourg-Luxembourg
%5/12/2023
%Modified 7/28/2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Description%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code allows tto obtain the radiation pattern of 7 beams considering
%constrains of power, beamwidth, SLL and activation elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Example of use %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bwAzo = [10 12.5 12 13 11 14.5 9]; %Desired Beamwidths azimuth 
%bwElo = [10 12.5 12 13 11 14.5 9]; %Desired beamwidths elevation
%az0 = [0    6.17058137197424    -6.17058137197424    3.06600559354344 ...
     %   -3.06600559354346    3.12304325657409    -3.12304325657412]; %Steering angles for the beams
    %el0 = [0    0.0368473026481440    0.0368473026480987    4.77263541602628 ...  
    %    4.77263541602627    -4.75399052081361    -4.75399052081359]; %steering angle
%eirpo = [16 10 17 12 15 18.5 19]; % Desired eirps in dBw

%SPAICEfunctionCodeLEO(bwAzo, bwElo, az0, el0, eirp)

%%%%%%%%%%%%%%%%%%%%%%%%Initialize Matlab%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [wOutMatrix,wPatternC, CSI, bwperB , sllOpt, eirpdBWC, actElemetsC, gainBeams] = SPAICEfunctionCodeLEO(bwAzo, bwElo, az0, el0, eirpo)
    global counter; %for debbuging
    counter = 0;
    addpath('./AuxiliaryFunctions')
    addpath('./matFiles')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%Define Desired Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %bwAzo = [10 12.5 12 13 11 14.5 9]; %Desired Beamwidths azimuth 
    %bwElo = [10 12.5 12 13 11 14.5 9]; %Desired beamwidths elevation
    %bwAzo = [20 16]; %for one beam
    %bwElo = [20 16];
    nCromosome =500; % Number of possible solutions
    maxGenerations = 400; %Number of iterations
    sll0 = 13; %Overall sll
    %%%%%%%%%%%%%%%%%%%%%%%%%%%Define Constants%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cSpeed = physconst('LightSpeed'); %Speed of light
    frequency = 19e9; % operational frequency
    lambda = cSpeed / frequency;
    nElements = 8; %radius of the antenna in lambdas
    elementSpacing = 0.74*lambda; % interelement space
    %az0 = [0    6.17058137197424    -6.17058137197424    3.06600559354344 ...
     %   -3.06600559354346    3.12304325657409    -3.12304325657412]; %Steering angles for the beams
    %el0 = [0    0.0368473026481440    0.0368473026480987    4.77263541602628 ...  
    %    4.77263541602627    -4.75399052081361    -4.75399052081359]; %steering angle
    %az0 = [0 6.1705]; % for one  beam
    %el0 = [0 0.0368];
    %angRange = [-45:1:45]; %Analysis range
    %[angRangeM, angRangeM] = meshgrid(angRange, angRange);   %Matrix form
    %azShort = [angRange(1):abs(angRange(1)-angRange(2))*2:angRange(end)]; %for the SLL
    %elShort = [angRange(1):abs(angRange(1)-angRange(2))*2:angRange(end)]; %for the SLL
    granularity = 90/2; % Number of points
    dEl = 90/granularity;
    dAz = 90/granularity;
    angRangeEl = [-45:dEl:45]; %it has to be in this range
    angRangeAz = [-45:dEl:45]; %it has to be in this range
    %[angRangeAzM, angRangeElM] = meshgrid(angRangeAz, angRangeEl); 
    
    nBeams = length(az0); % count number of beams
    ploteron3D = 1; %Activate or deactivate plots in 3D
    ploteron2D = 1; %Activate or deactivate plots in 3D
    totalPower = 10; %Total power
    %maxPower = 10; %maximum power consuption
    
    powerPerElement = totalPower/(nElements^2); %Total power per element
    %maxPowerPerElement = maxPower / (nElements^2); %maximm power per element
    powerPerElelemntPerBeam = powerPerElement/7; %power per element per beam
    %maxPowerPerElementPerBeam = maxPowerPerElement/nBeams; %restricted power
    %%%%%%%%%%%%%%%%%%% Link Budget computation constants %%%%%%%%%%%
    azUserLoc = az0; % location where we want to obtain the CSI
    elUserLoc = el0; % location where we want to obtain the CSI
    satH = 500000;  % satellite altitude
    tR = 100; % : Receiver temperature
    rS = 1e9;      % : Symbol rate
    
    %%%%%%%%%%%%%%%%%%%%Genetic Algorithm InputParameters %%%%%%%%%%%%%%%%%%%%%
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = zeros(1, nElements^2*nBeams); %Lower bound
    ub = ones(1, nElements^2*nBeams); %Upper bound
    intcon = [1:nElements^2*nBeams]; %integer constrains
    mutationRate = 0.01; % To mutate the elements
    activeElements = 0;
    %%%%%%%%%%%%%%%%%%%%% Power Requirements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    maxActive = 6; %Define the total number of active elements
    pMax = 140; %This is one constrain that can be used
    %eirpo = [16 10 17 12 15 18.5 19]; % Desired eirps in dBw
    %eirpo = [16 19];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%% Loading mat Files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load('antenna.mat') %Load the antenna radiaiton pattern that was desinged 
    %%%%%%%%%%%%%%%%%%%%%%%%Define global variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%Define Tables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sll = 0;%Initialize the overall sll
    bwAz = 0;%Initialize the Azimuth beamwidth
    bwEl = 0;%Initialize the Elevation beamwidth
    gain = 0;%Gain
    results = table();
    %%%% Table for the active number of elements
    activatedNumber = [1:nBeams];
    activeElementsBeam = zeros(1, nBeams); %active elements this is a vector
    resultsBeam = table();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%Define Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%Reproducibility%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    prvS = rng(2013);
    %%%%%%%%%%%%%%%% Load up any necessary mat or txt files %%%%%%%%%%%%%%%%%%%
    %load("./../matFiles/antenna.mat");
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ------------------------------------------------------------------------
    %                            Main Script Logic
    % ------------------------------------------------------------------------
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clc;
    fprintf( 1, '------------------------------------------------------------\n' );
    fprintf( 1, '------ LEO Radiation Pattern Optimization Multiple Beam  --------\n' );
    fprintf( 1, '------------------------------------------------------------\n' );
    fprintf( 1, '------ Author(s):                                   --------\n' );
    fprintf( 1, '------          Juan Andrés Vásquez Peralvo         --------\n' );
    fprintf( 1, '------------------------------------------------------------\n' );
    fprintf( 1, '------ Date:      July 2023                         --------\n' );
    fprintf( 1, '------------------------------------------------------------\n' );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Start Timer
    tini=clock;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%% Initiate constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Get the circular Array elements positions
    array = phased.URA('Size',[nElements nElements], 'Lattice','Triangular', ...
        'ArrayNormal','x','ElementSpacing',elementSpacing, ...
        'ArrayNormal', 'x');
    positionsArray = array.getElementPosition; %%% Position of the antennas
    %%%%%%%%%%%%%%%%%%%%%%%%%% Unit Cell Radiation Pattern Import %%%%%%%%%%%%%
    antennaPattern = pattern(antenna, frequency, angRangeAz, angRangeEl,'PropagationSpeed', ...
            cSpeed, 'Type', 'eField', 'Normalize',false,'CoordinateSystem', ...
            'rectangular');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%% Steering Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    steeringAngles = [az0;el0];
    sv = steervec(positionsArray/lambda, steeringAngles);
    w = sv;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if 0 %To plot if needed
            for i = 1 : nBeams % To plot all the un optmized radiation patterns
                aF3(:, :, i) = db2mag(arrayFactorMatlab(positionsArray/lambda, w(:,i), angRangeAz, angRangeEl)).*...
                antennaPattern; %Calculte the total radiation pattern
                Prad = sum(sum(abs(aF3(:,:,i)).^2.*cos(angRangeElM*pi/180)*dAz*pi/180*dEl*pi/180)); %Total Radiation Pattern
                gainC = 4*pi*abs(aF3(:,:,i)).^2./Prad;
                gain = 10*log10(max(max(abs(gainC))));
                figure1=figure;
                axes1 = axes('Parent',figure1);
                hold(axes1,'on');
                surf(angRangeAz, angRangeEl', pow2db(gainC))
                shading interp
                set(axes1,'FontName','Times New Roman','FontSize',18);
                xlabel('Azimuth (\circ)')
                ylabel('Elevation (\circ)')
                titul = sprintf('Beam %1.f Radiation pattern', i);
                title(titul)
                a = colorbar;
                a.Label.String = 'Gain (dBi)';
                box on
                ix = find(imregionalmax(pow2db(gainC)));
                [maxRad maxPos] = sort(pow2db(gainC(ix)), 'descend');
                scatter3(angRangeAzM(ix(maxPos(1:1))),angRangeElM(ix(maxPos(1:1))), ...
                    maxRad(1:1), 'blue', 'filled')%,'k','MarkerSize',10, 'Marker','o', 'MarkerFaceColor','k')
                scatter3(angRangeAzM(ix(maxPos(2:2))),angRangeElM(ix(maxPos(2:2))), ...
                    maxRad(2:2), 'black', 'filled')%,'k','MarkerSize',10, 'Marker','o', 'MarkerFaceColor','k')
                label1 = sprintf('Gain Max = %2.2f dBi',maxRad(1));
                label2 = sprintf('SLL = %2.2f dB',maxRad(1) -maxRad(2));
                %text(angRangeAzM(ix(maxPos(1))), angRangeElM(ix(maxPos(1))), maxRad(1), label1);
                %text(angRangeAzM(ix(maxPos(2))), angRangeElM(ix(maxPos(2))),maxRad(2), label2);
                contour3(angRangeAz, angRangeEl', pow2db(gainC), [gain-3 gain-3], ...
                    'lineColor', 'k', 'LineWidth', 3);
                legend('Radiation Pattern', label1, label2, '\theta_{-3dB}')
                xlim([-90 90])
            end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% Configuratio of the optimizer %%%%%%%%%%%%%%%%%%%%%%%%%
    nGenes = length(positionsArray) *   nBeams; % Calculate the number of chromosomes
    %wchromosomes = randi([0, 1], [nGenes, nCromosome]); %Calculate possible sol.
    % Define fitness function
    fun=@(variables)[costFunctionSPAICELEO(variables, positionsArray, -az0, -el0, sll0, ...
        w, bwAzo, bwElo, frequency, cSpeed, eirpo, powerPerElelemntPerBeam, ...
         angRangeAz, angRangeEl, antennaPattern)];
    
    % Define GA options
    options = optimoptions('ga', 'PopulationSize', nCromosome, ...
        'MaxGenerations', maxGenerations, 'FunctionTolerance', 1e-6, ...
         'PlotFcn', @gaplotbestf, 'MutationFcn', ... 
    {@mutationuniform, mutationRate}, 'CrossoverFcn', 'crossoverscattered' , ...
    'FitnessLimit', 0.001, 'UseParallel', true);
    
    % Run GA optimization
    %nonlcon = [];  %Activate this and deactivate the other to avoid nonlcon
     nonlcon = @(variables)[constrainFunctionSPAICELEO(variables, positionsArray, ...
          az0, maxActive, pMax )];
        [wf,fval] = ga(fun, nGenes, A, b, Aeq, beq, lb, ub, nonlcon, intcon, ...
            options); % wf has the final result
        %%
        disp(['Fitness value: ', num2str(fval)]); %Show the fitness value 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% Processing the weight vector obtained %%%%%%%%%%%%%%%%%
    numElements = length(positionsArray);
    angRangeEl = [-180/2:180/2]; %it has to be in this range
    angRangeAz = [-360/2:360/2]; %it has to be in this range
    [angRangeAzM, angRangeElM] = meshgrid(angRangeAz, angRangeEl); 
    array = phased.URA('Size',[nElements nElements], 'Lattice','Triangular', ...
        'ArrayNormal','x','ElementSpacing',elementSpacing, ...
        'ArrayNormal', 'x', 'Element', antenna);
    for i =1 : nBeams
        wPattern(:,i) = wf((i-1)*numElements+1:i*numElements)'.*sv(:,i);
              activeElements = activeElements + abs(wPattern(:,i));
        % Extract principal cuts
        %%Extract Principal Cuts
        
       % antennaPatternEl = pattern(antenna, frequency, -az0(i), angRangeEl, 'PropagationSpeed', ...
        %    cSpeed, 'Type', 'eField', 'Normalize',false,'CoordinateSystem', ...
         %   'rectangular');
        %antennaPatternAz = pattern(antenna, frequency, angRangeAz, -el0(i), 'PropagationSpeed', ...
         %   cSpeed, 'Type', 'eField', 'Normalize',false,'CoordinateSystem', ...
         %   'rectangular');
        %elCut = mag2db(db2mag(arrayFactorMatlab(positionsArray./lambda, wPattern(:,i), -az0(i), angRangeEl)').*...
        %        antennaPatternEl);
        %azCut = mag2db(db2mag(arrayFactorMatlab(positionsArray./lambda, wPattern(:,i), angRangeAz, -el0(i))').*...
         %       antennaPatternAz);
        % Extract total radiation pattern
          %  radPatt3D = db2mag(arrayFactorMatlab(positionsArray/lambda, wPattern(:,i), angRangeAz, angRangeEl)).*...
           % antennaPatternFull;
            %radPatt3DOptimized = mag2db(radPatt3D);
          arrayPattern(:,:,i) = pattern(array, frequency, 'PropagationSpeed',  ...
            cSpeed, 'az', angRangeAz ,'el',angRangeEl ,'Type', 'directivity','CoordinateSystem', 'rectangular', 'weight', wPattern(:,i)); 
          arrayPatternP = arrayPattern(:,:,i);
          azCut = pattern(array, frequency, 'PropagationSpeed', cSpeed ,'az', angRangeAz, ...
              'el', el0(i), 'Type', 'directivity','CoordinateSystem', 'rectangular', 'weight', wPattern(:,i)); 
          elCut = pattern(array, frequency, 'PropagationSpeed', cSpeed, 'az', az0(i), ...
              'el', angRangeEl , 'Type', 'directivity','CoordinateSystem', 'rectangular', 'weight', wPattern(:,i)); 
          arrayPatternP = arrayPattern(:,:,i);
       
        %%f 
        %%Extracting beam information
        %SLL
        % ix = find(imregionalmax(radPatt3DOptimized));
        %    [maxRad maxPos] = sort(radPatt3DOptimized(ix), 'descend');
        %sllOpt = maxRad(1)-maxRad(2);
        sllOpt = sll3Dsearch(arrayPatternP);
        %Beamwidth
       [xy] = contourc(angRangeAz,angRangeEl,arrayPatternP - max(arrayPatternP(:)),[1 -3]);
            xBw = xy(1,2:end)- az0(i); % the positions in x for the beamwidth
            yBw = xy(2,2:end) - el0(i); % Positions in y for the beamwidth
            bw = (sqrt(xBw.^2+yBw.^2))*2;
            bwperB(i) = mean((bw));
        %Gain%%
    
        %gain = gainCalculationFcn(positionsArray/lambda, wPattern(:,i));
         %Prad = sum(sum(abs(radPatt3D).^2.*cos(angRangeElM*pi/180)*dAz*pi/180*dEl*pi/180)); %Total Radiation Pattern
          %  gainC = 4*pi*abs(radPatt3D).^2./Prad;
           % gain = 10*log10(max(max(abs(gainC))));
            %gainEx (:,:,i) = gain; 
            gainBeams(i) = max(arrayPatternP(:));
         %
        
        if ploteron3D
            
            
            figure1=figure;
            axes1 = axes('Parent',figure1);
            hold(axes1,'on');
            surf(angRangeAz, angRangeEl', arrayPatternP);
            shading interp
            set(axes1,'FontName','Times New Roman','FontSize',18);
            xlabel('Azimuth (\circ)')
            ylabel('Elevation (\circ)')
            title('Radiation Pattern')
            a = colorbar;
            a.Label.String = 'Gain (dBi)';
            box on
            ix = find(imregionalmax((arrayPatternP)));
            [maxRad maxPos] = sort((arrayPatternP(ix)), 'descend');
            scatter3(angRangeAzM(ix(maxPos(1:1))),angRangeElM(ix(maxPos(1:1))), ...
                maxRad(1:1), 'blue', 'filled')%,'k','MarkerSize',10, 'Marker','o', 'MarkerFaceColor','k')
            scatter3(angRangeAzM(ix(maxPos(2:2))),angRangeElM(ix(maxPos(2:2))), ...
                maxRad(2:2), 'black', 'filled')%,'k','MarkerSize',10, 'Marker','o', 'MarkerFaceColor','k')
            label1 = sprintf('Gain Max = %2.2f dBi',maxRad(1));
            label2 = sprintf('SLL = %2.2f dB',maxRad(1) -maxRad(2));
            %text(angRangeAzM(ix(maxPos(1))), angRangeElM(ix(maxPos(1))), maxRad(1), label1);
            %text(angRangeAzM(ix(maxPos(2))), angRangeElM(ix(maxPos(2))),maxRad(2), label2);
            contour3(angRangeAz, angRangeEl', (arrayPatternP), [gainBeams(i)-3 gainBeams(i)-3], ...
                'lineColor', 'k', 'LineWidth', 3);
            legend('Radiation Pattern', label1, label2, '\theta_{-3dB}')
            xlim([-90 90])
            
    
        end
        
        %
        %Adding results to the table
       
        results.bwAz0(i) = bwElo(i);
        results.bwAzC(i) = bwperB(i);
        results.errorbwEl(i) = abs(bwperB(i)-bwElo(i))/bwElo(i)*100;
        results.gain(i) = gainBeams(i);
        results.sll(i) = sllOpt;
        results.errorSll(i) = abs(sllOpt-sll0)/sll0*100*(sllOpt<sll0);
        actElemetsC = sum(abs(wPattern(:,i)));
        results.ActEle(i) = actElemetsC;
        eirpdBWC =gainBeams(i) + pow2db(sum(abs(wPattern(:,i))) ...
            *powerPerElelemntPerBeam);
        results.EIRPdBW(i) =  eirpdBWC%This value is in dBm
        results.EIRPError(i) = abs(results.EIRPdBW(i) - eirpo(i))/eirpo(i)* 100;   %results;
        
        %
        %ploting the results
        ploteron2D = 1;
        if ploteron2D
            figure1=figure;
            axes1 = axes('Parent',figure1);
            hold(axes1,'on');
            plot(angRangeAz, azCut-max(azCut) + gain, 'LineWidth',2);
            plot(angRangeEl, elCut-max(elCut) + gain, 'LineWidth',2);
            set(axes1,'FontName','Times New Roman','FontSize',18);
            xlabel('Angle (\circ)')
            ylabel('Gain (dBi)')
            title('Radiation Pattern')
            box on
            legend('Azimuth Cut', 'Elevation Cut')
        end
    end
    
    %%%%%%%%%%%%%%%%%% Plot all the active elements %%%%%%%%%%%%%%%%%%%%%%%%%%%
     %
        %%plot antenna Layout
        if ploteron2D
            figure1=figure;
            axes1 = axes('Parent',figure1);
            hold(axes1,'on');
            %Eliminate the antenna where the amplitude is 0
            positionsArrayGraph = positionsArray;
            positionsArrayGraph(2, sum(wPattern, 2) ==0)=NaN;
            positionsArrayGraph(3, sum(wPattern, 2) ==0)=NaN;
            s = scatter3(positionsArrayGraph(2,:)./lambda, positionsArrayGraph(3,:)./lambda,...
                sum(wPattern, 2), [], sum(wPattern, 2), 'filled');
            box(axes1,'on');
            hold(axes1,'off');
            % Set the remaining axes properties
            %set(axes1,'CLim',[1 nBeams],...
             %  'Colormap',  [0.9769 0.9839 0.0805;0.9871 0.73475 0.24375;0.5044 0.7993 0.348;0.0704 0.7457 0.7258;0.154 0.5902 0.9218;0.278 0.3556 0.9777;0.2422 0.1504 0.6603],... 
            %'FontName','Times New Roman','FontSize',18);
    % Create colorbar
    colorbar(axes1,'Ticks',[1 2 3 4 5 6 7]);
            colorbar
    %        clim([1 max(sum(abs(wPattern),2))])
            s.SizeData = 100;
            set(axes1,'FontName','Times New Roman','FontSize',18);
            xlabel('x-positions (\lambda_0)')
            ylabel('y-positions (\lambda_0)')
            title('DRA antenna layout')
            %Circle
            %th = 0:pi/50:2*pi;
            %xunit = radius * cos(th) + 0;
            %yunit = radius * sin(th) + 0;
            %h = plot(xunit, yunit, 'LineWidth',2, 'Color','k');
            box on
            view([0 90])
        end
        results
        activeElementsBeam = [sum(activeElements==1), sum(activeElements==2),...
            sum(activeElements==3), sum(activeElements==4), sum(activeElements==5), ...
           sum(activeElements==6), sum(activeElements==7) ];  
         %resultsBeam.beamNumber = beamNumber';
         resultsBeam.activeElementsBeam = activeElementsBeam'; 
%         resultsBeam.activatedNumber = activatedNumber';
         disp('The number of times that each elelment are activated is shown below:\n')
        resultsBeam
         disp('The total power consumption for the creation of all beams are: ')
         actualConsumption = sum(activeElements)*powerPerElelemntPerBeam
    % Cleanup or finalization code (if any)
    save('ResultsActCon.mat', 'wf')
    wOutMatrix = reshape(wf, [nElements, nElements, nBeams]);
    wPatternC = reshape(wPattern, [nElements, nElements, nBeams]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%% CSI Computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % first we need to evaluate what is the gain in the user location
    
    [gainsCSI] = gainUserEval(  arrayPattern, azUserLoc, elUserLoc, ...
        angRangeAz, angRangeEl );
    [csiAntennacontribution] = reshape(steervec(positionsArray, [azUserLoc; elUserLoc]), nElements, nElements, length(azUserLoc));

    [lB] = linkBudget(db2pow(gainsCSI), frequency, satH, tR, rS, azUserLoc, elUserLoc);
    %gainperBeam = diag(gainCSI);
    lBperBeam = diag(lB);
    for i = 1 : nBeams  
        CSI(:,:,i) = csiAntennacontribution(:,:,i) .* lBperBeam(i);

    end

    % Display a completion message
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Stop Timer
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    duration=etime(clock, tini);
    dminutes=floor(duration/60);
    dseconds=duration-dminutes*60;
    dhours=floor(dminutes/60);
    dminutes=dminutes-dhours*60;
    fprintf( 1, '------------------------------------------------------------\n' );
    disp(['    Total Time = '  num2str(dhours) 'h ' num2str(dminutes) 'min ' num2str(dseconds) 'sec']);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf( 1, '------------------------------------------------------------\n' );
    fprintf( 1, '--------------------    Thank you        -------------------\n' );
    fprintf( 1, '--------------------       END           -------------------\n' );
    fprintf( 1, '------------------------------------------------------------\n' );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % END
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


