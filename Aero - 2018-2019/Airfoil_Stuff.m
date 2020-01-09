%Begin with opening the script
%NOTE: What are the initial units of XFLR5 - is it actually inches or?
format long %make sure variables dont get concatenated
A = readtable('NACA_4412.dat');
X = zeros(length(A.NACA), 1);
Y = zeros(length(A.x4412_1_), 1);
scaleFactor = 12;
wingLength = 2.5*12; %only works for rectangular wings
for i = 1:length(A.NACA)
    X(i) = A.NACA(i);
    Y(i) = A.x4412_1_(i);
end

%Part 1: Scale the Airfoil up to the right size
xScaled = scaled(X, scaleFactor); %12 inches
yScaled = scaled(Y, scaleFactor);

%Part 2: Area/Volume of the Airfoil
airfoilAREA = areaTrapizoidal(xScaled, yScaled); %Units: inches squared
wingVolume = airfoilAREA * wingLength; %Units: inches cubed
foamWeight = wingVolume/(12^3); %Units: lbs

%Part 3: Thickness at specific points
thicknessAileron = thickness(83, xScaled, yScaled, scaleFactor);

function y = scaled(array, scaleFactor)
y = scaleFactor*array;
end

%Method 1: Finding Airfoil Area
function z = areaTrapizoidal(xArray, yArray)
z = 0;
%upper half of the airfoil
for index = 1:floor(length(xArray)/2)
    height = xArray(index)-xArray(index+1);
    z = z + (1/2)*(yArray(index+1)+yArray(index))*height;
end

%lower half of the airfoil
for index = ceil(length(xArray)/2):length(xArray)-1
    height = abs(xArray(index+1))-abs(xArray(index));
    z = z+(1/2)*(abs(yArray(index+1))+abs(yArray(index)))*height;
end
end

function thiqq = thickness(percentage, xArray, yArray, scale)
thiqq = 0;
minVal = 100;
%find the minimum value
for indexI = 1:length(xArray)
    condition = sqrt((xArray(indexI)/scale)^2 - (percentage/100)^2);
    if condition < minVal %find the minimum value
        minVal = condition;
    end 
end

%find the thickness
for indexI = 1:length(xArray)
    condition = sqrt((xArray(indexI)/scale)^2 - (percentage/100)^2);
    if condition == minVal 
        thiqq = thiqq+abs(yArray(indexI));
    end 
end
end