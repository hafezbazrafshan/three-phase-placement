function [Network] = placeSizeDGsBFSDP(Network)
defineCommonOptimizationParameters;
defineFirstStageScenarioParams;
defineCVXSettings;


cvx_begin sdp
defineInverterPlacementVariablesContinuous;
defineInverterSizingVariables;
defineInjectionVariables;
defineSDPVVariables;
% objective
defineObjective;

subject to:
% constraints
defineb1Phib3PhiConstraints; 
definepRsRConstraints;
defineInverterOperationConstraints;
map1Phi3PhiInjections;
% for ms=1:M
%       [ml,~]=ind2sub([Ml,Mg], ms);
% defineWVoltageRegulationConstraints;
% end

for ms=1:M
    [ml,~]=ind2sub([Ml,Mg], ms);
defineBFVoltages;
definePowerFlowsBF;
end






cvx_end


Network.Placement.TimeInfo=cvx_toc;
% placeSizeCheckConstraints;
outputPlacementVariables;
outputSizingVariables;
outputInjectionVariables;
outputCorrectedVoltages;




Network.Placement.Variables=Variables;
Network.Bus=determineSelectedLocations(Network.Bus,...
   Network.Placement.Variables.b1Phi,Network.Placement.Variables.b3Phi);

Network.Placement.Objective.Value=Objective;
Network.Placement.Objective.FirstStageCost.Value=FirstStageCost;
Network.Placement.Objective.FirstStageCost.pRCost=pRCost;
Network.Placement.Objective.FirstStageCost.sRCost=sRCost;
Network.Placement.Objective.SecondStageCost.Value=SecondStageCost;
Network.Placement.Objective.SecondStageCost.ElectricityCost=ElectricityCost;
Network.Placement.Objective.SecondStageCost.CurtailmentCost=CurtailmentCost;
Network.Placement.Objective.ValueCorrected=FirstStageCost+SecondStageCostCorrected;
Network.Placement.Objective.SecondStageCost.ValueCorrected=SecondStageCostCorrected;
Network.Placement.Objective.SecondStageCost.ElectricityCostCorrected=ElectricityCostCorrected;




end

