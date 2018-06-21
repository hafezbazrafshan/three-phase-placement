%     norms([real(v(:)),imag(v(:))],2,2)<=VMAX;
%     abs(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))<=abs(repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))-VMIN;
     v(end-2:end,:)==repmat(reshape(cell2mat(ScenarioParams.vS),3,Ml),1,Mg);

     
     
       ThetaUp=0:pi/NL:pi;
        ThetaDown=pi:pi/NL:2*pi;
        
        
        for i=1:NL
            Theta2Up=ThetaUp(i+1);
            Theta1Up=ThetaUp(i);
            Slope=(sin(Theta2Up)-sin(Theta1Up))./(cos(Theta2Up)-cos(Theta1Up));
            
            imag(v(:))<=Slope.*real(v(:))-Slope.*VMAX.*cos(Theta1Up)+VMAX.*sin(Theta1Up);
             imag( vec(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg)))<=...
                 Slope.*real(vec(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg)))...
                 -Slope.*vec(abs(repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))-VMIN).*cos(Theta1Up)+...
                 vec(abs(repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))-VMIN).*sin(Theta1Up);

             
              Theta2Down=ThetaDown(i+1);
            Theta1Down=ThetaDown(i);
            Slope=(sin(Theta2Down)-sin(Theta1Down))./(cos(Theta2Down)-cos(Theta1Down));
           
            imag(v(:))>=Slope.*real(v(:))-Slope.*VMAX.*cos(Theta1Down)+VMAX.*sin(Theta1Down);
%             
            imag( vec(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg)))>=...
                 Slope.*real(vec(v(1:end-3,:)-repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg)))...
                 -Slope.*vec(abs(repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))-VMIN).*cos(Theta1Down)+...
                 vec(abs(repmat(reshape(cell2mat(vHat),NPhases-3,Ml),1,Mg))-VMIN).*sin(Theta1Down)
            
        end
   
