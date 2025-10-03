n = 1000;
p_values = [1e-4, 5e-4, 1e-3, 5e-3, 0.01, 0.02, 0.05, 0.08, 0.1, 0.2];
T1_method = zeros(size(p_values));  % Method 1 
T2_method = zeros(size(p_values));  % Method 2 

for i = 1:length(p_values)
    p = p_values(i);
    
    % Optimal s from (a)(ii)
    s_opt = round(sqrt(n / p));
    % Expected tests from (a)(i)
    T1_method(i) = n/s_opt + n*(1 - (1 - p)^s_opt);
    
    % Optimal π from (b)(ii)
    pi_opt = 1/(n * p);
    
    % Define α = π(1 - pπ)^(n-1)
    alpha = pi_opt * (1 - p*pi_opt)^(n-1);
    
    % For very small p, use approximation from (b)(v)
    if p < 0.001
        % Optimal T1 from general form (b)(v)
        T1_star = (1/alpha) * log(n*(1-p)*alpha);
        T1_star = max(1, round(T1_star));
        
        T2_method(i) = T1_star + n*p + 1/alpha;
    else
        % For larger p, use exact numerical optimization
        T2_func = @(T1_val) T1_val + n * (p + (1-p) * (1 - alpha)^T1_val);
        
        T1_range = 1:100;
        T2_candidates = arrayfun(T2_func, T1_range);
        [min_val, idx] = min(T2_candidates);
        T2_method(i) = min_val;
    end
end

%% Plot Results
figure;
semilogx(p_values, T1_method, 'o-', 'LineWidth', 1, 'DisplayName', 'Method 1');
hold on;
semilogx(p_values, T2_method, 's-', 'LineWidth', 1, 'DisplayName', 'Method 2 ');
semilogx(p_values, n*ones(size(p_values)), '--', 'LineWidth', 1, 'DisplayName', 'Individual Testing');

xlabel('Prevalence Rate (p)');
ylabel('Expected Number of Tests');
title('Expected Tests vs. p');
legend('Location', 'southeast');
grid on;

%% Display Results in Table
fprintf('Prevalence (p)\tMethod 1\tMethod 2\n');
fprintf('---------------------------------------------\n');
for i = 1:length(p_values)
    fprintf('%10.4f\t%8.1f\t%8.1f\n', p_values(i), T1_method(i), T2_method(i));
end