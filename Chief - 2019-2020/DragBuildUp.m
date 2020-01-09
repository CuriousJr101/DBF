%Functions
syms R M l k FR xcm tc sweep A
CfTurbulent(R, M) = 0.455/(log10(R)^2.58*(1+0.144*M^2)^0.65);
Rcutoff(l,k) = 38.21*(l/k)^1.053; %l in terms of feet
FFBodies(FR) = 1+60/FR^3+0.0025*FR;
FFLiftingDevices(xcm, tc, sweep, M) = (1+(0.6/xcm)*tc+100*tc^4)*(1.34*M^0.18*cos(sweep)^0.28);
e(A) = 1.78*(1-0.045*A^0.68)-0.64;

viscosity = 1.48*10^-5; %m^2/s at 15C
density = 1.225; %kgm^2s^-1
flightSpeed = (20:1:80)./2.237; %m/s
kSkinRoughness = 0.17*10^-5; %Skin roughness value
MCorrection = 1; %Mach Number correction

fuselageTotalLength = 47; %in
fuselageMaximumWidth = 3.5; %in
fuselageMaximumHeight = 4.5; %in
fuselageWettedArea = 460; %in^2

HTailLength = 12; %in
VTailLength = 10; %in
LGLength = 1.6425; %in

xcmEstimate = 0.3;
wingMAC = 12; %in
wingChord = 12; %in
wingLength = 60; %in
tcPSU = 0.097;
wingSweep = 0;
wingRefArea = wingChord*wingLength;
wingWettedArea = wingRefArea*(1.977+0.52*tcPSU);
aspectRatio = wingLength^2/wingRefArea;
ClInFlight = 0.445;

tcTail = 0.09;
tailSweep = 0;
HtailRefArea = 6*(4+10);
VtailRefArea = 10*(4+10)/2;
HTailWettedArea = HtailRefArea*(1.977+0.52*tcTail);
VTailWettedArea = VtailRefArea*(1.977+0.52*tcTail);



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
characteristicLengthHTail = HTailLength/39.37; %wing MAC
reynoldsNumberHTail = (density*flightSpeed*characteristicLengthHTail)/viscosity;
RcutoffHTail = double(Rcutoff(HTailLength/12, kSkinRoughness));
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


FFArray = [FFFuselage, FFWing, FFHorizontalTail, FFWingVerticalTail];

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
LGStrutFrontalArea = 0.0434;
structParasiticDrag = structDrag*LGStrutFrontalArea/wingRefArea;

TotalDrag0 = 1.05*(sum(ComponentDragCoefficient)+structParasiticDrag+wheelParasiticDrag);


%------------Induced Drag------------
OswaldEfficiencyFactor = double(e(aspectRatio));
CDi = ClInFlight^2/(pi*aspectRatio*OswaldEfficiencyFactor);

TotalDrag = TotalDrag0+CDi;





%--------------Graphing--------------
%1). Constant alpha of 1 degree


    