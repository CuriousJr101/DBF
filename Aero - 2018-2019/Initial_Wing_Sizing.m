%NACA 4412 - No flaps
Vtko_mph = 17;
Vtko = Vtko_mph*1.467;
Vtko_mps = Vtko*0.3048;
Vstall = Vtko/1.2;
Vstall_mps = Vstall*0.3048;
totalWeight = 8;
CLmax = 1.5*0.9;
wingLoading = (1/2)*(0.0023769)*(Vstall)^2*(CLmax);
Sref = totalWeight/wingLoading;
GroundRoll = (1/2)*(5*4.45/9.81*8^2)*1/(33.89 - 2);