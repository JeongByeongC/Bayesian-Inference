function [mean_n, std_n, std_n_inv] = posterior(phi, t, alpha, beta)
% PRML 챕터 3과 Use it and imporove it or lose it 논문 내용에 따라 posterior의 평균과 분산을 구하는 코드
std_n_inv = alpha * eye(size(phi, 2)) + beta * phi'*phi;
std_n = inv(std_n_inv);
mean_n = beta * std_n * phi'*t;
end