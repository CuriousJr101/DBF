%Functions
syms R M l k FR xcm tc sweep A
CfTurbulent(R, M) = 0.455/(log10(R)^2.58*(1+0.144*M^2)^0.65);
Rcutoff(l,k) = 38.21*(l/k)^1.053; %l in terms of feet
FFBodies(FR) = 1+60/FR^3+0.0025*FR;
FFLiftingDevices(xcm, tc, sweep, M) = (1+(0.6/xcm)*tc+100*tc^4)*(1.34*M^0.18*cos(sweep)^0.28);
e(A) = 1.78*(1-0.045*A^0.68)-0.64;

table = xlsread('dynamicThrust_SC4020_540_13x8.xlsx');
aircraftFrontalArea = 124;
viscosity = 1.48*10^-5; %m^2/s at 15C
density = 1.225; %kgm^2s^-1
flightSpeed = (20:1:80)./2.237; %m/s
kSkinRoughness = 0.17*10^-5; %Skin roughness value
MCorrection = 1; %Mach Number correction
aircraftMass = 8.52/2.205; %kgs
inSquared2mSquared = 0.00064516;
in2m = 0.0245;
CGLocation = 1; 

fuselageTotalLength = 80; %in - 47
fuselageMaximumWidth = 7.5; %in - 3.5
fuselageMaximumHeight = 5; %in - 4.5
fuselageWettedArea = 460; %in^2

HTailSpan = 24; %in
VTailLength = 10.37; %in
LGLength = 7.65; %in

xcmEstimate = 0.3;
wingMAC = 12; %in
wingChord = 15; %in
wingLength = 60; %in
tcPSU = 0.097;
wingSweep = 0;
wingRefArea = wingChord*wingLength;
wingWettedArea = wingRefArea*(1.977+0.52*tcPSU);
aspectRatio = wingLength^2/wingRefArea;
ClInFlight = (aircraftMass*9.81)./(0.5.*density.*(wingRefArea*inSquared2mSquared).*flightSpeed.^2);
Cm = -0.11;
MomentWing = 0.5.*density.*(flightSpeed.^2)*wingRefArea*inSquared2mSquared*wingChord*in2m*Cm;
totalMoment = MomentWing + CGLocation*aircraftMass*9.81;

tcTail = 0.09;
tailSweep = 32.03;
HTailWettedArea = 125*2; %in^2
HTailRefArea = 125; %in^2
aspectRatioHTail = HTailSpan^2/HTailRefArea;
VTailWettedArea = 108.78; %in^2
tailMomentArm = 36; %in
tailLift = totalMoment./tailMomentArm;
tailCL = (tailLift)./(0.5.*density.*(HTailRefArea*inSquared2mSquared).*flightSpeed.^2);


%---------Wetted Area Calculation------------
wettedArray = [fuselageWettedArea, wingWettedArea, HTailWettedArea, VTailWettedArea];

%Flat-Plate Skin Friction Drag Component (CDf)

%Fuselage
characteristicLengthFuselage = fuselageTotalLength/39.37;
reynoldsNumberFuselage = (density*flightSpeed*characteristicLengthFuselage)/viscosity;
RcutoffFuselage = double(Rcutoff(fuselageTotalLength/12, kSkinRoughness));
if reynoldsNumberFuselage > RcutoffFuselage
    CfTurbulentFuselage = double(CfTurbulent(RcutoffFuselage, MCorrection));
else
    CfTurbulentFuselage = double(CfTurbulent(reynoldsNumberFuselage, MCorrection));
end

%Wing
characteristicLengthWing = wingMAC/39.37; %wing MAC
reynoldsNumberWing = (density*flightSpeed*characteristicLengthWing)/viscosity;
RcutoffWing = double(Rcutoff(wingMAC/12, kSkinRoughness));
if reynoldsNumberWing > RcutoffWing
    CfTurbulentWing = double(CfTurbulent(RcutoffWing, MCorrection));
else
    CfTurbulentWing = double(CfTurbulent(reynoldsNumberWing, MCorrection));
end

%Tail - Horizontal
characteristicLengthHTail = HTailSpan/39.37; %wing MAC
reynoldsNumberHTail = (density*flightSpeed*characteristicLengthHTail)/viscosity;
RcutoffHTail = double(Rcutoff(HTailSpan/12, kSkinRoughness));
if reynoldsNumberHTail > RcutoffHTail
    CfTurbulentHTail = double(CfTurbulent(RcutoffHTail, MCorrection));
else
    CfTurbulentHTail = double(CfTurbulent(reynoldsNumberHTail, MCorrection));
end

%Tail - Vertical
characteristicLengthVTail = VTailLength/39.37; %wing MAC
reynoldsNumberVTail = (density*flightSpeed*characteristicLengthVTail)/viscosity;
RcutoffVTail = double(Rcutoff(VTailLength/12, kSkinRoughness));
if reynoldsNumberVTail > RcutoffVTail
    CfTurbulentVTail = double(CfTurbulent(RcutoffVTail, MCorrection));
