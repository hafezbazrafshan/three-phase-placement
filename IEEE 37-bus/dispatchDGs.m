function [Network] = dispatchDGs(Network)
% the input network must be a sized network
defineCommonOptimizationParameters;
defineDispatchScenarioParams;
defineCVXSettings;


cvx_begin sdp quiet
setInverterSizingVariables;
defineInjectionVariables;
defineSDPWVariables;


% objective
defineDispatchObjective;

subject to:
% constraints
defineInverterOperationConstraints;
map1Phi3PhiInjections;

% just in case we wanted to lump several dispatches together
defineWVoltageRegulationVectorized;
definePowerFlowsChordalVectorized;









cvx_end


outputInjectionVariables;
outputCorrectedVoltages;

Network.Dispatch.TimeInfo=cvx_toc;
Network.Dispatch.Variables=Variables;

Variables.pg=[];
Variables.qg=[];


Network.Dispatch.Objective.Value=Objective;
Network.Dispatch.Objective.SecondStageCost.ElectricityCost=ElectricityCost;
Network.Dispatch.Objective.SecondStageCost.CurtailmentCost=CurtailmentCost;
Network.Dispatch.Objective.SecondStageCost.Value=Objective;



Network.Dispatch.Objective.ValueCorrected=SecondStageCostCorrected;
Network.Dispatch.Objective.SecondStageCost.ValueCorrected=SecondStageCostCorrected;
Network.Dispatch.Objective.SecondStageCost.ElectricityCostCorrected=ElectricityCostCorrected;



end

