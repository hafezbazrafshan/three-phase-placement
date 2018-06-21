MgValues=[1;5;25;200];

for ii=1:length(MgValues)
Mg=MgValues(ii);
Method='SOCP';


CurrentFolder=pwd;
ResultsFolder='IEEE 37-bus/Results/';

cd(ResultsFolder)
CaseFileName=[Method,num2str(Mg)];
CaseFile=load(CaseFileName); 
cd(CurrentFolder); 







%% Allocate correct indices
NBuses=length(CaseFile.PlacedNetwork.Bus.Names);


vMax=NaN(3,NBuses); 
vBreveMax=NaN(3,NBuses); 
vTildeMax=NaN(3,NBuses); 
vMin=NaN(3,NBuses); 
vBreveMin=NaN(3,NBuses); 
vTildeMin=NaN(3,NBuses); 
% vMax(CaseFile.PlacedNetwork.Bus.NonZeroPhaseNumbers)=max(abs(CaseFile.SizedNetwork.Sizing.Variables.v),[],2); 
vBreveMax(CaseFile.PlacedNetwork.Bus.NonZeroPhaseNumbers)=max(abs(CaseFile.SizedNetwork.Sizing.Variables.vCorrected),[],2); 
vTildeMax(CaseFile.PlacedNetwork.Bus.NonZeroPhaseNumbers)=max(abs(CaseFile.DispatchNetwork.Dispatch.Variables.vCorrected),[],2); 
% vMin(CaseFile.PlacedNetwork.Bus.NonZeroPhaseNumbers)=min(abs(CaseFile.SizedNetwork.Sizing.Variables.v),[],2); 
vBreveMin(CaseFile.PlacedNetwork.Bus.NonZeroPhaseNumbers)=min(abs(CaseFile.SizedNetwork.Sizing.Variables.vCorrected),[],2); 
vTildeMin(CaseFile.PlacedNetwork.Bus.NonZeroPhaseNumbers)=min(abs(CaseFile.DispatchNetwork.Dispatch.Variables.vCorrected),[],2); 
% vMax=vMax.';
vBreveMax=vBreveMax.';
vTildeMax=vTildeMax.';
% vMin=vMin.';
vBreveMin=vBreveMin.';
vTildeMin=vTildeMin.';


x0=2;
y0=2;
width=8;
height=10;
Figure1=figure('Units','inches',...
'Position',[x0 y0 width height],...
'PaperPositionMode','auto');
set(Figure1, 'Name', 'Voltages');
PhaseNames = ['a' 'b' 'c'];


Swamp=[ 0.41          0.51          0.22];
Cinnamon=[0.67          0.31          0.02];
    

for phase=1:3
    subplot(3,1,phase)
%     h1=plot(1:NBuses,vMax(:,1),'bo'); 
    hold on;
    h1=plot(1:NBuses,vBreveMax(:,phase),'bo','MarkerSize',10); 
    hold on;
    h2=plot(1:NBuses,vTildeMax(:,phase),'kx','MarkerSize',10); 
    hold on;
%     h4=plot(1:NBuses,vMin(:,1),'mo'); 
    hold on;
    h3=plot(1:NBuses,vBreveMin(:,phase),'rd','MarkerSize',10); 
    hold on;
    h4=plot(1:NBuses,vTildeMin(:,phase),'*','Color',Swamp,'MarkerSize',10); 
    hold on
    h7=plot(1:NBuses,1.1*ones(NBuses,1),'k--','LineWidth',2); 
    hold on
    h8=plot(1:NBuses,0.9*ones(NBuses,1),'k--','LineWidth',2); 

  
     xlim([0 NBuses+1]);
    ylim([0.8 1.2]);
    
    XTicks=[1:NBuses].';
    XTickLabels=[cellstr(num2str([cellfun(@(x) str2num(x), CaseFile.PlacedNetwork.Bus.Names(1:end-1),'UniformOutput',1)]-700));'$\mathrm{S}$'];
    XTickLabels(2:2:end-1)={''};
    YTicks=[0.9:0.05:1.1];

			set(gca,'XTick', XTicks );
            set(gca,'YTick', YTicks);
    set(gca,'XTickLabel',XTickLabels);
    
    set(gca,'box','on');
    set(gca,'fontSize',14); 
set(0,'defaulttextinterpreter','latex');
set(gca,'TickLabelInterpreter','latex');
    ylabel(sprintf('Phase %c ',PhaseNames(phase)), 'FontWeight','bold');
    grid on;
    

        xlabel('$\mathcal{N}$');
        
        
        if phase==1
        LegendText={'$\max_{\kappa} \breve{v}_{n,a}^{\kappa}$';
            '$\max_{\tilde{\kappa}} \tilde{v}_{n,a}^{\tilde{\kappa}}$'; 
            '$\min_{\kappa} \breve{v}_{n,a}^{\kappa}$';
            '$\min_{\tilde{\kappa}} \tilde{v}_{n,a}^{\tilde{\kappa}}$'};
        elseif phase==2
              LegendText={'$\max_{\kappa} \breve{v}_{n,b}^{\kappa}$';
            '$\max_{\tilde{\kappa}} \tilde{v}_{n,b}^{\tilde{\kappa}}$'; 
            '$\min_{\kappa} \breve{v}_{n,b}^{\kappa}$';
            '$\min_{\tilde{\kappa}} \tilde{v}_{n,b}^{\tilde{\kappa}}$'};
        else 
               LegendText={'$\max_{\kappa} \breve{v}_{n,c}^{\kappa}$';
            '$\max_{\tilde{\kappa}} \tilde{v}_{n,c}^{\tilde{\kappa}}$'; 
            '$\min_{\kappa} \breve{v}_{n,c}^{\kappa}$';
            '$\min_{\tilde{\kappa}} \tilde{v}_{n,c}^{\tilde{\kappa}}$'};
        end
        
        Legend=legend([h1, h2, h3, h4], LegendText); 
        set(Legend,'interpreter','Latex','Orientation','Horizontal'); 
        set(Legend,'Location','NorthOutside', 'FontSize',16); 
       
 
end
    
    



 
 cd(ResultsFolder); 
print([CaseFileName,'Voltage'],'-dpdf'); 
print([CaseFileName,'Voltage'],'-depsc2'); 
 cd(CurrentFolder); 

end