else
    CfTurbulentVTail = double(CfTurbulent(reynoldsNumberVTail, MCorrection));
end

%Landing Gear
characteristicLengthLG = LGLength/39.37; %wing MAC
reynoldsNumberLG = (density*flightSpeed*characteristicLengthLG)/viscosity;
RcutoffLG = double(Rcutoff(LGLength/12, kSkinRoughness));
if reynoldsNumberLG > RcutoffLG
    CfTurbulentLG = double(CfTurbulent(RcutoffLG, MCorrection));
else
    CfTurbulentLG = double(CfTurbulent(reynoldsNumberLG, MCorrection));
end
CfArray = [CfTurbulentFuselage, CfTurbulentWing, CfTurbulentHTail, CfTurbulentVTail, CfTurbulentLG];



%Form Factor Drag

%Fuselage
FRFuselage = fuselageTotalLength/(fuselageMaximumWidth);
FFFuselage = double(FFBodies(FRFuselage));

%Wing
FFWing = double(FFLiftingDevices(xcmEstimate, tcPSU, wingSweep, MCorrection));

%Landing Gear
FFLG = double(FFLiftingDevices(xcmEstimate, tcPSU, wingSweep, MCorrection));


%Horizontal Tail
FFHorizontalTail = double(FFLiftingDevices(xcmEstimate, tcTail, tailSweep, MCorrection));


%Vertical Tail
FFWingVerticalTail = double(FFLiftingDevices(xcmEstimate, tcTail, tailSweep, MCorrection));


FFArray = [FFFuselage, FFWing, FFHorizontalTail, FFWingVerticalTail, FFLG];

%------------Intereference Drag------------
QArray = [1, 1, 1.04, 1.04]; %[Fuselage, Wing, HTail, VTail]


for i = 1:4
    for j = 1:length(flightSpeed)
        ComponentDragCoefficient(j, i) = CfArray(j+(i-1)*61)*FFArray(i)*wettedArray(i)/wingRefArea;
    end
end
    
    
    
%------------Landing Gear------------
%Determined using data from the Raymer
LGWheelFrontalArea = 1/12*1/6;
regularWheelDrag = 0.25;
wheelParasiticDrag = regularWheelDrag*LGWheelFrontalArea*2/wingRefArea;

%Streamline struct - 1/6 < t/c < 1/3
structDrag = 0.05;
LGStrutFrontalArea = 0.0208;
structParasiticDrag = structDrag*LGStrutFrontalArea/wingRefArea;
for i = 1:length(ComponentDragCoefficient)
    TotalDragCD0(i) = 1.05*(sum(ComponentDragCoefficient(i,1:4))+structParasiticDrag+wheelParasiticDrag);
end

%------------Induced Drag------------
OswaldEfficiencyFactor = double(e(aspectRatio));
OswaldEfficiencyFactorTail = double(e(aspectRatioHTail));
CDi = ClInFlight.^2/(pi*aspectRatio*OswaldEfficiencyFactor);
CDiTail = tailCL.^2/(pi*aspectRatioHTail*OswaldEfficiencyFactorTail);

for i = 1:length(TotalDragCD0)
    InducedDrag(i) = (0.5*density*flightSpeed(i)^2*(wingRefArea*inSquared2mSquared)*(CDi(i)))*0.2248;
    TrimDrag(i) = (0.5*density*flightSpeed(i)^2*(HTailRefArea*inSquared2mSquared)*(CDiTail(i)))*0.2248;
    ParasiticDrag(i) = (0.5*density*flightSpeed(i)^2*(wingRefArea*inSquared2mSquared)*(TotalDragCD0(i)))*0.2248;
    TotalDrag(i) = (0.5*density*flightSpeed(i)^2*(wingRefArea*inSquared2mSquared)*(TotalDragCD0(i)+CDi(i)+CDiTail(i)))*0.2248;
end


%--------------Graphing--------------
plot(flightSpeed.*2.237, TotalDrag, 'DisplayName', 'Total Drag');
hold on;
plot(flightSpeed.*2.237, InducedDrag, 'DisplayName', 'InducedDrag');
hold on;
plot(flightSpeed.*2.237, ParasiticDrag, 'DisplayName', 'Parasitic Drag');
hold on;
plot(flightSpeed.*2.237, TrimDrag, 'DisplayName', 'Trim Drag');
hold on;
plot(table(20:end, 1), table(20:end, 2)./16, 'DisplayName', 'Thrust');
xlabel('Flight Speed in mph');
ylabel('Drag/Thrust - lbs');
title('Drag/Thrust vs Flight Speed - Mission 2');
legend show;
