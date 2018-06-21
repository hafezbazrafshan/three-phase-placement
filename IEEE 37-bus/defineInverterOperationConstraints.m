- pg1Phi(:).*PFConstCap <=qg1Phi(:)<=pg1Phi(:).*PFConstInd;
norms([pg1Phi(:),qg1Phi(:)],2,2)<=vec(repmat(sR1Phi,Ml,Mg));
pg1Phi(:)==vec(repmat(pR1Phi,Ml,Mg)).*vec(repmat(ScenarioParams.FgammaLevelsMat(L1PhiSetVec,:),Ml,1))-c1Phi(:);




    - pg3Phi(:).*PFConstCap <=qg3Phi(:)<=pg3Phi(:).*PFConstInd;
        norms([pg3Phi(:),qg3Phi(:)],2,2)<=vec(repmat(sR3Phi,Ml,Mg));
        pg3Phi(:)==vec(repmat(pR3Phi,Ml,Mg)).*...
            vec(repmat(cell2mat( cellfun(@(x) x(1,:),ScenarioParams.FgammaLevels(N3PhiSet),'UniformOutput',false)),Ml,1))-c3Phi(:);
        
        
        pg1Phi(:)>=0;
        pg3Phi(:)>=0;
        c1Phi(:)>=0;
        c3Phi(:)>=0;
   



% for m=1:M
%         [~,mg]=ind2sub([Ml,Mg], m);
% 
% - pg1Phi(:,m).*PFConstCap <=qg1Phi(:,m)<=pg1Phi(:,m).*PFConstInd;
% norms([pg1Phi(:,m),qg1Phi(:,m)],2,2)<=sR1Phi;
% pg1Phi(:,m)==pR1Phi.*Network.ScenarioParams.FgammaLevelsMat(L1PhiSetVec,mg)-c1Phi(:,m);
% 
% 
% 
%     - pg3Phi.*PFConstCap <=qg3Phi<=pg3Phi.*PFConstInd;
%     norms([pg3Phi(:,m),qg3Phi(:,m)],2,2)<=sR3Phi;
% pg3Phi(:,m)==pR3Phi.*cellfun(@(x) x(1,mg), Network.ScenarioParams.FgammaLevels(N3PhiSet))-c3Phi(:,m);
% 
% 
% end