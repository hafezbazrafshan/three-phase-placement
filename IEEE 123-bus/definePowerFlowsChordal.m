%%  implementing power flow equations per node and per phase
PhiCnt=0;
ThermalLossExpression=cvx(0);

for n=1:NBuses
    PhaseSet=Bus.Phases{n};
      % allocating correct indices
        WnnTilde=cvx(zeros(3));
        YCapTilde=zeros(3);
        if ~isempty(Bus.YCap{n})
        YCapTilde(PhaseSet,PhaseSet)=diag(Bus.YCap{n});
        end
     if length(PhaseSet)==3
            nn=find(Bus.ThreePhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet)=Wnn3Phi(:,:,nn,ms);
        elseif length(PhaseSet)==2
            nn=find(Bus.TwoPhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet)=Wnn2Phi(:,:,nn,ms);
        else
            nn=find(Bus.OnePhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet)=Wnn1Phi(:,:,nn,ms);
     end
        
     
    for Phi=1:length(PhaseSet)
        PhiCnt=PhiCnt+1;
         EnTilde=zeros(3);
        EnTilde(PhaseSet(Phi),PhaseSet(Phi))=1;
      
      %  To neighbors regular lines or transformers
        ToNeighborsNonRegSum=cvx(0);
        
        for jj=1:length(Bus.ToNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            WnmTilde=cvx(zeros(3));
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 

            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMn;
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMm;

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm3Phi(:,:,ll,ms);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm2Phi(:,:,ll,ms);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm1Phi(:,:,ll,ms);
            end

            ToNeighborsNonRegSum=ToNeighborsNonRegSum+...
                trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
                 trace( conj(YNMmTilde.')*EnTilde*WnmTilde);

        end
  
       % from neighbors regular lines or transformers
        
               FromNeighborsNonRegSum=cvx(0);
        
       for jj=1:length(Bus.FromNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            WnmTilde=cvx(zeros(3));
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 
          
            
            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNm; % because we are the recipient
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNn;

            
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm3Phi(:,:,ll,ms).');
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm2Phi(:,:,ll,ms).');
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm1Phi(:,:,ll,ms).');
            end
   
            FromNeighborsNonRegSum=FromNeighborsNonRegSum+...
                trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
                 trace( conj(YNMmTilde.')*EnTilde*WnmTilde);
       end
        

        
        
       
        ToNeighborsRegSum=cvx(0); % here n is the primary (because it's a to bus neighbor)
       
        
        % instead of the composite line model we use the new power flow formulation
     for jj=1:length(Bus.ToNeighborsRegulatorBranchNumbers{n})
           l=Bus.ToNeighborsRegulatorBranchNumbers{n}(jj); % branch number
             WnmTilde=cvx(zeros(3));
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 

           r=find(Branch.RegulatorBranchNumbers==l); % find which regulator number it is
          if length(Branch.Phases{l})==3
              switch Branch.RegulatorTypes{r}
                  case 'Wye'    
                       rr=find(Branch.Wye3PhiBranchNumbers==l);
                      Av=Branch.Wye3PhiAvs{rr};
                      
                  case 'ClosedDelta'
                        rr=find(Branch.ClosedDeltaBranchNumbers==l);
                      Av=Branch.ClosedDeltaAvs{rr};
                  case 'OpenDelta'
                        rr=find(Branch.OpenDeltaBranchNumbers==l);
                      Av=Branch.OpenDeltaAvs{rr};
              end
          elseif length(Branch.Phases{l})==2
              rr=find(Branch.Wye2PhiBranchNumbers==l);
              Av=Branch.Wye2PhiAvs{rr};
          else
              rr=find(Branch.Wye1PhiBranchNumbers==l);
              Av=Branch.Wye1PhiAvs{rr};
          end
         % power flow equation for n'
         
         
             if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm3Phi(:,:,ll,ms);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm2Phi(:,:,ll,ms);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm1Phi(:,:,ll,ms);
            end
            
            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=inv(Av).'*Branch.Admittance{l}.YNMn*inv(Av);
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=inv(Av).'*Branch.Admittance{l}.YNMm;
                
                ToNeighborsNonRegSum=ToNeighborsNonRegSum+...
                trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
                 trace( conj(YNMmTilde.')*EnTilde*WnmTilde);
           
    end

             


           
        FromNeighborsRegSum=cvx(0);
       
    

        
      for jj=1:length(Bus.FromNeighborsRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 
    WnmTilde=cvx(zeros(3));

           
                r=find(Branch.RegulatorBranchNumbers==l); % find which regulator number it is
          if length(Branch.Phases{l})==3
              switch Branch.RegulatorTypes{r}
                  case 'Wye'    
                       rr=find(Branch.Wye3PhiBranchNumbers==l);
                      Av=Branch.Wye3PhiAvs{rr};

                  case 'ClosedDelta'
                        rr=find(Branch.ClosedDeltaBranchNumbers==l);
                      Av=Branch.ClosedDeltaAvs{rr};

                  case 'OpenDelta'
                        rr=find(Branch.OpenDeltaBranchNumbers==l);
                      Av=Branch.OpenDeltaAvs{rr};
              end
          elseif length(Branch.Phases{l})==2
              rr=find(Branch.Wye2PhiBranchNumbers==l);
              Av=Branch.Wye2PhiAvs{rr};

          else
              rr=find(Branch.Wye1PhiBranchNumbers==l);
              Av=Branch.Wye1PhiAvs{rr};
          end
       
          
          
             if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm3Phi(:,:,ll,ms).');
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm2Phi(:,:,ll,ms).');
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm1Phi(:,:,ll,ms).');
            end
               YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNm; % because we are the recipient
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNn*inv(Av);

                FromNeighborsNonRegSum=FromNeighborsNonRegSum+...
                trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
                 trace( conj(YNMmTilde.')*EnTilde*WnmTilde);
            
            
     end

        
      
     
     if n~=Bus.SubstationNumber
   pg(PhiCnt,ms)-ScenarioParams.LoadLevelsMat(PhiCnt,ml).*real(Bus.SLoad{n}(Phi))==real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
       ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
      qg(PhiCnt,ms)-ScenarioParams.LoadLevelsMat(PhiCnt,ml).*imag(Bus.SLoad{n}(Phi))==imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
            ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));

        
%          PowerFlowConstraintsP(PhiCnt)=real( Sg(PhiCnt))-real(Bus.SLoad{n}(Phi))-...
%         real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
%        ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
   
%       
%          PowerFlowConstraintsQ(PhiCnt)=real( Sg(PhiCnt))-real(Bus.SLoad{n}(Phi))-...
%         real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
%        ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
%    
%      ThermalLossExpression=ThermalLossExpression+ real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
%          ToNeighborsRegSum+ FromNeighborsRegSum);
   
     else
     real(SIn(Phi,ms))+pg(PhiCnt,ms)-ScenarioParams.LoadLevelsMat(PhiCnt,ml).*real(Bus.SLoad{n}(Phi))...
         ==real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
     
              imag(SIn(Phi,ms))+qg(PhiCnt,ms)-ScenarioParams.LoadLevelsMat(PhiCnt,ml).*imag(Bus.SLoad{n}(Phi))...
                  ==imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+....
                  ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
              
              
           
  
%               Sg(PhiCnt)==0;
              
%               PowerFlowConstraintsP(PhiCnt)= real(SIn(Phi,1))-real(Bus.SLoad{n}(Phi))-...
%                   real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
%          ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
%      
%      PowerFlowConstraintsQ(PhiCnt)=  imag(SIn(Phi,1))-imag(Bus.SLoad{n}(Phi))-...
%          imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+....
%                   ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
%               
%                    ThermalLossExpression=ThermalLossExpression+ real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
%          ToNeighborsRegSum+ FromNeighborsRegSum);
     end
    
     
  
   
   
   
    
    end

end



% ThermalLoss==ThermalLossExpression;