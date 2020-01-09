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

xlabel('Passenger Number');
ylabel('Additional Passanger Weight');
legend show;

figure;
surf(missionScore);
ylabel('Lap Speed - Seconds');
xlabel('Passenger Number');
zlabel('Score');
hold on;
saveas(gcf, 'Mission_2_3D_Plot.png');