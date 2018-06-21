pg=cvx(zeros(NPhases,M));  % ensures zero at nodes without installation
qg=cvx(zeros(NPhases,M));
pg(L1PhiSetVec,:)=pg1Phi;
qg(L1PhiSetVec,:)=qg1Phi;

for n=1:N3Phi
    pg(L3PhiSet{n},:)=pg(L3PhiSet{n},:)+repmat(pg3Phi(n,:),3,1); 
        qg(L3PhiSet{n},:)=qg(L3PhiSet{n},:)+repmat(qg3Phi(n,:),3,1); 

end