MgValues=[5];

for ii=1:length(MgValues)
Mg=MgValues(ii);
Method='SOCP';

CurrentFolder=pwd;
ResultsFolder='IEEE 8500-bus/Results/';

cd(ResultsFolder)
CaseFileName=[Method,num2str(Mg)];
CaseFile=load(CaseFileName); 
cd(CurrentFolder); 







%% Allocate correct indices
NBuses=length(CaseFile.PlacedNetwork.Bus.Names);

pR1PhiMat=NaN(3,NBuses); 
sR1PhiMat=NaN(3,NBuses); 

SLoadMat=zeros(3,NBuses); 

SLoadMat(CaseFile.PlacedNetwork.Bus.NonZeroPhaseNumbers)=CaseFile.PlacedNetwork.Bus.SLoadVec;

SLoadMat=SLoadMat.';

pR1PhiMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.L1PhiSetVec)=CaseFile.SizedNetwork.Sizing.Variables.pR1Phi;
sR1PhiMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.L1PhiSetVec)=CaseFile.SizedNetwork.Sizing.Variables.sR1Phi;

pR1PhiMat=pR1PhiMat.';
sR1PhiMat=sR1PhiMat.';
pRMat=[pR1PhiMat,NaN(NBuses,1)];
sRMat=[sR1PhiMat,NaN(NBuses,1)];
pRMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.N3PhiSet,4)=3*CaseFile.SizedNetwork.Sizing.Variables.pR3Phi;
sRMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.N3PhiSet,4)=3*CaseFile.SizedNetwork.Sizing.Variables.sR3Phi;



pR1PhiMat=pR1PhiMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.N1PhiSet,:); 
sR1PhiMat=sR1PhiMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.N1PhiSet,:); 
pRMat=pRMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.N1PhiSet,:);
sRMat=sRMat(CaseFile.PlacedNetwork.Bus.PlacementLocations.N1PhiSet,:);

DCToAC1PhiMat=NaN(size(pR1PhiMat));
DCToAC1PhiMat(and(sR1PhiMat~=0,~isnan(sR1PhiMat)))=pR1PhiMat(and(sR1PhiMat~=0 ,~isnan(sR1PhiMat)))...
    ./sR1PhiMat(and(sR1PhiMat~=0 , ~isnan(sR1PhiMat)));

pR3PhiMat=repmat(CaseFile.SizedNetwork.Sizing.Variables.pR3Phi,1,3); 
sR3PhiMat=repmat(CaseFile.SizedNetwork.Sizing.Variables.sR3Phi,1,3); 
DCToAC3PhiMat=pR3PhiMat./sR3PhiMat;



%% Plot

x0=2;
y0=2;
width=8;
height=5;
Figure1=figure('Units','inches',...
'Position',[x0 y0 width height],...
'PaperPositionMode','auto');
set(Figure1, 'Name', 'Installation');




h1=bar(1:CaseFile.PlacedNetwork.Bus.PlacementLocations.N1Phi,...
pRMat,'stacked'); 
h1(1).FaceColor=[0 0 1];
h1(2).FaceColor=[0.41          0.51          0.22];
h1(3).FaceColor=[1 0 0]; 
h1(4).FaceColor=[0 0 0]; 
hold on
 xlim([0 CaseFile.PlacedNetwork.Bus.PlacementLocations.N1Phi+1]);
 ylim([0 6*CaseFile.PlacedNetwork.OptParams.pRMAX+0.2]); 
set(gca,'XTick',1:CaseFile.PlacedNetwork.Bus.PlacementLocations.N1Phi);
 set(gca, 'defaulttextinterpreter', 'Latex'); 
  set(gca, 'DefaultAxesTickLabelInterpreter', 'Latex'); 
  set(gca,'FontSize',14);
 
N3PhiInN1Phi=find(ismember(CaseFile.PlacedNetwork.Bus.PlacementLocations.N1PhiSet, CaseFile.PlacedNetwork.Bus.PlacementLocations.N3PhiSet));
XTickLabels=cellstr(num2str(CaseFile.PlacedNetwork.Bus.PlacementLocations.N1PhiSet));
XTickLabels(N3PhiInN1Phi)=...
    cellfun(@(x) ['\bf',' ', x],XTickLabels(N3PhiInN1Phi),'UniformOutput',0);
ylabel('Inverter DC size $p_{\mathrm{R}}$ (kW)'); 
xlabel('$\mathcal{N}_{1\phi} \cup \mathcal{N}_{3\phi}$');
set(gca,'XTickLabel',XTickLabels);
set(gca,'YTick', 0:0.1:6*CaseFile.PlacedNetwork.OptParams.pRMAX);
 LegendText={'Phase a'; 'Phase b';'Phase c';'Phase abc'};
 h1Legend=legend(h1,LegendText); 
 set(h1Legend,'Interpreter','Latex','FontSize',16,'Location','North','Orientation','Horizontal'); 

 
 cd(ResultsFolder); 
print(CaseFileName,'-dpdf'); 
print(CaseFileName,'-depsc2'); 
 cd(CurrentFolder); 



end
    








