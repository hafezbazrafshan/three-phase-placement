MgValues=[1;5;25;200];
DKValues=[0.2224;0.0474; 0.0089];
CurrentFolder=pwd;
ResultsFolder='IEEE 37-bus/Results/';
Scale=10^6;




ColumnNames={'F', 'Approach', 'CompTime','PlObj','SiObj','SiObjCr', 'Gap',....
        'FiCost','SeCost', 'ElCost','CuCost',...
        'SumpR', 'NoDGs', 'MaxpR', 'MinpR', 'AvgDCToAC',...
    'DVmax', 'ValTotCost', 'ValElCost', 'ValCurtCost', 'ValDVmax', 'Savings'};


TabulatedResults=[];


% 0. No DGs
cd(ResultsFolder);
FileName=['MISOCP', num2str(1)];
NoDg=load(FileName); 
cd(CurrentFolder);
NoDgCost=NoDg.PlacedNetwork.OptParams.ElectricityPrice...
    *real(sum(cell2mat(NoDg.PlacedNetwork.Placement.ScenarioParams.SInSol)))/3/Scale;
F=0;
CompTime=0;
PlObj=0;
SiObj=0;
SiObjCr=NoDg.PlacedNetwork.OptParams.ElectricityPrice*real(sum(cell2mat(NoDg.PlacedNetwork.Placement.ScenarioParams.SInSol)))/3/Scale;
Gap=NaN;
Approach=0;
SumpR=0; 
NoDGs=0;
MaxpR=0;
MinpR=0;
AvgDCToAC=0;
FiCost=0;
SeCost=SiObjCr;
ElCost=SiObjCr;
CuCost=0;
Vmin=min(abs(cell2mat(NoDg.PlacedNetwork.Placement.ScenarioParams.vSol)));
Vmax=max(abs(cell2mat(NoDg.PlacedNetwork.Placement.ScenarioParams.vSol)));
DVmax=max([pos(Vmax-1.1), pos(0.9-Vmin)]); 
ValTotCost=SiObjCr;
ValElCost=SiObjCr;
ValCuCost=0;
ValVmin=min(abs(cell2mat(NoDg.PlacedNetwork.Placement.ScenarioParams.vSol)));
ValVmax=max(abs(cell2mat(NoDg.PlacedNetwork.Placement.ScenarioParams.vSol)));
ValDVmax=max([pos(ValVmax-1.1),pos(0.9-ValVmin)]);Savings=NaN;

NoDgRow={F,  Approach, CompTime,PlObj, SiObj, SiObjCr,Gap,  FiCost, SeCost, ElCost, CuCost,SumpR, NoDGs, MaxpR, MinpR,...
    AvgDCToAC, DVmax, ValTotCost,ValElCost,ValCuCost,ValDVmax,Savings};

TabulatedResults=[TabulatedResults;NoDgRow];

clear NoDg;

RowNames={'NoDg'};




for ii=1:length(MgValues)
    
    Mg=MgValues(ii); 
    
    
    
    
    % 1. Analyze MISOCP
FileName=['MISOCP', num2str(Mg)];
cd(ResultsFolder); 
Misocp=load(FileName); 
FileName2=['CSDP', num2str(Mg)];
Csdp=load(FileName2); 
cd(CurrentFolder); 
SizedNetwork=Misocp.SizedNetwork;
DispatchNetwork=Misocp.DispatchNetwork;
F=Mg;
Approach=1;
CompTime=SizedNetwork.Placement.TimeInfo(3)+SizedNetwork.Sizing.TimeInfo(3);
PlObj=SizedNetwork.Placement.Objective.Value/Scale;
SiObj=SizedNetwork.Sizing.Objective.Value/Scale;
SiObjCr=SizedNetwork.Sizing.Objective.ValueCorrected/Scale;
Gap=100*(SizedNetwork.Sizing.Objective.ValueCorrected-Csdp.SizedNetwork.Placement.Objective.Value)/Csdp.SizedNetwork.Placement.Objective.Value;
SumpR=sum(SizedNetwork.Sizing.Variables.pR1Phi(:))+3*sum(SizedNetwork.Sizing.Variables.pR3Phi(:)); 
NoDGs=sum(SizedNetwork.Placement.Variables.b1Phi)+sum(SizedNetwork.Placement.Variables.b3Phi); 
MaxpR=max(max(SizedNetwork.Placement.Variables.pR1Phi),max(SizedNetwork.Placement.Variables.pR3Phi));
MinpR=min(min(SizedNetwork.Placement.Variables.pR1Phi(SizedNetwork.Placement.Variables.b1Phi==1)),...
    min(SizedNetwork.Placement.Variables.pR3Phi(SizedNetwork.Placement.Variables.b3Phi==1)));
