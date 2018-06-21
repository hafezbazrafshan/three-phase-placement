function BaseNetwork=initialize(Mg)

%% Constants:
v0Mags=[1.05;1.05;1.05];
v0Phases=degrees2radians([0;-120;120]); 
vS=v0Mags.*exp(sqrt(-1)*v0Phases); 
VMIN=0.9;
VMAX=1.1;


%% Initialize network object
RegulatorType='Wye';
BaseNetwork=setupIEEE8500(RegulatorType); 
BaseNetwork.vS=vS;
BaseNetwork.VMIN=VMIN;
BaseNetwork.VMAX=VMAX;


%% Initialize load levels
Ml=3; 
LoadLevelMin=0.8; 
LoadLevelMax=1.2;
v0MagMin=1.01/1.05;
v0MagMax=1.07/1.05;
[LoadLevels, LoadLevelsProbs, LoadLevelsMat, v0MagsLevels]=loadScenarios(BaseNetwork.Bus.Phases,BaseNetwork.Bus.SLoad,Ml,LoadLevelMin, LoadLevelMax, v0MagMin, v0MagMax);
% LoadLevels is an N-cell where N is the number of buses in the network
% Each cell n where 1<=n<=N is a L-Ml matrix where L is the number of phases of bus n.
% and  Ml indicates the number of load level scenarios. 
% LoadLevelsProbs is an Ml*1 vector indicating the probability of load
% level i, where 1<=i<=Ml. 


%% Initialize solar irradiances
[FgammaLevels, gammaLevelsProbs, FgammaLevelsMat]=solarScenarios(BaseNetwork.Bus.Phases,BaseNetwork.Bus.SLoad,Mg);
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


%% Compute voltage estimates
[BaseNetwork,ScenarioParams]=computevHat(BaseNetwork,ScenarioParams); 
% computes the required vHatEstimate per load level Ml
% The result will be the following field of the structure
% BaseNetwork.ScenarioParams
% 1) vS
% 2) vHat  (Ml-cell of the v estimates per phase)
% 3)vHat3Phase (Ml-cell of the v estimates organized in a matrix where rows
% are bus numbers and columns are phases) 
% 4) vHatMag (Ml-cell of the magnitude of the v estimates organized in a matrix where rows
% are bus numbers and columns are phases) 
% 5) vHatAngle (Ml-cell of the phase of the v estimates organized in a matrix where rows
% are bus numbers and columns are phases) 
% 6) GammaMatrix (Ml-cell)
% 7) PhiMatrix (Ml-cell)
% 8) nuVector (Ml-cell)
% an additional result of computevHat is 
% 1) Network.Y (Bus Admittance Matrix)
% 2) Network.w (no-load profile)
% 3)Network.w3Phase (no-load profile organized in three phases) 


BaseNetwork.Placement.ScenarioParams=ScenarioParams;
clear ScenarioParams;
%% Determine which locations are available for installation
[BaseNetwork.Bus] = determineL1PhiL3PhiSets( BaseNetwork.Bus );


%% Set optimization parameters
setOptParams;
BaseNetwork.OptParams=OptParams;
clear OptParams;