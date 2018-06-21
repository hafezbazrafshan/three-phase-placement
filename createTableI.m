MgValues=[1;5;25;200];
CurrentFolder=pwd;
ResultsFolder=['C:\Users\aju084\Documents\MATLAB\'...
'three-phase-pv-placement\IEEE 37-bus new modeling framework\Results\Finalized'];
Scale=10^6;





ColumnNames={'F', 'DK','Approach',...
    'CompTime','PlObj','SiObj','SiObjCr', 'Gap','Savings'}; %9 columns


TabulatedResults=[];


% 0. No DGs
cd(ResultsFolder);
FileName=['MISOCP', num2str(1)];
NoDg=load(FileName); 
cd(CurrentFolder);
NoDgCost=NoDg.PlacedNetwork.OptParams.ElectricityPrice...
    *real(sum(cell2mat(NoDg.PlacedNetwork.Placement.ScenarioParams.SInSol)))/3/Scale;
F=NaN;
DK=NaN;
Approach=0;
CompTime=0;
PlObj=NaN;
SiObj=NaN;
SiObjCr=NoDgCost;
Gap=NaN;
Savings=NaN;
NoDgRow={F, Approach, CompTime,PlObj, SiObj, SiObjCr,Gap,  Savings};
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
DK=DKValues(ii); 
Approach=1;
CompTime=SizedNetwork.Placement.TimeInfo(3)+SizedNetwork.Sizing.TimeInfo(3);
PlObj=SizedNetwork.Placement.Objective.Value/Scale;
SiObj=SizedNetwork.Sizing.Objective.Value/Scale;
SiObjCr=SizedNetwork.Sizing.Objective.ValueCorrected/Scale;
Gap=100*(SizedNetwork.Sizing.Objective.ValueCorrected-...
    Csdp.SizedNetwork.Placement.Objective.Value)/Csdp.SizedNetwork.Placement.Objective.Value;
Savings=100*(NoDgCost-SiObjCr)/ NoDgCost;

MisocpRow={F, DK, Approach, CompTime,PlObj, SiObj, SiObjCr,Gap, Savings};

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
DK=DKValues(ii); 
Approach=2;
CompTime=SizedNetwork.Placement.TimeInfo(3)+SizedNetwork.Sizing.TimeInfo(3);
PlObj=SizedNetwork.Placement.Objective.Value/Scale;
SiObj=SizedNetwork.Sizing.Objective.Value/Scale;
SiObjCr=SizedNetwork.Sizing.Objective.ValueCorrected/Scale;
Gap=100*(SizedNetwork.Sizing.Objective.ValueCorrected-Csdp.SizedNetwork.Placement.Objective.Value)/Csdp.SizedNetwork.Placement.Objective.Value;
Savings=100*(NoDgCost-SiObjCr)/ NoDgCost;


SocpRow={F, DK, Approach,CompTime,PlObj, SiObj, SiObjCr,Gap,  Savings};

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
DK=DKValues(ii); 
Approach=3;
CompTime=SizedNetwork.Placement.TimeInfo(3)+SizedNetwork.Sizing.TimeInfo(3);
PlObj=SizedNetwork.Placement.Objective.Value/Scale;
SiObj=SizedNetwork.Sizing.Objective.Value/Scale;
SiObjCr=SizedNetwork.Sizing.Objective.ValueCorrected/Scale;
Gap=100*(SizedNetwork.Sizing.Objective.ValueCorrected-SizedNetwork.Placement.Objective.Value)/SizedNetwork.Placement.Objective.Value;
Savings=100*(NoDgCost-SiObjCr)/ NoDgCost;


CsdpRow={F, DK, Approach,CompTime,PlObj, SiObj, SiObjCr,Gap,  Savings};

RowNames=[RowNames;FileName];
TabulatedResults=[TabulatedResults;CsdpRow];
clear Csdp CsdpRow



end


% OutputTable=table(cellfun(@(x) x, TabulatedResults(:,1)), cellfun(@(x) x, TabulatedResults(:,2)), ...
%     cellfun(@(x) x, TabulatedResults(:,3)),cellfun(@(x) x, TabulatedResults(:,4)), ...
%    cellfun(@(x) x, TabulatedResults(:,5)), cellfun(@(x) x, TabulatedResults(:,6)),...
%   cellfun(@(x) x, TabulatedResults(:,7)), cellfun(@(x) x, TabulatedResults(:,8)), ...
%   cellfun(@(x) x, TabulatedResults(:,9))); 
% OutputTable.Properties.VariableNames=ColumnNames;

OutputTable=cell2table(TabulatedResults,'VariableNames',ColumnNames,'RowNames',RowNames)

% MyTable=table2array(OutputTable); 
% MyTable=array2table(MyTable.');
% MyTable.Properties.RowNames=OutputTable.Properties.VariableNames;
% MyTable.Properties.VariableNames=OutputTable.Properties.RowNames;

input.data=OutputTable;
input.dataFormat = {'%d',1, '%.4f%', 1,'%d',1,...
    '%.2f',1,'%.3f',3, '%.2f', 2}
input.dataFormatMode = 'column';
input.makeCompleteLatexDocument = 0;
% LaTex table caption:
input.tableCaption = 'Optimization comparison of MISOCP, SOCP, and CSDP';

% LaTex table label:
input.tableLabel = 'Table:OptCompare';

FID=fopen('TableI.txt','w'); 
 latex = latexTable(input);
 fclose(FID);

