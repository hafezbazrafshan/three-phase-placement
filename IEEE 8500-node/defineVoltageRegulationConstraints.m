  norms([real(v(:)),imag(v(:))],2,2)<=VMAX;
  abs(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))<=abs(repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))-VMIN;
     v(end-2:end,:)==repmat(reshape(cell2mat(ScenarioParams.vS),3,Ml),1,Mg);

% for m=1:M
%     [ml,~]=ind2sub([Ml,Mg], m);
    
%     abs(v(1:end-3,m)-vHat{ml})<=abs(vHat{ml})-VMIN;
    
%     v(end-2:end,m)==Network.ScenarioParams.vS{ml};
    
% end