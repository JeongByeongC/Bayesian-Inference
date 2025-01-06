function [alpha, beta, mean_n, std_n] = fit(phi, t, varargin)
% Bayesian inference 코드
% alpha와 beta를 모르는 상태에서 alpha와 beta를 업데이트하여 fitting을 진행하는 코드
% PRML과 Use it improve it or loss it 논문을 참고하여 코드를 작성
% InitAlpha = alpha값을 모를 때 초기 alpha 값 설정
% InitBeta = beta값을 모를 때 초기 beta 값 설정
% PriorMean = prior 분포의 평균 설정
% MAxiter = alpha & beta 추정을 위한 반복 횟수 설정
% rtol & atol = relative & absolute tolerance, alpha와 beta의 변화량이 얼만큼 줄어들면 멈출지 결정하는 변수

if nargin < 2
    error('Incorrect call to fit: need phi and target data');
end

r = parse_input(varargin{:});
alpha_ = r.InitAlpha;
beta_ = r.InitBeta;
prior_mean = r.PriorMean;
max_iter = r.Maxiter;
rtol = r.rtol;
atol = r.atol;

fprintf('Initial alpha is %e\n', alpha_);
fprintf('Initial beta is %e\n', beta_);
fprintf('Mean of prior distribution is %e\n', prior_mean);
fprintf('Maximum iteration is %d\n', max_iter);
fprintf('Relative tolerance is %e\n', rtol);
fprintf('Absolute tolerance is %e\n', atol);

[L, M] = size(phi);

[~, Eval] = eig(phi' * phi);
eigenvalues_0 = sum(Eval, 2);

for i=1:max_iter
    alpha_prev = alpha_;
    beta_prev = beta_;
    
    eigenvalues = eigenvalues_0 * beta_;
    
    [mean_n_, std_n_, ~] = posterior(phi, t, alpha_, beta_);
    
    gamma = sum(eigenvalues./(eigenvalues + alpha_));
    
    alpha_ = gamma / sum((mean_n_ - prior_mean).^2);
    
    beta_ = (L - gamma) / sum((t - phi*mean_n_).^2);
    
    is_alpha_closed = isclose(alpha_prev, alpha_, rtol, atol);
    is_beta_closed = isclose(beta_prev, beta_, rtol, atol);
    
    if is_alpha_closed && is_beta_closed
        if r.verbose
            fprintf('Convergecne after %d interations.\n', i+1);
        end
        break
    end
end
if r.verbose && i == max_iter
    fprintf('Stopped after %d iterations.\n', max_iter);
end
alpha = alpha_;
beta = beta_;
std_n = std_n_;
mean_n = mean_n_;
end

%% ------------------private fuctions ------------------------
function [r, UD] = parse_input(varargin)
p = inputParser;
p.addParamValue('InitAlpha', 1e-05, @isnumeric);
p.addParamValue('InitBeta', 1e-05, @isnumeric);
p.addParamValue('PriorMean', 0, @isnumeric);
p.addParamValue('Maxiter', 200, @isnumeric);
p.addParamValue('rtol', 1e-05, @isnumeric);
p.addParamValue('atol', 1e-08, @isnumeric);
p.addParamValue('verbose', 1, @isnumeric);

p.parse(varargin{:});
r = p.Results;
UD = p.UsingDefaults;
end