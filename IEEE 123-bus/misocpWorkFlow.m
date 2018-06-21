clear all;
Mg=5;
BaseNetwork=initialize(Mg);
FileName=['MISOCP', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
[PlacedNetwork]=placeSizeDGs(BaseNetwork); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGs(PlacedNetwork); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 
%%
[DispatchNetwork]=dispatchDGsLinear(SizedNetwork); 
cd('Results'); 
save(FileName, 'DispatchNetwork','-append');
cd('..'); 