AvgDCToAC=(sum(SizedNetwork.Sizing.Variables.pR1Phi(SizedNetwork.Sizing.Variables.sR1Phi~=0)./...
    SizedNetwork.Sizing.Variables.sR1Phi(SizedNetwork.Sizing.Variables.sR1Phi~=0))+...
+sum(SizedNetwork.Sizing.Variables.pR3Phi(SizedNetwork.Sizing.Variables.sR3Phi~=0)./...
SizedNetwork.Sizing.Variables.sR3Phi(SizedNetwork.Sizing.Variables.sR3Phi~=0)))./...
(sum(SizedNetwork.Placement.Variables.b1Phi)+sum(SizedNetwork.Placement.Variables.b3Phi));
FiCost=SizedNetwork.Sizing.Objective.FirstStageCost.Value/Scale;
SeCost=SizedNetwork.Sizing.Objective.SecondStageCost.ValueCorrected/Scale;
ElCost=SizedNetwork.Sizing.Objective.SecondStageCost.ElectricityCostCorrected/Scale;
CuCost=SizedNetwork.Sizing.Objective.SecondStageCost.CurtailmentCost/Scale;
Vmin=min(abs(SizedNetwork.Sizing.Variables.vCorrected(:)));
Vmax=max(abs(SizedNetwork.Sizing.Variables.vCorrected(:)));
DVmax=max([pos(Vmax-1.1), pos(0.9-Vmin)]); 
ValTotCost=(DispatchNetwork.Sizing.Objective.FirstStageCost.Value+DispatchNetwork.Dispatch.Objective.SecondStageCost.ValueCorrected)/Scale;
ValElCost=DispatchNetwork.Dispatch.Objective.SecondStageCost.ElectricityCostCorrected/Scale;
ValCuCost=DispatchNetwork.Dispatch.Objective.SecondStageCost.CurtailmentCost/Scale;
ValVmin=min(abs(DispatchNetwork.Dispatch.Variables.vCorrected(:)));
ValVmax=max(abs(DispatchNetwork.Dispatch.Variables.vCorrected(:)));
ValDVmax=max([pos(ValVmax-1.1),pos(0.9-ValVmin)]);
Savings=100*(NoDgCost-ValTotCost)/ NoDgCost;


MisocpRow={F, Approach,CompTime,PlObj, SiObj, SiObjCr,Gap,  FiCost, SeCost, ElCost, CuCost,SumpR,NoDGs, MaxpR, MinpR, AvgDCToAC,...
    DVmax, ValTotCost,ValElCost,ValCuCost,ValDVmax,Savings};

RowNames=[RowNames;FileName];
TabulatedResults=[TabulatedResults;MisocpRow];
clear Misocp MisocpRow Csdp





%%
FileName=['SOCP', num2str(Mg)];
cd(ResultsFolder); 
Socp=load(FileName); 
FileName2=['CSDP', num2str(Mg)];
Csdp=load(FileName2); 
cd(CurrentFolder); 
SizedNetwork=Socp.SizedNetwork;
DispatchNetwork=Socp.DispatchNetwork;
F=Mg;
Approach=2;
CompTime=SizedNetwork.Placement.TimeInfo(3)+SizedNetwork.Sizing.TimeInfo(3);
PlObj=SizedNetwork.Placement.Objective.Value/Scale;
SiObj=SizedNetwork.Sizing.Objective.Value/Scale;
SiObjCr=SizedNetwork.Sizing.Objective.ValueCorrected/Scale;
Gap=100*(SizedNetwork.Sizing.Objective.ValueCorrected-Csdp.SizedNetwork.Placement.Objective.Value)/Csdp.SizedNetwork.Placement.Objective.Value;
SumpR=sum(SizedNetwork.Sizing.Variables.pR1Phi(:))+3*sum(SizedNetwork.Sizing.Variables.pR3Phi(:)); 
NoDGs=sum(SizedNetwork.Placement.Variables.b1Phi)+sum(SizedNetwork.Placement.Variables.b3Phi); 
MaxpR=max(max(SizedNetwork.Placement.Variables.pR1Phi),max(SizedNetwork.Placement.Variables.pR3Phi));
MinpR=min(min(SizedNetwork.Placement.Variables.pR1Phi(SizedNetwork.Placement.Variables.b1Phi==1)),...
    min(SizedNetwork.Placement.Variables.pR3Phi(SizedNetwork.Placement.Variables.b3Phi==1)));
