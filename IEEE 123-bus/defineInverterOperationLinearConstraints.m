- pg1Phi(:).*PFConstCap <=qg1Phi(:)<=pg1Phi(:).*PFConstInd;
% norms([pg1Phi(:),qg1Phi(:)],2,2)<=vec(repmat(sR1Phi,Ml,Mg));
pg1Phi(:)==vec(repmat(pR1Phi,Ml,Mg)).*vec(repmat(ScenarioParams.FgammaLevelsMat(L1PhiSetVec,:),Ml,1))-c1Phi(:);




    - pg3Phi(:).*PFConstCap <=qg3Phi(:)<=pg3Phi(:).*PFConstInd;
%         norms([pg3Phi(:),qg3Phi(:)],2,2)<=vec(repmat(sR3Phi,Ml,Mg));
        pg3Phi(:)==vec(repmat(pR3Phi,Ml,Mg)).*...
            vec(repmat(cell2mat( cellfun(@(x) x(1,:),ScenarioParams.FgammaLevels(N3PhiSet),'UniformOutput',false)),Ml,1))-c3Phi(:);
        
        
        pg1Phi(:)>=0;
        pg3Phi(:)>=0;
        c1Phi(:)>=0;
        c3Phi(:)>=0;
        

        ThetaUp=0:pi/NL:pi;
        ThetaDown=pi:pi/NL:2*pi;
        
        
        for i=1:NL
            Theta2Up=ThetaUp(i+1);
            Theta1Up=ThetaUp(i);
            Slope=(sin(Theta2Up)-sin(Theta1Up))./(cos(Theta2Up)-cos(Theta1Up));
            
            qg1Phi(:)<=Slope.*pg1Phi(:)-Slope.*vec(repmat(sR1Phi,Ml,Mg)).*cos(Theta1Up)+vec(repmat(sR1Phi,Ml,Mg)).*sin(Theta1Up);
             qg3Phi(:)<=Slope.*pg3Phi(:)-Slope.*vec(repmat(sR3Phi,Ml,Mg)).*cos(Theta1Up)+vec(repmat(sR3Phi,Ml,Mg)).*sin(Theta1Up);
             
             
             
              Theta2Down=ThetaDown(i+1);
            Theta1Down=ThetaDown(i);
            Slope=(sin(Theta2Down)-sin(Theta1Down))./(cos(Theta2Down)-cos(Theta1Down));
            
            qg1Phi(:)>=Slope.*pg1Phi(:)-Slope.*vec(repmat(sR1Phi,Ml,Mg)).*cos(Theta1Down)+vec(repmat(sR1Phi,Ml,Mg)).*sin(Theta1Down);
             qg3Phi(:)>=Slope.*pg3Phi(:)-Slope.*vec(repmat(sR3Phi,Ml,Mg)).*cos(Theta1Down)+vec(repmat(sR3Phi,Ml,Mg)).*sin(Theta1Down);

            
        end
   



