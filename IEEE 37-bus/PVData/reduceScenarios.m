function [ PgR,redProbs, dk_distance, selectedOmegaIndices] = reduceScenarios( Orig,Probs,Jspec)
%REDUCESCEN Reduces the number of scenarios
%   function [Out]=reduceScen(Orig,Probs,Jspec) reduces the given 
% Orig matrix of (N*J) to output of N*Jspec using fastforward reduction
J=length(Orig); %number of scenarios
OmegaJ=(1:J).';
dk_distance=zeros(Jspec,1); 
% dk_distanceCheck=zeros(Jspec,1); 
selectedOmegaIndices=zeros(Jspec,1);

%step 0: calculating v(w,w'):
vOrig=selfDifferenceNorm(Orig); 

D=zeros(J,1);

% step 1: 
for i=1:J
    D(i)=vOrig(i,:)*Probs;
end
[dk_distance(1),newOmegaIdx]=min(D); 
% dk_distanceCheck(1)=dk_distance(1); 
selectedOmegaIndices(1)=OmegaJ(newOmegaIdx);


if Jspec>1
prvOrig=vOrig;
prOmegaJ=setdiff(OmegaJ, selectedOmegaIndices(1));

for kk=2:Jspec

prOmegaJIdx=setdiff(1:J-kk+2,newOmegaIdx);
newvOrig=min( prvOrig(prOmegaJIdx,prOmegaJIdx), repmat(prvOrig(prOmegaJIdx,newOmegaIdx),1,length(prOmegaJIdx))); 
newD=Probs(prOmegaJ).'*newvOrig;
[dk_distance(kk),newOmegaIdx]=min(newD);
selectedOmegaIndices(kk)=prOmegaJ(newOmegaIdx);
prOmegaJ=setdiff(prOmegaJ,selectedOmegaIndices(kk));
prvOrig=newvOrig;
% dk_distanceCheck(kk)=Probs(prOmegaJ).'* min ( vOrig(prOmegaJ, selectedOmegaIndices(1:kk)),[],2);

end

redProbs=zeros(Jspec,1); 
newJ=length(prOmegaJIdx);

JomegaPrimeSet=cell(length(newJ),1); 
for idx=1:newJ
    minVal=min(vOrig(selectedOmegaIndices,prOmegaJIdx(idx)));
    JomegaPrimeSet{idx,1}=selectedOmegaIndices(find(vOrig(selectedOmegaIndices,prOmegaJIdx(idx))==minVal));
end

JomegaSet=cell(length(Jspec),1); 

for ii=1:Jspec
    dummySet=[];
    for jj=1:newJ
    if ismember(selectedOmegaIndices(ii), JomegaPrimeSet{jj,1})
       dummySet=[dummySet,prOmegaJIdx(jj)];
    end
    end
    JomegaSet{ii,1}=dummySet;
end

for idx=1:Jspec
    redProbs(idx)= Probs( selectedOmegaIndices(idx))+ sum(Probs( JomegaSet{idx,1}));
end



PgR=Orig(selectedOmegaIndices); 

else
    
    PgR=Orig(selectedOmegaIndices(1));
    redProbs=1;
end





