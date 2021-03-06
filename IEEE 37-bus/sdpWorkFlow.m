Mg=5;
BaseNetwork=initialize(Mg);
FileName='CSDPNoScenario';
if ~exist('Results')
    mkdir('Results');
end
[PlacedNetwork]=placeSizeDGsCSDPVectorized(BaseNetwork); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGsCSDPVectorized(PlacedNetwork); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 
[DispatchNetwork]=dispatchDGsLinear(SizedNetwork); 
cd('Results'); 
save(FileName, 'DispatchNetwork','-append');
cd('..'); 
