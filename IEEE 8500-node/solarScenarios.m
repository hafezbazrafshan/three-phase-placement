function [ FgammaLevels, gammaLevelsProbs, FgammaLevelsMat] = solarScenarios(PhasesCell,SloadsCell,Mg)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


FileStr=['Solar',num2str(Mg),'Scenarios'];

cd('PVData'); 
SolarFile=load(FileStr);  % this file gives FgammaLevels for one sample node (you can use it to create correlation etc.)
% this file also gives gammaLevelsProbs
gammaLevelsProbs=SolarFile.gammaLevelsProbs;
cd('..'); 
N=size(SloadsCell,1); 
FgammaLevels=cell(N,1);


for n=1:N

L=length(PhasesCell{n}); 
FgammaLevels{n}=zeros(L,Mg);
FgammaLevels{n}=repmat(SolarFile.FgammaLevels.',L,1);
end

FgammaLevelsMat=cell2mat(FgammaLevels);



end

