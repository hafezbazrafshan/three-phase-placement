function [Network] = sizeDGsCSDPVectorized(Network)
defineCommonOptimizationParameters;
defineFirstStageScenarioParams;
defineCVXSettings;
cvx_begin sdp
defineInverterSizingVariables;
defineInjectionVariables;
defineSDPWVariables;

% objective
defineObjective;

subject to:
% constraints
definepRsRSizingConstraints; 
defineInverterOperationConstraints;
map1Phi3PhiInjections;

defineWVoltageRegulationVectorized;
definePowerFlowsChordalVectorized;






cvx_end


Network.Sizing.TimeInfo=cvx_toc;
outputSizingVariables;
outputInjectionVariables;
outputCorrectedVoltages;

Variables.Wnn3Phi=Wnn3Phi;
Variables.W3Phi=W3Phi;
Network.Sizing.Variables=Variables;


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

