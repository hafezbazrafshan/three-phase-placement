function [Network] = sizeDGs(Network)
defineCommonOptimizationParameters;
defineFirstStageScenarioParams;
defineCVXSettings;
cvx_begin
defineInverterSizingVariables;
defineInjectionVariables;
variable  v(NPhases,M) complex

% objective
defineObjective;

subject to:
% constraints
definepRsRSizingConstraints; 
defineInverterOperationConstraints;
defineVoltageRegulationConstraints;
map1Phi3PhiInjections;
definePowerFlowsLinearConstraint;







cvx_end

Network.Sizing.TimeInfo=cvx_toc;
% sizeCheckConstraints;
outputSizingVariables;
outputInjectionVariables;
Variables.v=v;
outputCorrectedVoltages;


Network.Sizing.Variables=Variables;
% Network.Sizing.Constraints=Constraints;


Network.Sizing.Objective.Value=Objective;
Network.Sizing.Objective.FirstStageCost.Value=FirstStageCost;
Network.Sizing.Objective.FirstStageCost.pRCost=pRCost;
Network.Sizing.Objective.FirstStageCost.sRCost=sRCost;
Network.Sizing.Objective.SecondStageCost.Value=SecondStageCost;
Network.Sizing.Objective.SecondStageCost.ElectricityCost=ElectricityCost;
Network.Sizing.Objective.SecondStageCost.CurtailmentCost=CurtailmentCost;

Network.Sizing.Objective.ValueCorrected=FirstStageCost+SecondStageCostCorrected;
Network.Sizing.Objective.SecondStageCost.ValueCorrected=SecondStageCostCorrected;
Network.Sizing.Objective.SecondStageCost.ElectricityCostCorrected=ElectricityCostCorrected;



end

