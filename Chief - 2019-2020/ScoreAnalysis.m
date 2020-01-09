pass = 1:1:40;


syms PASSNUM LAPTIME BANNERLENGTH NUMLAP

TS = 4 + (PASSNUM./(LAPTIME.*3))/maxValueMission2 + (BANNERLENGTH.*NUMLAP)/maxMissionScore3;

m2PassNum = diff(TS, PASSNUM);
m2laptime = diff(TS, LAPTIME);
m3bannerlength = diff(TS, BANNERLENGTH);
m3laptime = diff(TS, NUMLAP);




plot(x, m2PassNumChange*.100, 'DisplayName', 'Passangers');
hold on;
plot(x, m2LapTimeChange*.100, 'DisplayName', 'Time');
hold on;
plot(x, m2BannerLengthChange*.100, 'DisplayName', 'Banner Length');
gca 
legend show;