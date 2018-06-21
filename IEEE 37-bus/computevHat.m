function [ Network,ScenarioParams] = computevHat(Network,ScenarioParams)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

NBuses=length(Network.Bus.Numbers);
Ml=ScenarioParams.Ml;

[Network.YBus,Network.Y,Network.YNS,...
    Network.YSN,Network.YSS]=getYBus(Network.Branch,Network.Bus); % this needs to be update to only take network



ScenarioParams.vS=cell(Ml,1);
ScenarioParams.vHat=cell(Ml,1);
ScenarioParams.vSol=cell(Ml,1); % solution per load 
ScenarioParams.vHat3Phase=cell(Ml,1);
ScenarioParams.vHatMag=cell(Ml,1);
ScenarioParams.vHatAngle=cell(Ml,1);
ScenarioParams.GammaMatrix=cell(Ml,1); 
ScenarioParams.PhiMatrix=cell(Ml,1); 
ScenarioParams.nuVector=cell(Ml,1); 
ScenarioParams.PhiSMatrix=cell(Ml,1);
ScenarioParams.nuSVector=cell(Ml,1);
ScenarioParams.SInSol=cell(Ml,1);
ScenarioParams.w=cell(Ml,1);

for ml=1:ScenarioParams.Ml

    
    
 SLoadVec=ScenarioParams.LoadLevelsMat(:,ml).*Network.Bus.SLoadVec;
 
 ScenarioParams.vS{ml}=ScenarioParams.v0MagsLevels(ml).*Network.vS;
 
     ScenarioParams.w{ml}=-Network.Y\(Network.YNS*ScenarioParams.vS{ml});
wCheck=NaN(3*(NBuses),1);
wCheck(Network.Bus.NonZeroPhaseNumbers,1)=[ScenarioParams.w{ml};ScenarioParams.vS{ml}];
ScenarioParams.w3Phase{ml}=reshape(wCheck,3,NBuses).';
 
ScenarioParams.vSol{ml,1} =performZBus( ScenarioParams.w{ml}, SLoadVec(1:end-3),...
    Network.Y,Network.YNS,40,ScenarioParams.vS{ml}); 

ScenarioParams.vHat{ml,1}=ScenarioParams.w{ml};
% ScenarioParams.vHat{ml,1}=ScenarioParams.vSol{ml,1};


vCheck=NaN(3*(NBuses),1);
vCheck(Network.Bus.NonZeroPhaseNumbers,1)=[ScenarioParams.vHat{ml,1}; ScenarioParams.vS{ml} ];
ScenarioParams.vHat3Phase{ml,1}=reshape(vCheck,3,NBuses).';

% adding n' of the regulators to the labels:
NRegs=length(Network.Branch.RegulatorBranchNumbers);
v3PhaseRegs=NaN(NRegs,3);
for r=1:NRegs
     l=Network.Branch.RegulatorBranchNumbers(r);
     n=Network.Branch.BusFromNumbers(l);
     m=Network.Branch.BusToNumbers(l);
     switch char(Network.Branch.RegulatorTypes(r))
         case 'Wye'
             if length(Network.Branch.Phases{l})==3
         rr=find(Network.Branch.Wye3PhiBranchNumbers==l); % which 3Phi regulator number it is
            TapA=Network.Branch.Wye3PhiTaps(1,rr); 
            TapB=Network.Branch.Wye3PhiTaps(2,rr);
            TapC=Network.Branch.Wye3PhiTaps(3,rr);
            ArA=1-0.00625*TapA;
            ArB=1-0.00625*TapB;
            ArC=1-0.00625*TapC;
            Av=diag([ArA; ArB; ArC]);
             end
         case 'OpenDelta'
                      rr=find(Network.Branch.OpenDeltaBranchNumbers==l); % which 3Phi regulator number it is
                             TapAB=Network.Branch.OpenDeltaTaps(1,rr); 
            TapCB=Network.Branch.OpenDeltaTaps(2,rr);
            ArAB=1-0.00625*TapAB;
            ArCB=1-0.00625*TapCB;
   
            Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];      
         case 'ClosedDelta'
                      rr=find(Network.Branch.ClosedDeltaBranchNumbers==l); % which 3Phi regulator number it is
               TapAB=Network.Branch.ClosedDeltaTaps(1,rr); 
            TapBC=Network.Branch.ClosedDeltaTaps(2,rr);
                        TapCA=Network.Branch.ClosedDeltaTaps(3,rr);

            ArAB=1-0.00625*TapAB;
            ArBC=1-0.00625*TapBC;
            ArCA=1-0.00625*TapCA;
   
            Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];


     end
     
     
     ScenarioParams.vHat3PhaseRegs{ml,1}(r,:)=(inv(Av)*ScenarioParams.vHat3Phase{ml,1}(n,:).').'; % three phases
     Network.w3PhaseRegs(r,:)=(inv(Av)*ScenarioParams.w3Phase{ml}(n,:).').';
end
        
ScenarioParams.vHatMag{ml,1}=[abs(ScenarioParams.vHat3Phase{ml,1});abs(ScenarioParams.vHat3PhaseRegs{ml,1})];
ScenarioParams.vHatAngle{ml,1}=[radian2degrees(angle(ScenarioParams.vHat3Phase{ml,1})); radian2degrees(angle(ScenarioParams.vHat3PhaseRegs{ml,1}))];
% 

% Paper implementation:
ScenarioParams.GammaMatrix{ml,1}=diag(conj(Network.Y*ScenarioParams.vHat{ml}))+diag(conj(Network.YNS*ScenarioParams.vS{ml}));
ScenarioParams.PhiMatrix{ml,1}=diag(ScenarioParams.vHat{ml})*conj(Network.Y);
ScenarioParams.nuVector{ml,1}=diag(ScenarioParams.vHat{ml})*conj(Network.Y)*conj(ScenarioParams.vHat{ml})+...
    diag(ScenarioParams.vHat{ml})*conj(Network.YNS)*conj(ScenarioParams.vS{ml});
ScenarioParams.PhiSMatrix{ml,1}= diag(ScenarioParams.vS{ml})*conj(Network.YSN);
ScenarioParams.nuSVector{ml,1}= diag(ScenarioParams.vS{ml})*(conj(Network.YSN*ScenarioParams.vHat{ml})+...
    conj(Network.YSS*ScenarioParams.vS{ml}));

ScenarioParams.SInSol{ml,1}=diag(ScenarioParams.vS{ml})*(conj(Network.YSN*ScenarioParams.vSol{ml})+...
    conj(Network.YSS*ScenarioParams.vS{ml}));


% ScenarioParams.GammaMatrix{ml,1}=zeros(length(ScenarioParams.vHat{ml}));
% ScenarioParams.PhiMatrix{ml,1}=diag(ScenarioParams.vHat{ml})*conj(Network.Y);
% ScenarioParams.nuVector{ml,1}=diag(ScenarioParams.vHat{ml})*conj(Network.Y)*conj(ScenarioParams.vHat{ml}-ScenarioParams.w{ml});
% ScenarioParams.PhiSMatrix{ml,1}= diag(ScenarioParams.vS{ml})*conj(Network.YSN);
% ScenarioParams.nuSVector{ml,1}= diag(ScenarioParams.vS{ml})*(conj(Network.YSN*ScenarioParams.vHat{ml})+...
%     conj(Network.YSS*ScenarioParams.vS{ml}));


end

end

