clear all;
clc;
Mg=1;
BaseNetwork=initialize(Mg);
FileName=['BFSDP', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
[PlacedNetwork]=placeSizeDGsBFSDP(BaseNetwork); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGsCSDPVectorized(PlacedNetwork); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 
