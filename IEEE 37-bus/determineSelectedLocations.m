function Bus=determineSelectedLocations(Bus,b1Phi,b3Phi)

Selected1PhiPhaseIndex=Bus.PlacementLocations.L1PhiSetVec(find(b1Phi)); 
NumberOf1PhiLocations=length(Selected1PhiPhaseIndex);
Selected1PhiNodesAll=zeros(NumberOf1PhiLocations,1);
Selected1PhiPhase=cell(NumberOf1PhiLocations,1); 
for ii=1:length(Selected1PhiPhaseIndex)
 Selected1PhiNodesAll(ii)= find(cellfun(@(x) ismember(Selected1PhiPhaseIndex(ii),x)==1, Bus.PhasesIndex));
  Selected1PhiPhase{ii}=  find(Bus.PhasesIndex{Selected1PhiNodesAll(ii)}==Selected1PhiPhaseIndex(ii));
end
Selected1PhiNodesUnique=unique(Selected1PhiNodesAll); 




Selected3PhiNodes=Bus.PlacementLocations.N3PhiSet(find(b3Phi));
NumberOf3PhiLocations=length(Selected3PhiNodes);


Bus.PlacementLocations.Selected=v2struct(NumberOf1PhiLocations,...
    Selected1PhiNodesAll, Selected1PhiNodesUnique, Selected1PhiPhaseIndex, Selected1PhiPhase,...
    NumberOf3PhiLocations,Selected3PhiNodes);