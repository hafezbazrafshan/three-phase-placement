v2struct(Selected); 

pRMIN<=pR1Phi(Network.Placement.Variables.b1Phi==1)<=pRMAX;
pRMIN<=pR3Phi(Network.Placement.Variables.b3Phi==1)<=pRMAX;
pR1Phi(Network.Placement.Variables.b1Phi==1)>=DCToACRatio.*sR1Phi(Network.Placement.Variables.b1Phi==1);
pR3Phi(Network.Placement.Variables.b3Phi==1)>=DCToACRatio*sR3Phi(Network.Placement.Variables.b3Phi==1);

pR1Phi(Network.Placement.Variables.b1Phi==0)==0;
sR1Phi(Network.Placement.Variables.b1Phi==0)==0;
pR3Phi(Network.Placement.Variables.b3Phi==0)==0;
sR3Phi(Network.Placement.Variables.b3Phi==0)==0;