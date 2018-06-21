%%  implementing power flow equations per node and per phase

for n=1:NBuses % project onto three-phase space
    PhaseSet=Bus.Phases{n};
      % allocating correct indices
        VnnTilde=cvx(zeros(3));
        SnTilde=cvx(zeros(3,1));
        YCapTilde=zeros(3);
        if ~isempty(Bus.YCap{n})
        YCapTilde(PhaseSet,PhaseSet)=diag(Bus.YCap{n});
        end
     if length(PhaseSet)==3
            nn=find(Bus.ThreePhaseBusNumbers==n);
            VnnTilde(PhaseSet,PhaseSet)=Vnn3Phi(:,:,nn,ms);
            SnTilde(PhaseSet,1)=Bus.SLoad{n}-(pg(Bus.PhasesIndex{n})+sqrt(-1)*qg(Bus.PhasesIndex{n}));
        elseif length(PhaseSet)==2
            nn=find(Bus.TwoPhaseBusNumbers==n);
            VnnTilde(PhaseSet,PhaseSet)=Vnn2Phi(:,:,nn,ms);
            SnTilde(PhaseSet,1)=Bus.SLoad{n}-(pg(Bus.PhasesIndex{n})+sqrt(-1)*qg(Bus.PhasesIndex{n}));
        else
            nn=find(Bus.OnePhaseBusNumbers==n);
            VnnTilde(PhaseSet,PhaseSet)=Vnn1Phi(:,:,nn,ms);
            SnTilde(PhaseSet,1)=Bus.SLoad{n}-(pg(Bus.PhasesIndex{n})+sqrt(-1)*qg(Bus.PhasesIndex{n}));
     end
        
     
      
      %  To neighbors regular lines or transformers
        ToNeighborsNonRegSum=cvx(zeros(3,1));
        
        for jj=1:length(Bus.ToNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            LambdaTilde=cvx(zeros(3,1));
            ZNMTilde=zeros(3); 
            ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda3Phi(:,:,ll,ms);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda2Phi(:,:,ll,ms);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda1Phi(:,:,ll,ms);
            end

            ToNeighborsNonRegSum=ToNeighborsNonRegSum+ LambdaTilde;
               

        end
  
       % from neighbors regular lines or transformers
        
               FromNeighborsNonRegSum=cvx(zeros(3,1));
        
       for jj=1:length(Bus.FromNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            LambdaTilde=cvx(zeros(3,1));
            InmTilde=cvx(zeros(3));
           ZNMTilde=zeros(3); 
            ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM; 

          
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda3Phi(:,:,ll,ms);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
               LambdaTilde(Branch.Phases{l})=Lambda2Phi(:,:,ll,ms);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 LambdaTilde(Branch.Phases{l})=Lambda1Phi(:,:,ll,ms);
            end
   
            FromNeighborsNonRegSum=FromNeighborsNonRegSum+LambdaTilde;
            
           
            
            
            
               
       end
        

        
        
       
        ToNeighborsRegSum=cvx(zeros(3,1)); % here n is the primary (because it's a to bus neighbor)
       
        
        for jj=1:length(Bus.ToNeighborsRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            LambdaTilde=cvx(zeros(3,1));
            ZNMTilde=zeros(3); 

     

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda3Phi(:,:,ll,ms);
%                  rr=find(Branch.Regs3PhiBranchNumbers==l); 
                 
%                  if strcmp(Branch.RegulatorTypes(rr),'Wye') 
%                      rrr=find(Branch.Wye3PhiBranchNumbers==l);
%                     Av=Branch.Wye3PhiAvs{rrr};
%             
%                  elseif strcmp(Branch.RegulatorTypes(rr),'ClosedDelta')
%                      rrr=find(Branch.ClosedDeltaBranchNumbers==l);
%                      Av=Branch.ClosedDeltaAvs{rrr};
%                  else
%                      rrr=find(Branch.OpenDeltaBranchNumbers==l);
%                      Av=Branch.OpenDeltaAvs{rrr};
%                  end
%                  
   
                 
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda2Phi(:,:,ll,ms);
%                  rr=find(Branch.Wye2PhiBranchNumbers==l);
%                     Av=Branch.Wye2PhiAvs{rr};
            else 
                  ll=find(Branch.OnePhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda1Phi(:,:,ll,ms);
%                  rrr=find(Branch.Wye1PhiBranchNumbers==l);
%                     Av=Branch.Wye1PhiAvs{rrr};
               
            end
            
            
%  ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Av*Branch.Admittance{l}.ZNM*Av.';
                 

            ToNeighborsRegSum=ToNeighborsRegSum+LambdaTilde;

        end

           
        FromNeighborsRegSum=cvx(zeros(3,1));
       
    

     
        for jj=1:length(Bus.FromNeighborsRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            LambdaTilde=cvx(zeros(3,1));
            InmTilde=cvx(zeros(3));
           ZNMTilde=zeros(3); 
            ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM; 

          
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda3Phi(:,:,ll,ms);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                LambdaTilde(Branch.Phases{l})=Lambda2Phi(:,:,ll,ms);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 LambdaTilde(Branch.Phases{l})=Lambda1Phi(:,:,ll,ms);
            end
   
            FromNeighborsRegSum=FromNeighborsRegSum+LambdaTilde;
                
       end
        
        
      
     
     if n~=Bus.SubstationNumber
         
         
         FromNeighborsNonRegSum+FromNeighborsRegSum-...
            diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum==0;
         
        
    
        

   
     else

SIn(:,ms)+FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum==0;


         
         


   
   

     end
    
     
  
   
   
   
    
    end





