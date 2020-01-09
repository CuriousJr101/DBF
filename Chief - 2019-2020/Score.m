function [TS] = Score(PYLD, PASS, M2, M3)

% RS = Report Score
% TMS = Total Mission Score
% RAC = Rated Aircraft Cost
% TS = Total Score
% M1 = Mission 1 (etc. for M2, M3)

% EWmax = empty weight max
% WS = wing span
% PYLD = payload weight (oz)
% PASS = number of passengers 

RS = 90;

M1 = 1.0;
M2 = 1 + ((PASS./M2)/(0.6667)); %fastest is 3 laps in 2.3 min, avg is 3 laps in 4 min
M3 = 2 + ((PASS * PYLD * M3) / (16 * 20 * 20)); %avg is 5 laps, 3 pucks. max is 6 laps, 7 pucks.


% Calculates Total Mission Score, this number is also a constant 
TMS = M1 + M2 + M3;
end