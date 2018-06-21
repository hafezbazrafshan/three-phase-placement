function DispatchNetwork=dispatchDGsLinear(SizedNetwork)

DispatchNetwork=SizedNetwork;

NewMg=4745;
DispatchNetwork.Dispatch.ScenarioParams=DispatchNetwork.Placement.ScenarioParams;  % set initial loads but update the solar
[FgammaLevels, gammaLevelsProbs, FgammaLevelsMat]=solarScenarios(DispatchNetwork.Bus.Phases,DispatchNetwork.Bus.SLoad,NewMg);



DispatchNetwork.Dispatch.ScenarioParams.FgammaLevels=FgammaLevels;
DispatchNetwork.Dispatch.ScenarioParams.gammaLevelsProbs=gammaLevelsProbs;
DispatchNetwork.Dispatch.ScenarioParams.FgammaLevelsMat=FgammaLevelsMat;
DispatchNetwork.Dispatch.ScenarioParams.Mg=NewMg;
DispatchNetwork.Dispatch.ScenarioParams.ScenarioProbs=DispatchNetwork.Dispatch.ScenarioParams.LoadLevelsProbs*gammaLevelsProbs.';  % linear index is the scenario number
DispatchNetwork.Dispatch.ScenarioProbs.M=NewMg*DispatchNetwork.Dispatch.ScenarioParams.Ml;


% finds the closest smaller scenario from fGammaLevels to validationData

ScenarioIndex=zeros(NewMg,1); 

for ii=1:NewMg
    
    set1=abs(repmat(FgammaLevels{1}(1,ii),1,DispatchNetwork.Placement.ScenarioParams.Mg)-DispatchNetwork.Placement.ScenarioParams.FgammaLevels{1}(1,:));
    [~,idx]=min(set1);
    ScenarioIndex(ii)=idx;
end



c1Phi=zeros(size(DispatchNetwork.Sizing.Variables.c1Phi,1),NewMg);
c3Phi=zeros(size(DispatchNetwork.Sizing.Variables.c3Phi,1),NewMg);
pg1Phi=zeros(size(DispatchNetwork.Sizing.Variables.pg1Phi,1),NewMg);
pg3Phi=zeros(size(DispatchNetwork.Sizing.Variables.pg3Phi,1),NewMg);
qgPhi=zeros(size(DispatchNetwork.Sizing.Variables.qg1Phi,1),NewMg);
qgPhi=zeros(size(DispatchNetwork.Sizing.Variables.qg1Phi,1),NewMg);
vCorrected=zeros(size(DispatchNetwork.Sizing.Variables.vCorrected,1),NewMg);
SInCorrected=zeros(size(DispatchNetwork.Sizing.Variables.SInCorrected,1),NewMg);



