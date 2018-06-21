Variables.vCorrected=zeros(NPhases,M);
fprintf('Recovering correct voltages that satisfy the load-flow'); 
for m=1:M
   [ml,~]=ind2sub([Ml,Mg], m);
   
   SLoadVec=ScenarioParams.LoadLevelsMat(1:end-3,ml).*Network.Bus.SLoadVec(1:end-3)-pg(1:end-3,m)-sqrt(-1)*qg(1:end-3,m);
    Variables.vCorrected(1:end-3,m)=performZBus( ScenarioParams.w{ml}, SLoadVec, Network.Y, Network.YNS, 40, ScenarioParams.vS{ml});
    
    Variables.vCorrected(end-2:end,m)=ScenarioParams.vS{ml};

end
Variables.SInCorrected=zeros(size(SIn));
Variables.SInCorrected(:)=vec(pg(end-2:end,:)+sqrt(-1)*qg(end-2:end,:))+...
 kron(speye(Mg),PhiSMatBlockMl)*conj(vec(Variables.vCorrected(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg)))+...
repmat(cell2mat(ScenarioParams.nuSVector),Mg,1);

ElectricityCostCorrected=ElectricityPrice*sum(real(Variables.SInCorrected))*ScenarioProbs(:);
SecondStageCostCorrected=ElectricityCostCorrected+CurtailmentCost;



