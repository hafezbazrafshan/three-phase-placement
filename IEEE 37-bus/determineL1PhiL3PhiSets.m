function [Bus] = determineL1PhiL3PhiSets( Bus )
%SLoad is the BaseNetwork.Bus.SLoad cell

N1PhiSet=find(  cellfun(@(x)length(find(x~=0))>=1,Bus.SLoad)); % all the nodes that have at least one-phase loads
N1Phi=length(N1PhiSet);
L1PhiSet=cell(N1Phi,1); 
for n=1:N1Phi
    L1PhiSet{n}=Bus.PhasesIndex{N1PhiSet(n)}(Bus.SLoad{N1PhiSet(n)}~=0);
end
L1PhiSetVec=cell2mat(L1PhiSet); 
L1Phi=length(L1PhiSetVec);

N3PhiSet=find(  cellfun(@(x)length(find(x~=0))==3,Bus.SLoad)); % all the nodes that have three-phase loads
N3Phi=length(N3PhiSet);
L3PhiSet=cell(N3Phi,1); 
for n=1:N3Phi
    L3PhiSet{n}=Bus.PhasesIndex{N3PhiSet(n)};
end

L3PhiSetVec=cell2mat(L3PhiSet); 
L3Phi=length(L3PhiSetVec);


Bus.PlacementLocations=v2struct(N1PhiSet,N1Phi, L1PhiSet, L1PhiSetVec, L1Phi,...
    N3PhiSet,N3Phi, L3PhiSet, L3PhiSetVec,L3Phi);
end

