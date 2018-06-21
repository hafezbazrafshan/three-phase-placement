


vec(pg(1:end-3,:)+sqrt(-1)*qg(1:end-3,:)-...
    repmat(ScenarioParams.LoadLevelsMat(1:end-3,:),1,Mg).*repmat(Bus.SLoadVec(1:end-3),1,M))...
    ==kron(speye(Mg),GammaMatBlockMl)*...
    vec(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))+...
   kron(speye(Mg),PhiMatBlockMl)*conj(vec(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg)))+...
    repmat(cell2mat(nuVector),Mg,1);



SIn(:)==vec(pg(end-2:end,:)+sqrt(-1)*qg(end-2:end,:))+...
    kron(speye(Mg),PhiSMatBlockMl)*conj(vec(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg)))+...
    repmat(cell2mat(ScenarioParams.nuSVector),Mg,1);
    





% for m=1:M
%         [ml,~]=ind2sub([Ml,Mg], m);
% 
% % pg(1:end-3,m)+sqrt(-1)*qg(1:end-3,m)-...
% %     Network.ScenarioParams.LoadLevelsMat(1:end-3,ml).*Bus.SLoadVec(1:end-3)...
% %     ==GammaMatrix{ml}*(v(1:end-3,m)-vHat{ml})+PhiMatrix{ml}*conj(v(1:end-3,m)-vHat{ml})+nuVector{ml};
% 
% SIn(:,m)==pg(end-2:end,m)+sqrt(-1)*qg(end-2:end,m)+PhiSMatrix{ml}*conj(v(1:end-3,m)-vHat{ml})+Network.ScenarioParams.nuSVector{ml};
% 
% 
% end