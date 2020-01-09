figure;
func = @(x) x;
func2 = @(x) 1/x;
fplot(func, [1, 80]);
hold on
fplot(func2, [1, 80]);