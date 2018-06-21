% this code produces scenarios for solar and their respective probabilities
SolarScen=1;
DataIn=load('PvData.mat'); 
DataIn=DataIn.ValidData;

DataInForReduction=DataIn;
probs=1./length(DataInForReduction)*ones(size(DataInForReduction)); 
[ FgammaLevels,gammaLevelsProbs,DkDistance, SelectedOmegaIndices] = reduceScenarios( DataInForReduction,probs,SolarScen);


SaveStr=['Solar',num2str(SolarScen),'Scenarios'];
save(SaveStr,'FgammaLevels', 'gammaLevelsProbs','DkDistance','SelectedOmegaIndices','DataInForReduction','SolarScen');

%% Figure generation
% 
% if SolarScen>5
% x0=2;
% y0=2;
% width=8;
% height=6;
% scenarioReductionFigure=figure('Units','Inches',...
% 'Position',[x0 y0 width height],...
% 'PaperPositionMode','auto');
% set(scenarioReductionFigure, 'Name', 'scenarioReduction');
% set(0,'defaulttextinterpreter','latex')
% 
% hold on;
% 
% FGTildeSet=DataIn;
% [FGTildeSetSorted,FGTildeIndex]=sort(FGTildeSet); 
% FGTilde=length(FGTildeSet); 
% probFGTildeSorted=ones(FGTilde,1).*1./length(DataIn); 
% 
% 
% 
% 
% FGSet=FgammaLevels;
% [FGSetSorted,FGIndex]=sort(FGSet); 
% FG=length(FGSet); 
% probFGSorted=gammaLevelsProbs(FGIndex); 
% 
% 
% 
% 
% h1=stem([FGTildeSetSorted(1:1:end)], [probFGTildeSorted(1:1:end)],'b');
% hold on
% h2=stem([FGSetSorted],  [probFGSorted],'r'); 
% hold on
% 
% ax1 = gca; % current axes
% ax1.XColor = 'b';
% ax1.YColor = 'b';
% 
% set(ax1,'yLim',[0,0.015]);
% set(ax1,'Ytick',[0:0.002:0.012]);
% set(ax1,'fontSize',14); 
% grid on; 
% set(ax1, 'box','on'); 
% xlabel('Normalized solar generation','FontName','Times New Roman'); 
% ylabel('Probability', 'FontName','Times New Roman'); 
% set(ax1,'FontName','Times New Roman');
% 
% 
% 
% 
% ax2 = axes('Position',ax1.Position,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');
% 
% set(ax2,'Xtick',[1,20:20:200]);
% set(ax2,'XtickLabels',[1,20:20:200]);
% set(ax2,'Ytick',0:0.01:0.2); 
% set(ax2,'YtickLabels',0:0.01:0.2); 
% set(ax2,'xLim',[-20,210]);
% set(ax2,'yLim',[log10(1e-4), 0]); 
% set(ax2,'YTick',[log10(10.^(-3:1:-1))]);
% YTickLabelSet=[log10(10.^(-3:1:-1))];
% set(ax2,'YTickLabel',[]);
% yTicks=get(ax2,'YTick');
% 
% HorizontalOffset=15;
% ax=axis;
% for i = 1:length(YTickLabelSet)
% %Create text box and set appropriate properties
%      text(ax(2) + HorizontalOffset,yTicks(i),['$\mathbf{10^{' num2str( YTickLabelSet(i)) '}}$'],...
%          'HorizontalAlignment','Right','interpreter', 'latex','fontSize',14,'fontName','Times New Roman');   
% end
% 
% hold on;
% h3=plot((1:FG), log10(DkDistance),'parent',ax2);
% set(h3,'LineWidth',4); 
% set(h3,'color','k'); 
% 
% 
% set(ax2,'fontSize',14); 
% grid on; 
% set(ax2, 'box','off'); 
% xlabel('Number of selected scenarios  ','FontName','Times New Roman'); 
% ylabel('Kantorovich distance');
% ylabelProp=get(ax2,'yLabel'); 
% set(ylabelProp,'Position',get(ylabelProp,'Position') +[18 0 0]); 
% set(ax2,'FontName','Times New Roman');
% 
% legendTEXT=legend([h1, h2, h3], ...
%     '$\mathrm{Prob}(\tilde{\mathcal{F}})$', ...
%     '$\mathrm{Prob}(\mathcal{F})$', ...
%     '$D_K(\tilde{\mathcal{F}}, \mathcal{F})$'); 
% 
% 
% set(legendTEXT,'interpreter','Latex'); 
% set(legendTEXT,'fontSize',14); 
% set(legendTEXT,'fontname','Times New Roman');
% set(legendTEXT,'fontWeight','Bold');
% set(legend,'orientation','Vertical'); 
% set(legend,'location','NorthEast');
% 
% if exist('Figures')~=7
%     mkdir Figures 
% end
% cd('Figures'); 
% print -dpdf scenarioAnalysis200.pdf
% print -depsc2 scenarioAnalysis200
% 
% cd('..'); 
% 
% end