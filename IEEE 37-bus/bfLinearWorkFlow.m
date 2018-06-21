clear all;
clc;
Mg=1;
BaseNetwork=initialize(Mg);
FileName=['BFLinear', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
[PlacedNetwork]=placeSizeDGsBFLinear(BaseNetwork); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGsBFLinear(PlacedNetwork); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 
