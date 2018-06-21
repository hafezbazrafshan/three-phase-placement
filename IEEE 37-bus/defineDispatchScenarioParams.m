ScenarioParams=Network.Dispatch.ScenarioParams;
M=ScenarioParams.M;
Ml=ScenarioParams.Ml;
Mg=ScenarioParams.Mg;
vHat=ScenarioParams.vHat;
GammaMatrix=ScenarioParams.GammaMatrix;
PhiMatrix=ScenarioParams.PhiMatrix;
nuVector=ScenarioParams.nuVector;
PhiSMatrix=ScenarioParams.PhiSMatrix;
nuSVector=ScenarioParams.nuSVector;
ScenarioProbs=ScenarioParams.ScenarioProbs;


GammaMatBlockMl=[];
PhiMatBlockMl=[];
PhiSMatBlockMl=[];
for ml=1:Ml
GammaMatBlockMl=blkdiag(GammaMatBlockMl,GammaMatrix{ml}); 
PhiMatBlockMl=blkdiag(PhiMatBlockMl,PhiMatrix{ml}); 
PhiSMatBlockMl=blkdiag(PhiSMatBlockMl,PhiSMatrix{ml});
end