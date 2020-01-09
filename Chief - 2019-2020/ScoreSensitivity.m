 

%Mission 2 Score Analysis

passNum = 1:1:40;
missionTimePERLAP = 20:1:60;
missionScore = zeros(length(missionTimePERLAP), length(passNum));

for i = 1:length(missionTimePERLAP)
    for j = 1:length(passNum)
        missionScore(i,j) = passNum(j)/(missionTimePERLAP(i)*3);
    end
end

%passnumber = 6;
maxValueMission2 = max(max(missionScore));
missionScore = 1 + missionScore./maxValueMission2;
%flightTime = 30;

figure;
for i = 1:5
    plot(missionTimePERLAP, (missionScore(:, 11+(4*(i-1))) - missionScore(:, 6))./missionScore(:, 6), 'DisplayName', ['Number of Passangers ' num2str(11+(4*(i-1)))]);
    hold on;
end
xlabel('Flight Speed per Lap');
ylabel('Mission Score - Percent Change');
legend show;


figure;
for i = 1:5
    plot(passNum, (missionScore((4*(i)), :) - missionScore(31, :))./missionScore(31, :), 'DisplayName', ['Lap Speed ' num2str(missionTimePERLAP(4*(i)))]);
    hold on;
end

ylabel('Mission Score - Percent Change');

hold on;
yyaxis right;
plot(passNum, passNum.*(5/16), '-', 'DisplayName', 'Weight');

xlabel('Passanger Number');
ylabel('Additional Passanger Weight');
legend show;

figure;
surf(missionScore);
ylabel('Lap Speed - Seconds');
xlabel('Passenger Number');
zlabel('Score');
hold on;
saveas(gcf, 'Mission_2_3D_Plot.png');

%-------------------------------------------------------------

% Mission 3 Score Analysis
banner = 10:1:100;
laps = 1:1:30;
missionScore = zeros(length(laps), length(banner));

for i = 1:length(laps)
    for j = 1:length(banner)
        missionScore(i,j) = (banner(j)*laps(i));
    end
end

maxMissionScore3 = max(max(missionScore));
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
xlabel('Banner Length - Inches');
ylabel('Number of Laps');
zlabel('Estimated Drag - lbs');

%------------------------------------------------------------

syms PASSNUM LAPTIME BANNERLENGTH NUMLAP

M1 = 1; %Completing Mission 1
M2(PASSNUM, LAPTIME) = 1 + (PASSNUM./(LAPTIME.*3))/maxValueMission2;
M3(BANNERLENGTH, NUMLAP) = 2 + (BANNERLENGTH.*NUMLAP)/maxMissionScore3;

m2PassNum = diff(M2, PASSNUM);
m2laptime = diff(M2, LAPTIME);
m3bannerlength = diff(M3, BANNERLENGTH);
m3laptime = diff(M3, NUMLAP);

figure;
fsurf((abs(m2PassNum) + abs(m2laptime))*100, [1 40, 20, 60]);
zlabel('Precent Change in Score [%]');
ylabel('Single Lap Time [s]');
xlabel('Passenger QTY');
title('M2 Score Sensitivity Plot');
saveas(gcf, 'M2ScoreSensitivity.png');

figure;
fsurf((abs(m3bannerlength) + abs(m3laptime))*100, [10 100, 1 30]);
zlabel('Percent Change in Score [%]');
ylabel('Laps');
title('M3 Score Sensitivity Plot');
xlabel('Banner Length (in)');
saveas(gcf, 'M3ScoreSensitivity.png');
