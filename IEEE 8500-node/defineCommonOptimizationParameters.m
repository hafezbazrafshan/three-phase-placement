VMIN=Network.VMIN;
VMAX=Network.VMAX;
Branch=Network.Branch;
Bus=Network.Bus;

NBuses=length(Bus.Numbers); 
NBranches=length(Branch.Numbers); 
NPhases=length(Bus.NonZeroPhaseNumbers); 

NBuses3Phi=length(Bus.ThreePhaseBusNumbers); 
NBuses2Phi=length(Bus.TwoPhaseBusNumbers); 
NBuses1Phi=length(Bus.OnePhaseBusNumbers); 
NBranches3Phi=length(Branch.ThreePhaseBranchNumbers); 
NBranches2Phi=length(Branch.TwoPhaseBranchNumbers); 
NBranches1Phi=length(Branch.OnePhaseBranchNumbers); 
NRegs3Phi=length(Branch.Regs3PhiBranchNumbers);

v2struct(Bus.PlacementLocations);




% optimization
v2struct(Network.OptParams);
