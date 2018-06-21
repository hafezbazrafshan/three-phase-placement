function [ LoadLevels, LoadLevelsProbs, LoadLevelsMat, v0MagsLevels] = loadScenarios(PhasesCell,SloadsCell,Ml ,LoadLevelMin,LoadLevelMax,v0MIN,v0MAX)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

v0MagsLevels=linspace(v0MIN,v0MAX,Ml).';
LoadLevelsProbs=(1/Ml).*ones(Ml,1);
N=size(SloadsCell,1); 
LoadLevels=cell(N,1);

for n=1:N

L=length(PhasesCell{n}); 
LoadLevels{n}=repmat(linspace(LoadLevelMin,LoadLevelMax,Ml), L,1);
end

LoadLevelsMat=cell2mat(LoadLevels);





end

