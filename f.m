function t = f(X, noise_variance)
% tutorial을 위한 예시 함수
f_w0 = -0.3;
f_w1 = 0.5;
t = f_w0 + f_w1 * X + (rand(size(X, 1), 1) * noise_variance);
end