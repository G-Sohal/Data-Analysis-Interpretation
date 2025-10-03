% Range of s: adjusted such that maxima can be viewed in graph
s = 1:1000;  
% Note s has to be integer though p is graphed on other real values too
% p_max(s):
p_max = 1 - (1 ./ (s.^(1./s)));

figure;
plot(s, p_max, 'LineWidth', 2);
xlabel('s');
ylabel('p_{max}(s)');
title('Plot of p_{max}(s) v/s s');
grid on;

% Finding the value of s when p becomes maximum
[p, i] = max(p_max);
s_max = s(i);

fprintf('Maximum p is %f and it occurs when s is %d', p, s_max);