TR = 1; %Wing Taper Ratio
b = 5*0.3048; %Wing Span Length - ft*metersConversion
S = 5*0.092903; %Wing Area - ft^2*meters^2Conversion
Sh = 0.108387; %Horizontal Tail Area
Sv = 0.0425806; %Vertical Tail Area
AS = b^2/S; %Aspect Ratio
a1 = 0.5*1.75*0.3048; %Chord start
a2 = 0.9*1.75*0.3048; %Chord end
Cr = 1*0.3048; %Root Chord 
Tau = 0.36; %Control Surface Effectiveness (Based on a graph)
Claw = (2*pi*AS)/(2+sqrt(AS^2+4)); %Section Lift Coefficient of the alieron corrected in 3D space
%We can use an apporximation: (2piA)/(2+sqrt(A^2+4))
RDT = (-0.25)*((pi*AS)/(sqrt((AS^2/4)+4)+2)); %Roll Dampening Term Estimation
func = @(x)(1+2.*((TR-1)/b).*x).*x;
Ixx = 0.289824; %Moment of Inertia of the plane
p = 1.225; %Air density
Vt = 15; %True airspeed
delta = 10/57.2957795131; %Angle Deflection
yD = 0.4*2.5*0.3048; %Distance from the root to the Drag Center
CDr = 1.2; %Rolling Drag Coefficient (usually btwn 0.7-1.2)

disp('Method 1');
Cl_Der = ((2*Claw*Tau*Cr)/(S*b))*integral(func, a1, a2);
disp(['Cl Derivative: ' num2str(Cl_Der)]);
Lift_Alieron = (0.5)*p*Vt^2*S*Cl_Der*delta*b;
disp(['Aileron Lift: ' num2str(Lift_Alieron)]);
Steady_State_Roll_Rate = sqrt((2*Lift_Alieron)/(p*(S+Sh+Sv)*CDr*yD^3));
disp(['Steady State Roll Rate: ' num2str(Steady_State_Roll_Rate)]);
Phi = (Ixx*log(Steady_State_Roll_Rate^2))/(p*yD^3*(S+Sh+Sv)*CDr);
disp(['Bank Angle (degrees): ' num2str(Phi*57.2957795131)]);
Roll_Acceleration = Steady_State_Roll_Rate^2/(2*Phi);
disp(['Roll Acceleration (rads/sec^2): ' num2str(Roll_Acceleration)]);
time = sqrt((2*delta)/Roll_Acceleration);
disp(['Time to get to bank angle (' num2str(delta*57.2957795131) ') (seconds): ' num2str(time)]);
disp(' ');
disp('Method 2');
Roll_Speed = ((-2*Vt)/b)*(Claw/RDT)*(delta);
disp(['Roll Speed: ' num2str(Roll_Speed)])
