clear all;
clc;
Mg=1;
BaseNetwork=initialize(Mg);
FileName=['MILP', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
[PlacedNetwork]=placeSizeDGsLinear(BaseNetwork,8); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGsLinear(PlacedNetwork,8); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 

