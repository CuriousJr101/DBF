
%----Inputs
g = 9.81;   %(m/s) - Gravity
To = 191/3.5969431019354; %N - Static Thrust
T25 = 161/3.5969431019354; %N - Thrust at Takeoff Speed
W = 220/3.5969431019354;    %N - Weight of the aircraft
mu = 0.03; %Unitless - Friction Constant
Vi = 0; %m/s - Starting Speed
b = 5/3.81;
CLMax = 1.6;
rho = 1.225; %Density
S = (5:0.1:10)/10.764; %m^2 - Wing Ref Area
Vf = 1.2.*sqrt(W./(0.5.*rho.*S.*CLMax)); %m/s - Takeoff-Speed
Cl = 0.3; %Max Coefficient of Lift
Cd0 = 0.035; %Profile Drag
AR = b^2./S;
e = 1.78 .* (1 - (0.045 .* (AR .^ 0.68))) - 0.64; %E
K = 1 ./ (pi .* AR .* e);
CLg = 0.3;

a = -(T25-To)./Vf.^2;
A = ((To ./ W) - mu)*g;
B = (g ./ W) .* (0.5 .* rho .* S .* (Cd0 - mu .* Cl) + a);
Sg = (1 ./ (2 .* B)) .* log((A) ./ (A - (B .* (Vf .^ 2))));
t = 0.1; %s
Sr = Vf .* t;
TOD = Sg;
TOD = TOD .* 3.28084;
fprintf('Takeoff Distance: %6.4f ft.\n',TOD)

figure;
plot(5:0.1:10, TOD, '-', 'DisplayName', 'Estimate Method 1')
hold on;
line([5,10], [20, 20], 'DisplayName', "Take-off Distance Length");
hold on;
line([5,10], [16, 16], 'DisplayName', "Take-off Distance Length - DBF Defined");
title("TakeoffDistance with Changing Wing Area");
xlabel("Wing Area - ft^2");
ylabel("Takeoff Distance - ft");
legend show;

%------ESTIMATE - Nicolai-----
T1 = 161/3.5969431019354;
D = 0.5*rho*0.707*Vf.*S.*(Cd0+K.*CLg);
L = 0.5*rho*0.707*Vf.*S.*CLg;
a = g./W.*(T1-D-mu*(W-L));
SgNicolai = (0.5*(Vf.^2)./a) .* 3.28084;
plot(5:0.1:10, SgNicolai, '-', 'DisplayName', 'Estimate Method 2');