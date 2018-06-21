DCToACRatio=1; % S_R_max==theta P_R
pRMIN= 10*1000/BaseNetwork.SBase;  %P_R_min= eta_inv*d*A_min*iota_0; 
pRMAX=400*1000/BaseNetwork.SBase;  %P_R_min= eta_inv*d*A_max*iota_0; 


PFInd=0.93;  % Power factor values from Pereira et al. 2016
PFCap=0.99;  % Power factor values from Pereira et al. 2016

PFConstInd=tan(acos(PFInd));
PFConstCap=tan(acos(PFCap));


 
 
B1Phi=BaseNetwork.Bus.PlacementLocations.L1Phi; % budget 1 phi
B3Phi=BaseNetwork.Bus.PlacementLocations.N3Phi; % budget 3 phi
% 


ElectricityPrice=((1+0.01)^(15))*0.08*(1/1000)*15*365*13*BaseNetwork.SBase; % price of electricity is 0.037 dollars per kilowatt hours times 5 years. 
% ElectricityPrice=0.1221*(1/1000)*30*365*13*BaseNetwork.SBase; % price of electricity is 0.037 dollars per kilowatt hours times 5 years. 

CurtailmentPrice=ElectricityPrice;

% % 
% pRPrice=( 3251.7/1000)*BaseNetwork.SBase;
%  sRPrice=( 281.7738/1000)*BaseNetwork.SBase;

pRPrice=1.85*BaseNetwork.SBase;
sRPrice=0.15*BaseNetwork.SBase;



OptParams=v2struct(DCToACRatio, pRMIN, pRMAX, PFConstInd, PFConstCap, B1Phi, B3Phi, ElectricityPrice, pRPrice, sRPrice,CurtailmentPrice,VMIN,VMAX); 