AvgDCToAC=(sum(SizedNetwork.Sizing.Variables.pR1Phi(SizedNetwork.Sizing.Variables.sR1Phi~=0)./...
    SizedNetwork.Sizing.Variables.sR1Phi(SizedNetwork.Sizing.Variables.sR1Phi~=0))+...
+sum(SizedNetwork.Sizing.Variables.pR3Phi(SizedNetwork.Sizing.Variables.sR3Phi~=0)./...
SizedNetwork.Sizing.Variables.sR3Phi(SizedNetwork.Sizing.Variables.sR3Phi~=0)))./...
(sum(SizedNetwork.Placement.Variables.b1Phi)+sum(SizedNetwork.Placement.Variables.b3Phi));
FiCost=SizedNetwork.Sizing.Objective.FirstStageCost.Value/Scale;
SeCost=SizedNetwork.Sizing.Objective.SecondStageCost.ValueCorrected/Scale;
ElCost=SizedNetwork.Sizing.Objective.SecondStageCost.ElectricityCostCorrected/Scale;
CuCost=SizedNetwork.Sizing.Objective.SecondStageCost.CurtailmentCost/Scale;
Vmin=min(abs(SizedNetwork.Sizing.Variables.vCorrected(:)));
Vmax=max(abs(SizedNetwork.Sizing.Variables.vCorrected(:)));
DVmax=max([pos(Vmax-1.1), pos(0.9-Vmin)]); 
ValTotCost=(DispatchNetwork.Sizing.Objective.FirstStageCost.Value+DispatchNetwork.Dispatch.Objective.SecondStageCost.ValueCorrected)/Scale;
ValElCost=DispatchNetwork.Dispatch.Objective.SecondStageCost.ElectricityCostCorrected/Scale;
ValCuCost=DispatchNetwork.Dispatch.Objective.SecondStageCost.CurtailmentCost/Scale;
ValVmin=min(abs(DispatchNetwork.Dispatch.Variables.vCorrected(:)));
ValVmax=max(abs(DispatchNetwork.Dispatch.Variables.vCorrected(:)));
ValDVmax=max([pos(ValVmax-1.1),pos(0.9-ValVmin)]);
Savings=100*(NoDgCost-ValTotCost)/ NoDgCost;


SocpRow={F, Approach, CompTime,PlObj, SiObj, SiObjCr,Gap,  FiCost, SeCost, ElCost, CuCost,SumpR,NoDGs, MaxpR, MinpR, ...
    AvgDCToAC,...
    DVmax, ValTotCost,ValElCost,ValCuCost,ValDVmax,Savings};

RowNames=[RowNames;FileName];
TabulatedResults=[TabulatedResults;SocpRow];
clear Socp SocpRow Csdp





%%  2. Do CSDP
cd(ResultsFolder); 
FileName=['CSDP', num2str(Mg)];
Csdp=load(FileName); 
cd(CurrentFolder);

SizedNetwork=Csdp.SizedNetwork;
DispatchNetwork=Csdp.DispatchNetwork;