t1=tic;
parfor m=1:DispatchNetwork.Placement.ScenarioParams.Ml*NewMg
str=['Running dispatch No, ', num2str(m), '\n'];
    fprintf(str); 
    
     [ml,mg]=ind2sub([DispatchNetwork.Placement.ScenarioParams.Ml,NewMg], m);
     
     mgSelected= (ScenarioIndex(mg)-1)*DispatchNetwork.Placement.ScenarioParams.Ml+ml;
   
     pg1PhiSlice=min([DispatchNetwork.Sizing.Variables.pg1Phi(:,mgSelected),...
         DispatchNetwork.Sizing.Variables.pR1Phi.*DispatchNetwork.Dispatch.ScenarioParams.FgammaLevels{1}(1,mg)],[],2);
      pg3PhiSlice=min([DispatchNetwork.Sizing.Variables.pg3Phi(:,mgSelected),...
       DispatchNetwork.Sizing.Variables.pR3Phi.*DispatchNetwork.Dispatch.ScenarioParams.FgammaLevels{1}(1,mg)],[],2);
     
      c1PhiSlice=DispatchNetwork.Sizing.Variables.pR1Phi.*DispatchNetwork.Dispatch.ScenarioParams.FgammaLevels{1}(1,mg)-...
         pg1PhiSlice;
      c3PhiSlice=DispatchNetwork.Sizing.Variables.pR3Phi.*DispatchNetwork.Dispatch.ScenarioParams.FgammaLevels{1}(1,mg)-...
          pg3PhiSlice;
      
     qg1PhiSlice=  DispatchNetwork.Sizing.Variables.qg1Phi(:,mgSelected);
               qg3PhiSlice=  DispatchNetwork.Sizing.Variables.qg3Phi(:,mgSelected);
                
               
                NPhases=length(DispatchNetwork.Bus.NonZeroPhaseNumbers);
                M=1;
                L1PhiSetVec=DispatchNetwork.Bus.PlacementLocations.L1PhiSetVec;
                N3Phi=DispatchNetwork.Bus.PlacementLocations.N3Phi;
                L3PhiSet=DispatchNetwork.Bus.PlacementLocations.L3PhiSet;
                pg=zeros(NPhases,M);  % ensures zero at nodes without installation
                qg=zeros(NPhases,M);
                pg(L1PhiSetVec)=pg1PhiSlice;
                qg(L1PhiSetVec)=qg1PhiSlice;
                
                for n=1:N3Phi
                    pg(L3PhiSet{n})=pg(L3PhiSet{n})+repmat(pg3PhiSlice(n),3,1);
                    qg(L3PhiSet{n})=qg(L3PhiSet{n})+repmat(qg3PhiSlice(n),3,1);
                    
                end
                
     
            SLoadVec=DispatchNetwork.Dispatch.ScenarioParams.LoadLevelsMat(1:end-3,ml).*DispatchNetwork.Bus.SLoadVec(1:end-3)-pg(1:end-3)-sqrt(-1)*qg(1:end-3);
    vCorrectedSlice=[performZBus( ...
        DispatchNetwork.Dispatch.ScenarioParams.w{ml}, SLoadVec, DispatchNetwork.Y, DispatchNetwork.YNS, 40, DispatchNetwork.Dispatch.ScenarioParams.vS{ml});...
        DispatchNetwork.Dispatch.ScenarioParams.vS{ml}];
    
    
   SInCorrectedSlice=diag(DispatchNetwork.Dispatch.ScenarioParams.vS{ml})*...
        (conj(DispatchNetwork.YSN*vCorrectedSlice(1:end-3))+...
    conj(DispatchNetwork.YSS*DispatchNetwork.Dispatch.ScenarioParams.vS{ml}));

c1Phi(:,m)=c1PhiSlice;
c3Phi(:,m)=c3PhiSlice;
pg1Phi(:,m)=pg1PhiSlice;
pg3Phi(:,m)=pg3PhiSlice;
qg1Phi(:,m)=qg1PhiSlice;
qg3Phi(:,m)=qg3PhiSlice;
vCorrected(:,m)=vCorrectedSlice;
SInCorrected(:,m)=SInCorrectedSlice;
    
end


DispatchNetwork.Dispatch.Variables.c1Phi=c1Phi;
DispatchNetwork.Dispatch.Variables.c3Phi=c3Phi;

DispatchNetwork.Dispatch.Variables.pg1Phi=pg1Phi;
DispatchNetwork.Dispatch.Variables.pg3Phi=pg3Phi;
DispatchNetwork.Dispatch.Variables.qg1Phi=qg1Phi;
DispatchNetwork.Dispatch.Variables.qg3Phi=qg3Phi;
DispatchNetwork.Dispatch.Variables.vCorrected=vCorrected;
DispatchNetwork.Dispatch.Variables.SInCorrected=SInCorrected;
DispatchNetwork.Dispatch.Objective.SecondStageCost.ElectricityCostCorrected=DispatchNetwork.OptParams.ElectricityPrice*...
    sum(real(DispatchNetwork.Dispatch.Variables.SInCorrected))*DispatchNetwork.Dispatch.ScenarioParams.ScenarioProbs(:);
DispatchNetwork.Dispatch.Objective.SecondStageCost.CurtailmentCost=DispatchNetwork.OptParams.CurtailmentPrice*...
    (sum(DispatchNetwork.Dispatch.Variables.c1Phi)+3*sum(DispatchNetwork.Dispatch.Variables.c3Phi))*DispatchNetwork.Dispatch.ScenarioParams.ScenarioProbs(:);
DispatchNetwork.Dispatch.Objective.SecondStageCost.ValueCorrected=DispatchNetwork.Dispatch.Objective.SecondStageCost.ElectricityCostCorrected+...
    DispatchNetwork.Dispatch.Objective.SecondStageCost.CurtailmentCost;


t2=toc(t1);
