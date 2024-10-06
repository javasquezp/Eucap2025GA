clear all
close all
clc


load('ParamTable 1.mat')
load('ResultsDataTraining.mat')

for i = 61902 : length(ParamTable.Beamwidth_Azimuth)
 %close all
        bwAz0 = ParamTable.Beamwidth_Azimuth(i);
        bwEl0 = ParamTable.Beamwidth_Elevation(i);
        az0 = ParamTable.Azimuth(i);
        el0 = ParamTable.Elevation(i);
        eirp0 = ParamTable.EIRP_dBW(i);
        [wOutMatrix, wOutMatrixComp, CSI, bwC , sllC, eirpdBWC, actElemetsC, gainBeams] = ...
            SPAICEfunctionCodeLEO(bwAz0, bwEl0, az0, el0, eirp0);
        resultsCell{i,1} = bwC;
        resultsCell{i,2} = bwC;
        resultsCell{i,3} = sllC;
        resultsCell{i,4} = eirpdBWC;
        resultsCell{i,5} = actElemetsC;
        resultsCell{i,6} = gainBeams;
        resultsCell{i,7} = az0;
        resultsCell{i,8} = el0;
        resultsCell{i,9} = wOutMatrix;
        resultsCell{i,10} = wOutMatrixComp;
        resultsCell{i,11} = CSI;


        save('ResultsDataTraining.mat', "resultsCell");


end

