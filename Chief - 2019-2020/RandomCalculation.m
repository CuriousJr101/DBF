weight = (8.5/2.205)*9.81;
density = 1.225;
wingArea = 7/10.764;
CLMax = 1.3;

stallSpeed = sqrt(weight/(0.5*density*wingArea*CLMax))2.23694; %stall speed in metric form
wingLoading = ((weight)/wingArea); % UNITS: kg/m^2