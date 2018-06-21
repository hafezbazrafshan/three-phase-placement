function [Network] = placeSizeDGsLinear(Network,NL)
defineCommonOptimizationParameters;
defineFirstStageScenarioParams;
defineCVXSettings;

cvx_begin
defineInverterPlacementVariablesBinary;
defineInverterSizingVariables;
defineInjectionVariables;
variable  v(NPhases,M) complex

% objective
defineObjective;

subject to:
% constraints
defineb1Phib3PhiConstraints; 
definepRsRConstraints;
defineInverterOperationLinearConstraints;
defineVoltageRegulationLinearConstraints;
map1Phi3PhiInjections;
definePowerFlowsLinearConstraint;







cvx_end


% placeSizeCheckConstraints;
outputPlacementVariables;
outputSizingVariables;
outputInjectionVariables;
Variables.v=v;
outputCorrectedVoltages;




Network.Placement.Variables=Variables;
% Network.Placement.Constraints=Constraints;
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

