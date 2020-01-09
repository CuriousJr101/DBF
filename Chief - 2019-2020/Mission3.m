banner = 10:1:200;
laps = 1:1:30;
missionScore = zeros(length(laps), length(banner));

for i = 1:length(laps)
    for j = 1:length(banner)
        missionScore(i,j) = (banner(j)*laps(i));
    end
end

missionScore = 2 + missionScore ./ max(max(missionScore));

%----Drag on Banner----
DragBanner = 15; %Newtons 
rho = 1.225; %kg/m^3
Sref = 1250/1550.003; %m^2
V = 38/2.237; %m/s
CdBanner = 15/(0.5*V^2*rho*Sref);

for i = 1:length(laps)
    for j = 1:length(banner)
        EstimatedDragBanner(i,j) = (0.5*rho*(762*laps(i)/600)^2*CdBanner*((banner(j)/39.37)^2/5))/4.448;
    end
end


%-----Flight Speed-----
figure;
for i = 1:4
    plot(banner, (missionScore(11+(4*(i)), :) - missionScore(11+(4*(i-1)), :))./missionScore(11+(4*(i-1)), :), 'DisplayName', ['Number of Laps ' num2str(11+(4*(i)))]);
    hold on;
end
xlabel('Banner Length');
ylabel('Mission Score - Percent Change');
legend show;

figure;
for i = 1:4
    plot(banner, EstimatedDragBanner(11+(4*(i)), :), 'DisplayName', ['Banner Drag - Number of Laps ' num2str(11+(4*(i)))]);
    hold on;
end
xlabel('Banner Length');
ylabel('Banner Estimated Drag');
legend show;

figure;
surf(missionScore);
ylabel('Number of Laps');
xlabel('Banner Length - Inches');
zlabel('Score');
figure;
surf(EstimatedDragBanner);
hold on;
surf(5);
xlabel('Banner Length - Inches');
ylabel('Number of Laps');
zlabel('Estimated Drag - lbs');