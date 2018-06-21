cd('Results/MosekResultsFinal/'); 
FileName='MILP1Scenario.mat';
a=load(FileName); 
cd('..');
cd('..'); 

SizedNetwork=a.SizedNetwork;
clear a;

% PVData=load('PVData/PvData.mat'); 
PVData=load('PVData/Solar1000Scenarios.mat'); 
NoDispatchScenarios=length(PVData.FgammaLevels(1:10));
DispatchScenarios=PVData.FgammaLevels(1:NoDispatchScenarios);


DispatchNetworks=cell(NoDispatchScenarios,1); 

t1=tic;
for ii=1:NoDispatchScenarios
str=['Running dispatch No, ', num2str(ii), '\n'];
    fprintf(str); 
    DispatchNetworks{ii}=SizedNetwork;
   DispatchNetworks{ii}.Dispatch.ScenarioParams=SizedNetwork.Placement.ScenarioParams; 
    
DispatchNetworks{ii}.Dispatch.ScenarioParams.Mg=1;    
N=size(SizedNetwork.Bus.SLoad,1); 
DispatchNetworks{ii}.Dispatch.ScenarioParams.FgammaLevels=cell(N,1);
for n=1:N
L=length(SizedNetwork.Bus.Phases{n}); 
DispatchNetworks{ii}.Dispatch.ScenarioParams.FgammaLevels{n}=repmat(DispatchScenarios(ii),L,1);
end
DispatchNetworks{ii}.Dispatch.ScenarioParams.FgammaLevelsMat=cell2mat(DispatchNetworks{ii}.Dispatch.ScenarioParams.FgammaLevels);
DispatchNetworks{ii}.Dispatch.ScenarioParams.gammaLevelsProbs=PVData.gammaLevelsProbs(ii); 


DispatchNetworks{ii}.Dispatch.ScenarioParams.M=DispatchNetworks{ii}.Dispatch.ScenarioParams.Ml*...
   DispatchNetworks{ii}.Dispatch.ScenarioParams.Mg; % total number of scenarios
DispatchNetworks{ii}.Dispatch.ScenarioParams.ScenarioProbs=...
    DispatchNetworks{ii}.Dispatch.ScenarioParams.LoadLevelsProbs*DispatchNetworks{ii}.Dispatch.ScenarioParams.gammaLevelsProbs.';% linear index is the scenario number
% however, row index is the loadlevel and column index is the renewable
% scenario index.  Given 1<=m<=M as the scenario number, one can find
% [loadLevelIndex, fGammaLevelIndex]=ind2sub([Ml,Mg], m). 


    DispatchNetworks{ii}=dispatchDGs(DispatchNetworks{ii});
    
end
t2=toc(t1)
cd('Results'); 
SaveName=[FileName,'Dispatch'];
save(SaveName, 'DispatchNetworks'); 
cd('..'); 