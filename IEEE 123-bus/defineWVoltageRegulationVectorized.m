
for n=1:NBuses3Phi
 VMIN^2<=sum(repmat(speye(3), M, 1).*reshape(permute(Wnn3Phi(:,:,n,:),[2 1 3 4]),3,3*M).',2) <=VMAX^2;
end

for n=1:NBuses2Phi
 VMIN^2<= sum(repmat(speye(2), M, 1).*reshape(permute(Wnn2Phi(:,:,n,:),[2 1 3 4]),2,2*M).',2)<=VMAX^2;
end
for n=1:NBuses1Phi
VMIN^2<= sum(repmat(speye(1), M, 1).*reshape(permute(Wnn1Phi(:,:,n,:),[2 1 3 4]),1,1*M).',2)<=VMAX^2;

end

WSBlock=[];
for ml=1:Ml
WSBlock=[WSBlock;ScenarioParams.vS{ml}*ScenarioParams.vS{ml}'];
end

reshape(permute(Wnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber,:),[2 1 3 4]),3,3*M).' ==repmat(WSBlock,Mg,1);




for l=1:NBranches
    n=Branch.BusFromNumbers(l); 
    m=Branch.BusToNumbers(l);
    WnmTilde=cvx(zeros(3,3,M));
    WnnTilde=cvx(zeros(3,3,M));
    WmmTilde=cvx(zeros(3,3,M));
    
    if length(Bus.Phases{n})==3
        kk=find(Bus.ThreePhaseBusNumbers==n);
        WnnTilde(Bus.Phases{n}, Bus.Phases{n},:)=Wnn3Phi(:,:,kk,:); 
    elseif length(Bus.Phases{n})==2
        kk=find(Bus.TwoPhaseBusNumbers==n);
        WnnTilde(Bus.Phases{n}, Bus.Phases{n},:)=Wnn2Phi(:,:,kk,:); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==n); 
        WnnTilde(Bus.Phases{n}, Bus.Phases{n},:)=Wnn1Phi(:,:,kk,:); 
    end
    
    
     if length(Bus.Phases{m})==3
        kk=find(Bus.ThreePhaseBusNumbers==m);
        WmmTilde(Bus.Phases{m}, Bus.Phases{m},:)=Wnn3Phi(:,:,kk,:); 
    elseif length(Bus.Phases{m})==2
        kk=find(Bus.TwoPhaseBusNumbers==m);
        WmmTilde(Bus.Phases{m}, Bus.Phases{m},:)=Wnn2Phi(:,:,kk,:); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==m); 
        WmmTilde(Bus.Phases{m}, Bus.Phases{m},:)=Wnn1Phi(:,:,kk,:); 
     end
    
    if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
        WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm3Phi(:,:,ll,:); 
        W3Phi(:,:,ll,:)=[WnnTilde(Branch.Phases{l}, Branch.Phases{l},:), WnmTilde(Branch.Phases{l}, Branch.Phases{l},:);...
         conj(permute(WnmTilde(Branch.Phases{l},Branch.Phases{l},:),[2 1 3])), WmmTilde(Branch.Phases{l},Branch.Phases{l},:)];
 W3Phi(:,:,ll,:)>=0;
 
 
    elseif length(Branch.Phases{l})==2
      ll=find(Branch.TwoPhaseBranchNumbers==l); 
      WnmTilde(Branch.Phases{l},Branch.Phases{l},:)=Wnm2Phi(:,:,ll,:);
       W2Phi(:,:,ll,:)=[WnnTilde(Branch.Phases{l}, Branch.Phases{l},:), WnmTilde(Branch.Phases{l}, Branch.Phases{l},:);...
         conj(permute(WnmTilde(Branch.Phases{l},Branch.Phases{l},:),[2 1 3])), WmmTilde(Branch.Phases{l},Branch.Phases{l},:)];

W2Phi(:,:,ll,:)>=0;
    else
        ll=find(Branch.OnePhaseBranchNumbers==l); 
        WnmTilde(Branch.Phases{l}, Branch.Phases{l},:)=Wnm1Phi(:,:,ll,:); 
          W1Phi(:,:,ll,:)=[WnnTilde(Branch.Phases{l}, Branch.Phases{l},:), WnmTilde(Branch.Phases{l}, Branch.Phases{l},:);...
         conj(permute(WnmTilde(Branch.Phases{l},Branch.Phases{l},:),[2 1 3])), WmmTilde(Branch.Phases{l},Branch.Phases{l},:)];
W1Phi(:,:,ll,:)>=0;

    end
    
    
        
    end



    

