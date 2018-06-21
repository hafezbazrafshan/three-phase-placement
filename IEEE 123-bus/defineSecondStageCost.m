
ElectricityCost=ElectricityPrice*sum(real(SIn))*ScenarioProbs(:);
CurtailmentCost=CurtailmentPrice*(sum(c1Phi)+3*sum(c3Phi))*ScenarioProbs(:);

SecondStageCost=ElectricityCost+CurtailmentCost;
