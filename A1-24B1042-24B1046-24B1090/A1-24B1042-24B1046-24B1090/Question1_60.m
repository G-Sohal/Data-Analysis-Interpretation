x = [-3:0.02:3];
y = 6.5*sin(2.1*x + pi/3);

z = y;

fraction = 0.6;
n = length(y);
num_points = round(n*fraction);

%using randperm to select a fraction
indices = randperm(n, num_points);
y_fraction = y(indices);

a = 100; b = 200;
r_noise = a + (b-a).*rand(1, num_points);

z(indices) = z(indices) + r_noise;

y_median = zeros(size(z));
y_average = zeros(size(z));
y_quartile = zeros(size(z));

for i = 1:n 
    start = max(1, i-8);
    finish = min(n, i+8);
    
    Ni = z(start:finish);
    %moving median filtering
    y_median(i) = median(Ni);

    %moving median filtering
    y_average(i) = mean(Ni);
    
    %moving quartile filtering
    y_quartile(i) = prctile(Ni, 5);
end

figure;
hold on;
plot(x, y, 'b');
plot(x, z, 'r');
plot(x, y_median, 'g');
plot(x, y_average, 'm');
plot(x, y_quartile, 'c');
xlabel('X-axis');
ylabel('Y-axis');
legend('Original', 'Corrupted with noise', 'Moving Median Filter', 'Moving Average Filter', 'Moving Quartile Filter');
title('Data Analysis with Noise');
hold off;

denominator = sum(y.^2);
rmse_median = sum((y - y_median).^2)/denominator;
rmse_average = sum((y - y_average).^2)/denominator;
rmse_quartile = sum((y - y_quartile).^2)/denominator;

fprintf('RMSE: median = %f, average = %f, quartile = %f', rmse_median, rmse_average, rmse_quartile)