Cvt = 0.04; 
Cht = 0.5;
Lht = [2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75];
Lvt = [2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75];

%wing parameters
bw = 4.5;
Sw = 4.5;
MACw = 1;

%Getting sizing values
Svt = (Cvt.*bw.*Sw)./Lvt;
Sht = (Cht.*MACw.*Sw)./Lht;
figure;
plot(Lht, Sht, '-o', 'DisplayName', 'Horizontal Tail');
hold on;
plot(Lvt, Svt, '-o', 'DisplayName', 'Vertical Tail');
ylabel('Ref Area (ft^2)');
xlabel('Distance');
legend show;

Chtroot = 1;
Cvtroot = 1;
TR = 0.1;
Chttip = Chtroot*TR;
Cvttip = Cvtroot*TR;
lengthHT = (Sht * 2)/(Chttip + Chtroot); %semi-span
lengthVT = (Svt * 2)/(Cvttip + Cvtroot);

figure;
plot(lengthHT, Sht, '-o', 'DisplayName', 'Horizontal Tail Length');
hold on;
plot(lengthVT, Svt, '-o', 'DisplayName', 'Vertical Tail Width');
ylabel('Length of Tail');
xlabel('Ref Area');
legend show;
