function [y, y_var] = posterior_predictive(phi_test, mean_n, std_n, beta)
y = phi_test * mean_n;
y_var = 1/beta + sum(phi_test * std_n .* phi_test, 2);
end