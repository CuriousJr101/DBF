syms epsi V %turn rate, aircraft velocity

nLoad = @(epsi, V) sqrt((epsi.*V./9.81).^2 + 1);

velocityRange = 0.5:0.5:30; %m/s - max is ~70 mph (from drag build up estimate)
turnRateRange = 0:0.1:pi; %rads/s

%ConversionRates
rads2deg = 57.3; %radians to degrees
mps2mph = 2.237;

for i = 1:length(velocityRange)
    for j = 1:length(turnRateRange)
        nLoads(j,i) = nLoad(velocityRange(i), turnRateRange(j)); %turnRate rows, velocity columns
    end
end

%plot 1: turnRate (deg) vs nLoads
plot(turnRateRange.*57.3, nLoads(:,40), 'DisplayName', 'Tangential Velocity - 45mph');
hold on;
plot(turnRateRange.*57.3, nLoads(:,20), 'DisplayName', 'Tangential Velocity - 22mph');
xlabel('Turn Rate (deg)');
ylabel('G-Load');
legend show;

%Search for 5G turn loads:
fileID = fopen('dataOutputFiles/Aerodynamics/5GTurns.txt', 'w');
for i = 1:length(velocityRange)
    for j = 1:length(turnRateRange)
        if nLoads(j,i) >= 5 && nLoads(j,i) <= 6
            fprintf(fileID, 'G-Load: %f --> Turn Rate: %f | Velocity: %f\n', nLoads(j,i), turnRateRange(j)*rads2deg, velocityRange(i)*mps2mph);
        end 
    end
end
fclose(fileID);

