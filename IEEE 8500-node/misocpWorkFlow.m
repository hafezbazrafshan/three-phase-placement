Mg=1;
BaseNetwork=initialize(Mg);
FileName=['MISOCP', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
[PlacedNetwork]=placeSizeDGs(BaseNetwork,'Continuous'); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGs(PlacedNetwork); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 

