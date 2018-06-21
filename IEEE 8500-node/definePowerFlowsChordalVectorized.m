%%  implementing power flow equations per node and per phase
PhiCnt=0;

for n=1:NBuses
    PhaseSet=Bus.Phases{n};
      % allocating correct indices
        WnnTilde=cvx(zeros(3,3,M));
        YCapTilde=zeros(3);
        if ~isempty(Bus.YCap{n})
        YCapTilde(PhaseSet,PhaseSet)=diag(Bus.YCap{n});
        end
     if length(PhaseSet)==3
            nn=find(Bus.ThreePhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet,:)=Wnn3Phi(:,:,nn,:);
        elseif length(PhaseSet)==2
            nn=find(Bus.TwoPhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet,:)=Wnn2Phi(:,:,nn,:);
        else
            nn=find(Bus.OnePhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet,:)=Wnn1Phi(:,:,nn,:);
     end
     
      WnnTildeMBlocks=reshape(permute(WnnTilde,[2 1 3]),3,3*M).';  % vertical blocks

      
      
      
        
     
    for Phi=1:length(PhaseSet)
        PhiCnt=PhiCnt+1;
         EnTilde=zeros(3);
        EnTilde(PhaseSet(Phi),PhaseSet(Phi))=1;
      
      %  To neighbors regular lines or transformers
        ToNeighborsNonRegSum=cvx(zeros(1,M));
        
        for jj=1:length(Bus.ToNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            WnmTilde=cvx(zeros(3,3,M));
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 

            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMn;
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMm;

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm3Phi(:,:,ll,:);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm2Phi(:,:,ll,:);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm1Phi(:,:,ll,:);
            end

%             ToNeighborsNonRegSum=ToNeighborsNonRegSum+...
%                 trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
%                  trace( conj(YNMmTilde.')*EnTilde*WnmTilde);
             
             WnmTildeMBlocks=reshape(permute(WnmTilde,[2 1 3]),3,3*M).';  % vertical blocks

             YNMnEnTildeMBlocks=kron(speye(M),conj(YNMnTilde.')*EnTilde);
             YNMmEnTildeMBlocks=kron(speye(M),conj(YNMmTilde.')*EnTilde);
             
          ToNeighborsNonRegSum=  ToNeighborsNonRegSum+ ...
              sum(reshape((repmat(speye(3), M, 1).*(YNMnEnTildeMBlocks*WnnTildeMBlocks-...
                 YNMmEnTildeMBlocks* WnmTildeMBlocks)).',9,M));

             
%              
%                    ToNeighborsNonRegSum=ToNeighborsNonRegSum+...
%                 trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
%                  trace( conj(YNMmTilde.')*EnTilde*WnmTilde);


        end
  
       % from neighbors regular lines or transformers
        
               FromNeighborsNonRegSum=cvx(zeros(1,M));
        
       for jj=1:length(Bus.FromNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            WnmTilde=cvx(zeros(3,3,M));
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 
          
            
            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNm; % because we are the recipient
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNn;

            
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=conj(permute(Wnm3Phi(:,:,ll,:),[2 1 3 4]));
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=conj(permute(Wnm2Phi(:,:,ll,:),[2 1 3 4]));
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=conj(permute(Wnm1Phi(:,:,ll,:),[2 1 3 4]));
            end
   
%             FromNeighborsNonRegSum=FromNeighborsNonRegSum+...
%                 trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
%                  trace( conj(YNMmTilde.')*EnTilde*WnmTilde);


             WnmTildeMBlocks=reshape(permute(WnmTilde,[2 1 3]),3,3*M).';  % vertical blocks

             YNMnEnTildeMBlocks=kron(speye(M),conj(YNMnTilde.')*EnTilde);
             YNMmEnTildeMBlocks=kron(speye(M),conj(YNMmTilde.')*EnTilde);
             
          FromNeighborsNonRegSum=FromNeighborsNonRegSum+ ...
              sum(reshape((repmat(speye(3), M, 1).*(YNMnEnTildeMBlocks*WnnTildeMBlocks-...
                 YNMmEnTildeMBlocks* WnmTildeMBlocks)).',9,M));

       end
        

        
        
       
        ToNeighborsRegSum=cvx(zeros(1,M)); % here n is the primary (because it's a to bus neighbor)
       
        
        % instead of the composite line model we use the new power flow formulation
     for jj=1:length(Bus.ToNeighborsRegulatorBranchNumbers{n})
           l=Bus.ToNeighborsRegulatorBranchNumbers{n}(jj); % branch number
             WnmTilde=cvx(zeros(3,3,M));
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
         
         
             if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm3Phi(:,:,ll,:);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm2Phi(:,:,ll,:);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm1Phi(:,:,ll,:);
            end
            
            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=inv(Av).'*Branch.Admittance{l}.YNMn*inv(Av);
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=inv(Av).'*Branch.Admittance{l}.YNMm;
                
%                 ToNeighborsNonRegSum=ToNeighborsNonRegSum+...
%                 trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
%                  trace( conj(YNMmTilde.')*EnTilde*WnmTilde);


             WnmTildeMBlocks=reshape(permute(WnmTilde,[2 1 3]),3,3*M).';  % vertical blocks

             YNMnEnTildeMBlocks=kron(speye(M),conj(YNMnTilde.')*EnTilde);
             YNMmEnTildeMBlocks=kron(speye(M),conj(YNMmTilde.')*EnTilde);
             
          ToNeighborsRegSum=ToNeighborsRegSum+ ...
              sum(reshape((repmat(speye(3), M, 1).*(YNMnEnTildeMBlocks*WnnTildeMBlocks-...
                 YNMmEnTildeMBlocks* WnmTildeMBlocks)).',9,M));

           
    end

             


           
        FromNeighborsRegSum=cvx(zeros(1,M));
       
    

        
      for jj=1:length(Bus.FromNeighborsRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsRegulatorBranchNumbers{n}(jj); % branch number
             WnmTilde=cvx(zeros(3,3,M));

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
       
          
          
             if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=conj(permute(Wnm3Phi(:,:,ll,:),[2 1 3 4]));
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=conj(permute(Wnm2Phi(:,:,ll,:),[2 1 3 4]));
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=conj(permute(Wnm1Phi(:,:,ll,:),[2 1 3 4]));
            end
               YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNm; % because we are the recipient
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNn*inv(Av);
% 
%                 FromNeighborsNonRegSum=FromNeighborsNonRegSum+...
%                 trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
%                  trace( conj(YNMmTilde.')*EnTilde*WnmTilde);
%             

 WnmTildeMBlocks=reshape(permute(WnmTilde,[2 1 3]),3,3*M).';  % vertical blocks

             YNMnEnTildeMBlocks=kron(speye(M),conj(YNMnTilde.')*EnTilde);
             YNMmEnTildeMBlocks=kron(speye(M),conj(YNMmTilde.')*EnTilde);
             
          FromNeighborsRegSum=FromNeighborsRegSum+ ...
              sum(reshape((repmat(speye(3), M, 1).*(YNMnEnTildeMBlocks*WnnTildeMBlocks-...
                 YNMmEnTildeMBlocks* WnmTildeMBlocks)).',9,M));
            
      end

        
     % YCap contribution
                         YCapEnTildeMBlocks=kron(speye(M),conj(YCapTilde.')*EnTilde);
            YCapContributionSum=sum(reshape((repmat(speye(3), M, 1).*(YCapEnTildeMBlocks*WnnTildeMBlocks)).',9,M));

     
     if n~=Bus.SubstationNumber
   pg(PhiCnt,:)-repmat(ScenarioParams.LoadLevelsMat(PhiCnt,:),1,Mg).*real(Bus.SLoad{n}(Phi))==real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
       ToNeighborsRegSum+ FromNeighborsRegSum+YCapContributionSum);
      qg(PhiCnt,:)-repmat(ScenarioParams.LoadLevelsMat(PhiCnt,:),1,Mg).*imag(Bus.SLoad{n}(Phi))==imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
            ToNeighborsRegSum+ FromNeighborsRegSum+YCapContributionSum);

        

   
     else
     real(SIn(Phi,:))+pg(PhiCnt,:)-repmat(ScenarioParams.LoadLevelsMat(PhiCnt,:),1,Mg).*real(Bus.SLoad{n}(Phi))...
         ==real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum+YCapContributionSum);
     
              imag(SIn(Phi,:))+qg(PhiCnt,:)--repmat(ScenarioParams.LoadLevelsMat(PhiCnt,:),1,Mg).*imag(Bus.SLoad{n}(Phi))...
                  ==imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+....
                  ToNeighborsRegSum+ FromNeighborsRegSum+YCapContributionSum);
              
              
           
 
     end
    
     
  
   
   
   
    
    end

end



