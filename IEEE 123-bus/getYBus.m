function [YBus,Y,YNS,YSN,YSS,NonZeroPhaseNumbersCheck,YCap]=getYBus(Branch,Bus)


NBuses=length(Bus.Numbers);
NBranches=length(Branch.Numbers);
YTilde=sparse(3*NBuses,3*NBuses);
YCap=sparse(3*NBuses,3*NBuses);


for ii=1:NBranches
    
 n=Branch.BusFromNumbers(ii); 
    m=Branch.BusToNumbers(ii);
    
    
      jmIdx=(m-1)*3+1:m*3;
     jnIdx=(n-1)*3+1:n*3;
    
       YTildeNMn=zeros(3,3);
    YTildeNMm=zeros(3,3);
    YTildeMNn=zeros(3,3);
    YTildeMNm=zeros(3,3);
    
    AvailablePhases=Branch.Phases{ii};
    
    YTildeNMn(AvailablePhases,AvailablePhases)=...
        Branch.Admittance{ii}.YNMn;
    
        YTildeNMm(AvailablePhases,AvailablePhases)=...
        Branch.Admittance{ii}.YNMm;
    
        YTildeMNm(AvailablePhases,AvailablePhases)=...
        Branch.Admittance{ii}.YMNm;
    
        YTildeMNn(AvailablePhases,AvailablePhases)=...
        Branch.Admittance{ii}.YMNn;
    
    
    
    switch Branch.Device{ii}
        
        case 'Reg'
            r=find(Branch.RegulatorBranchNumbers==ii);% which regulator number it is
            RegulatorType=Branch.RegulatorTypes{r};
            invAv=zeros(3);
            
             if length(Branch.Phases{ii})==3
            switch char(RegulatorType)
            case 'Wye'
               
            rrr=find(Branch.Wye3PhiBranchNumbers==ii); % which 3Phi regulator number it is
           Av=Branch.Wye3PhiAvs{rrr};
           invAv=inv(Av);
                

                case 'OpenDelta'
                                rrr=find(Branch.OpenDeltaBranchNumbers==ii); % which 3Phi regulator number it is
           Av=Branch.OpenDeltaAvs{rrr};
invAv=inv(Av);
                             
                    
                case 'ClosedDelta'
                           rrr=find(Branch.ClosedDeltaBranchNumbers==ii); % which 3Phi regulator number it is
                            Av=Branch.ClosedDeltaAvs{rrr};
                            invAv=inv(Av);
                end
                            
             elseif length(Branch.Phases{ii})==2
                           rrr=find(Branch.Wye2PhiBranchNumbers==ii); % which 3Phi regulator number it is
           Av=Branch.Wye2PhiAvs{rrr};
           invAv(Branch.Phases{ii},Branch.Phases{ii})=inv(Av);
                else
                     rrr=find(Branch.Wye1PhiBranchNumbers==ii); % which 3Phi regulator number it is
           Av=Branch.Wye1PhiAvs{rrr};
                      invAv(Branch.Phases{ii},Branch.Phases{ii})=inv(Av);
                end
  
            
  YTilde(jnIdx, jnIdx)= YTilde(jnIdx, jnIdx)+invAv.'*(YTildeNMn)*invAv;
    YTilde(jnIdx, jmIdx)=-invAv.'*YTildeNMm;
    YTilde(jmIdx,jmIdx)=YTilde(jmIdx,jmIdx)+YTildeMNm;
    YTilde(jmIdx,jnIdx)=-YTildeMNn*invAv;
        otherwise

              YTilde(jnIdx, jnIdx)= YTilde(jnIdx, jnIdx)+YTildeNMn;
    YTilde(jnIdx, jmIdx)=-YTildeNMm;
    YTilde(jmIdx,jmIdx)=YTilde(jmIdx,jmIdx)+YTildeMNm;
    YTilde(jmIdx,jnIdx)=-YTildeMNn;
    
    end
    
end


%% Adding YCap
for ii=1:NBuses
      if ~isempty(Bus.YCap{ii})
    for jj=1:length(Bus.Phases{ii})
         iIdx=(ii-1)*3+Bus.Phases{ii}(jj);
        YCap(iIdx,iIdx)=Bus.YCap{ii}(jj);
    end
      end
end
%%

YTilde=YTilde+YCap;

%% Finding available phases
 NonZeroIndices=find(any(YTilde,2)); 
 % availableBusAppIndices and availableBusIndices should match
 YBus=YTilde( NonZeroIndices, NonZeroIndices);
Y=YBus(1:end-3,1:end-3);
YNS=YBus(1:end-3,end-2:end);
YSN=YBus(end-2:end,1:end-3);
YSS=YBus(end-2:end,end-2:end);
NonZeroPhaseNumbersCheck=NonZeroIndices;



