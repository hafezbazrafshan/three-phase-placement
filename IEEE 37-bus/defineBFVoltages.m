



% SlackVoltage constraint
Vnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber,ms)==ScenarioParams.vS{ml}*ScenarioParams.vS{ml}';



for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
        % voltage bounds constraint
    VMIN^2 <= diag(Vnn3Phi(:,:,n,ms)) <=VMAX^2;


    end
end
for n=1:NBuses2Phi
            % voltage bounds constraint
    VMIN^2 <= diag(Vnn2Phi(:,:,n,ms)) <=VMAX^2;
      

end

for n=1:NBuses1Phi
    % voltage bounds constraint
    VMIN^2 <= diag(Vnn1Phi(:,:,n,ms)) <=VMAX^2;


end





for l=1:NBranches
    
    
     n=Branch.BusFromNumbers(l); 
    m=Branch.BusToNumbers(l);
   
    VnnTilde=cvx(zeros(3));
    
    VmmTilde=cvx(zeros(3));
    
       if length(Bus.Phases{n})==3
        kk=find(Bus.ThreePhaseBusNumbers==n);
        VnnTilde(Bus.Phases{n}, Bus.Phases{n})=Vnn3Phi(:,:,kk,ms); 
        
    elseif length(Bus.Phases{n})==2
        kk=find(Bus.TwoPhaseBusNumbers==n);
        VnnTilde(Bus.Phases{n}, Bus.Phases{n})=Vnn2Phi(:,:,kk,ms); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==n); 
        VnnTilde(Bus.Phases{n}, Bus.Phases{n})=Vnn1Phi(:,:,kk,ms); 
       end
    
       
             if length(Bus.Phases{m})==3
        kk=find(Bus.ThreePhaseBusNumbers==m);
        VmmTilde(Bus.Phases{m}, Bus.Phases{m})=Vnn3Phi(:,:,kk,ms); 
        
    elseif length(Bus.Phases{m})==2
        kk=find(Bus.TwoPhaseBusNumbers==m);
        VmmTilde(Bus.Phases{m}, Bus.Phases{m})=Vnn2Phi(:,:,kk,ms); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==m); 
        VmmTilde(Bus.Phases{m}, Bus.Phases{m})=Vnn1Phi(:,:,kk,ms); 
       end
   

    
          
%     if ~strcmp(Branch.Device{l},'Reg')
         SnmTilde=cvx(zeros(3));
            InmTilde=cvx(zeros(3));

    if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
        SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm3Phi(:,:,ll,ms); 
         InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm3Phi(:,:,ll,ms); 

        W3Phi(:,:,ll,ms)=[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
         W3Phi(:,:,ll,ms) >=0;
 
    elseif length(Branch.Phases{l})==2
      ll=find(Branch.TwoPhaseBranchNumbers==l); 
      SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll,ms);
            InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm2Phi(:,:,ll,ms);
       W2Phi(:,:,ll,ms)=[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
         W2Phi(:,:,ll,ms) >=0;
         


    else
        ll=find(Branch.OnePhaseBranchNumbers==l); 
        SnmTilde(Branch.Phases{l}, Branch.Phases{l})=Snm1Phi(:,:,ll,ms); 
        InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm1Phi(:,:,ll,ms);
          W1Phi(:,:,ll,ms)=[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
         W1Phi(:,:,ll,ms) >=0;



    end
    
    ZNMTilde=zeros(3);
        
    
     ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;
        VmmTilde(Branch.Phases{l},Branch.Phases{l})==VnnTilde(Branch.Phases{l},Branch.Phases{l})-...
        (ZNMTilde(Branch.Phases{l},Branch.Phases{l})*conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).')+...
        SnmTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'))+...
        ZNMTilde(Branch.Phases{l},Branch.Phases{l})*InmTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'); 

       

    
    

        
end
    





    
