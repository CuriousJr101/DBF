p = 1.225;
g = 9.81;
Vcruise = 20;
forceLift = 31.1376; %cruise flight (7lbs)
weight = 3.17515;
Cl0 = 0.5;
Cl = 0.01; %This value needs to be adjusted
Cdo = 0.0055; %Single engine light aircraft
span = 0.91:0.01:1.83;
thrustToWeight = 0.85;
Vto = 7;
u = 0.03;
Sref = 0.28:0.01:0.46;
aspectRatio = zeros(1, length(Sref));
wingLoading = zeros(1, length(Sref));
groundRoll = zeros(1, length(Sref));
%Sref = (2*forceLift)/(p*(Vcruise^2)*Cl0);
for j = span 
    index = 1;
    for i = Sref
        aspectRatio(index) = j^2/i;
        e = 1.78*(1 - 0.045*aspectRatio(index)^0.68)-0.64;
        K = 1/(pi*aspectRatio(index)*e);
        wingL = weight/i;
        wingLoading(index) = wingL;
        groundFunc = @(V) V/(g*((thrustToWeight - u) + (p/(2*wingL))*(-Cdo-K*Cl^2 + u*Cl)*V.^2));
        groundRoll(index) = integral(groundFunc, 0, Vto, 'ArrayValued', true);
        index = index + 1;
        %disp(['Wing Span (ft): ' num2str(j*3.218)]);
        %disp(['Wing Chord (ft): ' num2str(i/(j*3.218))]);
        %disp(['Aspect Ratio: ' num2str(aspectRatio)]);
        %disp(['Wing Loading: ' num2str(wingLoading)]);
        disp(['Ground Roll: ' num2str(groundRoll)]);
        %disp('---------------------------');
    end
    %plot(Sref, aspectRatio, 'Color', 'r');
    %hold on;
    plot(Sref, wingLoading, 'Color', 'b');
    hold on;
    %plot(Sref, groundRoll, 'Color', 'y');
    %hold on;
end