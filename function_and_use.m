clc;clear; close all;

%% load daata
load('./meta_1105.mat');
ID = unique(meta.ID);

%% data preprocessing
%% read data and normalize them
id_idx = 1;
idx = find(ismember(meta.ID, ID(id_idx)));

aff_use = meta.free_aff_succ_num(idx);
unaff_use = meta.free_unaff_succ_num(idx);

norm_aff_use = aff_use ./ 90;
norm_unaff_use = unaff_use ./ 90;

aff_fun = meta.forced_aff_succ_num(idx);
unaff_fun = meta.forced_unaff_succ_num(idx);

norm_aff_fun = aff_fun ./ 45;
norm_unaff_fun = unaff_fun ./ 45;

succ_str = meta.train_func_last_aff_succ_str(idx);
norm_succ_str = succ_str ./ 100;

%% Yukikazu use model => use(t+1) = 1 / (1 + exp(-(w2*(function(t) - w3))))

Y_USE1 = @(t) log(norm_aff_use(t) ./ (1 - norm_aff_use(t)));
phi1 = @(t) norm_aff_fun(t-1);
phi2 = @(t) -1 * ones(size(t, 2), 1);

Y1 = Y_USE1(3:10);
USE1_PHI = [phi1(3:10), phi2(3:10)];

% parameter estimation
[USE1_alpha, USE1_beta, USE1_mean, USE1_std] = fit(USE1_PHI, Y1, 'PriorMean', 1);

% Likelihood, AIC, BIC calculation
L = size(USE1_PHI, 1);
SE_llk = (L/2)*log(USE1_beta/(2*pi)) - ((USE1_beta/2) * (Y1 - USE1_PHI*USE1_mean)' * (Y1 - USE1_PHI*USE1_mean));
SE_aic = (-2/L)*SE_llk + 2*(length(USE1_mean)/L);
SE_bic = -2*SE_llk + log(L)*length(USE1_mean);


%% Use model => use(t+1) = w1*use(t) + w2*function(t) + w3*Success_strength(t) + w4

y_USE2 = @(t) norm_aff_use(t);
phi1 = @(t) norm_aff_use(t-1);
phi2 = @(t) norm_aff_fun(t-1);
phi3 = @(t) norm_succ_str(t-1);
phi4 = @(t) ones(size(t, 2), 1);

Y2 = y_USE2(3:10);
USE2_PHI = [phi1(3:10), phi2(3:10), phi3(3:10), phi4(3:10)];

% parameter estimation
[USE2_alpha, USE2_beta, USE2_mean, USE2_std] = fit(USE2_PHI, Y2, 'PriorMean', 0);

% Likelihood, AIC, BIC calculation
L = size(USE2_PHI, 1);
SE_llk = (L/2)*log(USE2_beta/(2*pi)) - ((USE2_beta/2) * (Y2 - USE2_PHI*USE2_mean)' * (Y2 - USE2_PHI*USE2_mean));
SE_aic = (-2/L)*SE_llk + 2*(length(USE2_mean)/L);
SE_bic = -2*SE_llk + log(L)*length(USE2_mean);

%% Function model => function(t+1) = (1 - w1)*function(t) + w1*use(t)

y_FUN = @(t) norm_aff_fun(t) - norm_aff_fun(t-1);
FUN_phi1 = @(t) norm_aff_use(t-1) - norm_aff_fun(t-1);

Y3 = y_FUN(3:10);
FUN_PHI = FUN_phi1(3:10);

% parameter estimation
[FUN_alpha, FUN_beta, FUN_mean, FUN_std] = fit(FUN_PHI, Y3, 'PriorMean', 1);

% Likelihood, AIC, BIC calculation
L = size(FUN_PHI, 1);
FUN_llk = (L/2)*log(FUN_beta/(2*pi)) - ((FUN_beta/2) * (Y3 - FUN_PHI*FUN_mean)' * (Y3 - FUN_PHI*FUN_mean));
FUN_aic = (-2/L)*FUN_llk + 2*(length(FUN_mean)/L);
FUN_bic = -2*FUN_llk + log(L)*length(FUN_mean);

%% simulation with estimated parameters
USE1_sim = zeros(9, 1);
USE1_sim(1) = norm_aff_use(2);

USE2_sim = zeros(9, 1);
USE2_sim(1) = norm_aff_use(2);

FUN_sim = zeros(9, 1);
FUN_sim(1) = norm_aff_fun(2);

str_succ_sim = norm_succ_str(2:9);

for i=1:size(USE2_sim, 1) - 1
    USE1_sim(i+1) = 1 ./ (1 + exp(-(USE1_mean(1) * FUN_sim(i) - USE1_mean(2))));
    USE2_sim(i+1) = USE2_mean(1)* USE2_sim(i) + USE2_mean(2)*FUN_sim(i) + USE2_mean(3)*str_succ_sim(i) + USE2_mean(4);
    FUN_sim(i+1) = FUN_sim(i) + FUN_mean(1) * (USE2_sim(i) - FUN_sim(i));
end

%% plot simulation results
figure(1);
plot(norm_aff_use(2:10), 'b.-', 'MarkerSize', 20, 'LineWidth', 3);
hold on;
plot(USE1_sim, 'r.-', 'MarkerSize', 20, 'LineWidth', 3);
hold off;
title('Yukikazu use model');
xticklabels([2, 3, 4, 5, 6, 7, 8, 9, 10]);
ylim([-0.2 1]);
legend('True', 'Simulation');

figure(2);
plot(norm_aff_use(2:10), 'b.-', 'MarkerSize', 20, 'LineWidth', 3);
hold on;
plot(USE2_sim, 'r.-', 'MarkerSize', 20, 'LineWidth', 3);
hold off;
title('Our use model');
xticklabels([2, 3, 4, 5, 6, 7, 8, 9, 10]);
ylim([-0.2 1]);
legend('True', 'Simulation');

figure(3);
plot(norm_aff_fun(2:10), 'b.-', 'MarkerSize', 20, 'LineWidth', 3);
hold on;
plot(FUN_sim, 'r.-', 'MarkerSize', 20, 'LineWidth', 3);
hold off;
title('Ours Function model');
xticklabels([2, 3, 4, 5, 6, 7, 8, 9, 10]);
ylim([-0.2 1]);
legend('True', 'Simulation');


