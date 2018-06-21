clear all;
clc;
MgValues=[1;5;25;200];



for ii=1:length(MgValues)
    
    Mg=MgValues(ii); 
    
    % 1. Setup BaseNetwork
    BaseNetwork=initialize(Mg);
    
    
    % 2. Do MISOCP
FileName=['MISOCP', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
cd('Results'); 
diary([FileName,'Diary.txt']); 
cd('..'); [PlacedNetwork]=placeSizeDGs(BaseNetwork,'Binary'); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGs(PlacedNetwork); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 
[DispatchNetwork]=dispatchDGsLinear(SizedNetwork); 
cd('Results'); 
save(FileName, 'DispatchNetwork','-append');
cd('..'); 

clear PlacedNetwork SizedNetwork DispatchNetwork
diary off;
end


for ii=1:length(MgValues)
    
    Mg=MgValues(ii); 
    
    % 1. Setup BaseNetwork
    BaseNetwork=initialize(Mg);
FileName=['SOCP', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
cd('Results'); 
diary([FileName,'Diary.txt']); 
cd('..'); [PlacedNetwork]=placeSizeDGs(BaseNetwork,'Continuous'); 
cd('Results'); 
save(FileName,'PlacedNetwork'); 
cd('..'); 
[SizedNetwork]=sizeDGs(PlacedNetwork); 
cd('Results'); 
save(FileName, 'SizedNetwork','-append');
cd('..'); 
[DispatchNetwork]=dispatchDGsLinear(SizedNetwork); 
cd('Results'); 
save(FileName, 'DispatchNetwork','-append');
cd('..'); 

clear PlacedNetwork SizedNetwork DispatchNetwork
diary off;
end

for ii=1:length(MgValues)
    
    Mg=MgValues(ii); 
    
    % 1. Setup BaseNetwork
    BaseNetwork=initialize(Mg);
 %3. %Do CSDP
FileName=['CSDP', num2str(Mg)];
if ~exist('Results')
    mkdir('Results');
end
cd('Results'); 
diary([FileName,'Diary.txt']); 
cd('..'); 
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

clear PlacedNetwork SizedNetwork DispatchNetwork
diary off;
end
% 4. Do MILP
% FileName=['MILP', num2str(Mg)];
% if ~exist('Results')
%     mkdir('Results');
% end
% [PlacedNetwork]=placeSizeDGsLinear(BaseNetwork,8); 
% cd('Results'); 
% save(FileName,'PlacedNetwork'); 
% cd('..'); 
% [SizedNetwork]=sizeDGsLinear(PlacedNetwork,8); 
% cd('Results'); 
% save(FileName, 'SizedNetwork','-append');
% cd('..'); 
% [DispatchNetwork]=dispatchDGsLinear(SizedNetwork); 
% cd('Results'); 
% save(FileName, 'DispatchNetwork','-append');
% cd('..'); 
% 
% clear PlacedNetwork SizedNetwork DispatchNetwork



