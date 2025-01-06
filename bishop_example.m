%% p155, ch3.3 bayesian linear regression
clc;clear all;close all;

N_list = [0, 1, 3, 20];
beta_known = 25;
alpha_known = 2.0;


% training observations in [-1, 1) for multiple data observation
X = rand(N_list(end), 1) * 2 - 1;
% target data
t = f(X, 0.2);

% for ture line
x_test = linspace(-1, 1, 100)';
y_true = f(x_test, 0);

% design matrix, 워드에서의 phi
phi0 = @(x) ones(size(x));
phi1 = @(x) x;

% for posterior check
phi_test = [phi0(x_test), phi1(x_test)];

[w0, w1] = meshgrid(linspace(-1, 1, 100), linspace(-1, 1, 100));
w = cat(3, w0, w1);
W = reshape(w,[], 2);

% alpha와 beta를 알 때 data의 수에 따른 fitting 결과를 확인하는 예제
for i=1:length(N_list)
    x_n = X(1:N_list(i));
    t_n = t(1:N_list(i));
    phi_n = [phi0(x_n), phi1(x_n)];

    if N_list(i) == 0
        mean_n = zeros(size(phi_n, 2), 1);
        std_n = eye(size(phi_n, 2));
    else
        [mean_n, std_n, ~] = posterior(phi_n, t_n, alpha_known, beta_known);
    end

    [y, y_var] = posterior_predictive(phi_test, mean_n, std_n, beta_known);
    y_std = sqrt(y_var);
    w_sample = mvnrnd(mean_n, std_n, 6);
    y_sample = phi_test * w_sample';

    % likelihood
    if i ~= 1
        lik = likelihood(100, t_n(end), x_n(end), beta_known);
        subplot(length(N_list), 4, (i-1)*4+1)
        contourf(w1, w0,lik);
        hold on;
        scatter(-0.3, 0.5, 'w+', 'LineWidth', 7);
        xlabel('W0');
        ylabel('W1');
        if i == 2
            title('Likelihood');
        end
        hold off;
    end

    % heatmap
    figure(2)
    densities = mvnpdf(W, mean_n', std_n);
    densities = reshape(densities, 100, 100);
    subplot(length(N_list), 4, (i-1)*4+2)
    hold on;
    contourf(w0, w1, densities);
    colormap('jet');
    scatter(-0.3, 0.5, 'w+', 'LineWidth', 7);
    xlabel('W0');
    ylabel('W1');
    if i == 1
        title('Prior/Posterior');
    end
    hold off;

    % 6 sample line
    subplot(length(N_list), 4, (i-1)*4+3)
    scatter(x_n, t_n, 'ko');
    hold on;
    plot(x_test,y_true, 'k--');
    ylim([-1 1]);
    for j=1:6
        plot(x_test, y_sample(:, j), 'r-');
    end
    xlabel('X');
    ylabel('Y');
    if i == 1
        title('Sample 6 lines');
    end
    legend('Data', 'True', 'Sample', 'Orientation', 'horizontal');
    hold off;

    % uncertentity
    subplot(length(N_list), 4, (i-1)*4+4)
    scatter(x_n, t_n, 'ko');
    hold on;
    plot(x_test,y_true, 'k--');
    plot(x_test, y, 'b');
    ylim([-1 1]);
    c1 = y + sqrt(y_var);
    c2 = y - sqrt(y_var);
    x2 = [x_test', fliplr(x_test')];
    inBetween = [c1', fliplr(c2')];
    patch(x2, inBetween, 'r', 'FaceAlpha', 0.4);
    xlabel('X');
    ylabel('Y');
    if i == 1
        title('Mean & std of prediction');
    end
    hold off;
end
set(gcf, 'Color', [1, 1, 1], 'Position', get(0, 'Screensize'));
% saveas(gcf, './lik_post_sample_variance.png');


%% alpha와 beta를 모르고 데이터 수가 3개 밖에 안될 때 fitting되는 예제

% data for fit
X4fit = rand(N_list(3),1) * 2 - 1;
t4fit = f(X4fit, 1/beta_known);

% for fitting
phi4fit = [phi0(X4fit), phi1(X4fit)];

[alpha, beta, mean_n_fit, std_n_fit] = fit(phi4fit, t4fit);
[y, y_var] = posterior_predictive(phi_test, mean_n_fit, std_n_fit, beta);
densities4fit = mvnpdf(W, mean_n_fit', std_n_fit);
densities4fit = reshape(densities4fit, 100, 100);
figure(1)
subplot(121)
hold on;
contourf(w0, w1, densities4fit);
colormap('jet');
scatter(-0.3, 0.5, 'w+', 'LineWidth', 2);
xlabel('W0');
ylabel('W1');
axis equal;
hold off;

subplot(122)
ylim([-1 1]);
xlim([-1 1]);
scatter(X4fit, t4fit, 'ko');
hold on;
plot(x_test,y_true, 'k--');
plot(x_test, y, 'b');
c1 = y + sqrt(y_var);
c2 = y - sqrt(y_var);
x2 = [x_test', fliplr(x_test')];
inBetween = [c1', fliplr(c2')];
patch(x2, inBetween, 'r', 'FaceAlpha', 0.4);
title(sprintf('W0 = %f, W1 = %f', mean_n_fit(1), mean_n_fit(2)));
legend('Data', 'True', 'predicted line', 'uncertentiy');
xlabel('X');
ylabel('Y');
hold off;
set(gcf, 'Color', [1, 1, 1], 'Position', get(0, 'Screensize'));
% saveas(gcf, './fitting_with_3_data.png');