F=Mg;
Approach=3;
CompTime=SizedNetwork.Placement.TimeInfo(3)+SizedNetwork.Sizing.TimeInfo(3);
PlObj=SizedNetwork.Placement.Objective.Value/Scale;
SiObj=SizedNetwork.Sizing.Objective.Value/Scale;
SiObjCr=SizedNetwork.Sizing.Objective.ValueCorrected/Scale;
Gap=100*(SizedNetwork.Sizing.Objective.ValueCorrected-SizedNetwork.Placement.Objective.Value)/SizedNetwork.Placement.Objective.Value;
SumpR=sum(SizedNetwork.Sizing.Variables.pR1Phi(:))+3*sum(SizedNetwork.Sizing.Variables.pR3Phi(:)); 
NoDGs=sum(SizedNetwork.Placement.Variables.b1Phi)+sum(SizedNetwork.Placement.Variables.b3Phi); 
MaxpR=max(max(SizedNetwork.Placement.Variables.pR1Phi),max(SizedNetwork.Placement.Variables.pR3Phi));
MinpR=min(min(SizedNetwork.Placement.Variables.pR1Phi(SizedNetwork.Placement.Variables.b1Phi==1)),...
    min(SizedNetwork.Placement.Variables.pR3Phi(SizedNetwork.Placement.Variables.b3Phi==1)));
AvgDCToAC=(sum(SizedNetwork.Sizing.Variables.pR1Phi(SizedNetwork.Sizing.Variables.sR1Phi~=0)./...
    SizedNetwork.Sizing.Variables.sR1Phi(SizedNetwork.Sizing.Variables.sR1Phi~=0))+...
+sum(SizedNetwork.Sizing.Variables.pR3Phi(SizedNetwork.Sizing.Variables.sR3Phi~=0)./...
SizedNetwork.Sizing.Variables.sR3Phi(SizedNetwork.Sizing.Variables.sR3Phi~=0)))./...
(sum(SizedNetwork.Placement.Variables.b1Phi)+sum(SizedNetwork.Placement.Variables.b3Phi));
FiCost=SizedNetwork.Sizing.Objective.FirstStageCost.Value/Scale;
SeCost=SizedNetwork.Sizing.Objective.SecondStageCost.ValueCorrected/Scale;
ElCost=SizedNetwork.Sizing.Objective.SecondStageCost.ElectricityCostCorrected/Scale;
CuCost=SizedNetwork.Sizing.Objective.SecondStageCost.CurtailmentCost/Scale;
Vmin=min(abs(SizedNetwork.Sizing.Variables.vCorrected(:)));
Vmax=max(abs(SizedNetwork.Sizing.Variables.vCorrected(:)));
DVmax=max([pos(Vmax-1.1), pos(0.9-Vmin)]); 
ValTotCost=(DispatchNetwork.Sizing.Objective.FirstStageCost.Value+DispatchNetwork.Dispatch.Objective.SecondStageCost.ValueCorrected)/Scale;

ValElCost=DispatchNetwork.Dispatch.Objective.SecondStageCost.ElectricityCostCorrected/Scale;
ValCuCost=DispatchNetwork.Dispatch.Objective.SecondStageCost.CurtailmentCost/Scale;
ValVmin=min(abs(DispatchNetwork.Dispatch.Variables.vCorrected(:)));
ValVmax=max(abs(DispatchNetwork.Dispatch.Variables.vCorrected(:)));
ValDVmax=max([pos(ValVmax-1.1),pos(0.9-ValVmin)]);
Savings=100*(NoDgCost-ValTotCost)/ NoDgCost;


CsdpRow={F, Approach, CompTime,PlObj, SiObj, SiObjCr,Gap,  FiCost, SeCost, ElCost, CuCost,SumpR, NoDGs, MaxpR, MinpR, AvgDCToAC,...
    DVmax, ValTotCost,ValElCost,ValCuCost,ValDVmax,Savings};
RowNames=[RowNames;FileName];
TabulatedResults=[TabulatedResults;CsdpRow];
clear Csdp CsdpRow



end



OutputTable=cell2table(TabulatedResults,'VariableNames',ColumnNames,'RowNames',RowNames)

MyTable=table2array(OutputTable); 
MyTable=array2table(MyTable.');
MyTable.Properties.RowNames=OutputTable.Properties.VariableNames;
MyTable.Properties.VariableNames=OutputTable.Properties.RowNames;

input.data=MyTable;
input.dataFormat = {'%d',2, '%.2f%', 1,'%.2f',3, '%.2f',1, '%.2f',4, '%.4f', 1, '%d',1, '%.4f',2, '%.2f',2, '%.2f', 3, '%.2f',2 }
input.dataFormatMode = 'row';
 latex = latexTable(input);

