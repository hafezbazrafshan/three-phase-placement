function Vsol =performZBus( vPr,SLoadVec,Y,YNS,MaxIt,vS)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


err=inf+zeros(MaxIt+1,1);
success=0;

vIterations=zeros(size(vPr,1),MaxIt+1);
vIterations(:,1)=vPr;
VNew=vPr;


Fv= -fPQ( vPr,SLoadVec);



 err(1)=sum(abs(Y*vPr-Fv+YNS*vS));
str=['Iteration No. ', num2str(0),' Error is ', num2str(err(1)), '\n'];
% fprintf(str);
 for it=1:MaxIt
     
      if err(it) <1e-4
     itSuccess=it-1;
     fprintf('Convergence \n');
     success=1;
     break;
      end 
      
      
      


VNew=Y\ (Fv-YNS*vS);
vIterations(:,it+1)=VNew;
 vPr=VNew;
Fv= -fPQ( vPr,SLoadVec);
 err(it+1)=sum(abs(Y*VNew-Fv+YNS*vS));
 str=['Iteration No. ', num2str(it),' Error is ', num2str(err(it+1)), '\n'];
%  fprintf(str);
 end
 
 
Vsol=VNew;



if success~=1
    fprintf('Load-flow was not satisfied'); 
    pause;
end




end

