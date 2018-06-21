PVData=load('PVData/PvData.mat'); 
NoDispatchScenarios=length(PVData.ValidData);
DispatchScenarios=PVData.ValidData(1:NoDispatchScenarios); 


DispatchNetworks=cell(NoDispatchScenarios,1); 


parfor ii=1:NoDispatchScenarios
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
DispatchNetworks{ii}.Dispatch.ScenarioParams.FgammaLevelsMat=cell2mat(FgammaLevels);
DispatchNetworks{ii}.Dispatch.ScenarioParams.gammaLevelsProbs=(1./NoDispatchScenarios); 


DispatchNetworks{ii}.Dispatch.ScenarioParams.M=SizedNetwork.Placement.ScenrioParams.Ml*Mg; % total number of scenarios
DispatchNetworks{ii}.Dispatch.ScenarioParams.ScenarioProbs=...
    SizedNetwork.Placement.ScenarioParams.LoadLevelsProbs*DispatchNetworks{ii}.Dispatch.ScenarioParams.gammaLevelsProbs.';% linear index is the scenario number
% however, row index is the loadlevel and column index is the renewable
% scenario index.  Given 1<=m<=M as the scenario number, one can find
% [loadLevelIndex, fGammaLevelIndex]=ind2sub([Ml,Mg], m). 


    DispatchNetworks{ii}=dispatchDGs(DispatchNetworks{ii});
    
end

cd('Results'); 
save('DispatchNetworksMISOCP1', 'DispatchNetworks'); 
cd('..'); 