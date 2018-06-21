


[PlacedNetworkCSDP]=placeSizeDGsCSDPVectorized(BaseNetwork);
[SizedNetworkCSDP]=sizeDGsCSDPVectorized(PlacedNetworkCSDP);











%% Initialize dispatch load levels
[LoadLevels, LoadLevelsProbs, LoadLevelsMat, v0MagsLevels]=loadScenarios(SizedNetwork.Bus.Phases,SizedNetwork.Bus.SLoad,Ml,LoadLevelMin, LoadLevelMax, v0MagMin, v0MagMax);
% LoadLevels is an N-cell where N is the number of buses in the network
% Each cell n where 1<=n<=N is a L-Ml matrix where L is the number of phases of bus n.
% and  Ml indicates the number of load level scenarios. 
% LoadLevelsProbs is an Ml*1 vector indicating the probability of load
% level i, where 1<=i<=Ml. 


%% Initialize dispatch solar irradiances
Mg=1; 
[FgammaLevels, gammaLevelsProbs, FgammaLevelsMat]=solarScenarios(SizedNetwork.Bus.Phases,SizedNetwork.Bus.SLoad,Mg);
%FgammaLevels is an N-cell where N is the number of buses in the network 
% Each cell n where  1<=n<=N is a L-Mg  where L is the number of phases of bus n.
% and  Mg indicates the number of solar scenarios. 
% FgammaLevelsProbs is an Mg*1 vector indicating the probability of solar
% scenario i, where 1<=i<=Mg.
% Since the solar scenarios are produced apriori, in this code values of Mg
% are limited to 1, 5, 25, and 200]


M=Ml*Mg; % total number of scenarios
ScenarioProbs=LoadLevelsProbs*gammaLevelsProbs.';  % linear index is the scenario number
% however, row index is the loadlevel and column index is the renewable
% scenario index.  Given 1<=m<=M as the scenario number, one can find
% [loadLevelIndex, fGammaLevelIndex]=ind2sub([Ml,Mg], m). 
ScenarioParams=v2struct(Ml,LoadLevels,LoadLevelsProbs,LoadLevelsMat,v0MagsLevels,v0MagMin,v0MagMax,...
    Mg,FgammaLevels,gammaLevelsProbs,FgammaLevelsMat,M,ScenarioProbs);
[SizedNetwork,ScenarioParams]=computevHat(SizedNetwork,ScenarioParams); 

SizedNetwork.Dispatch.ScenarioParams=ScenarioParams;
clear ScenarioParams;
[DispatchedNetwork]=dispatchDGs(SizedNetwork); 









