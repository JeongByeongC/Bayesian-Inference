function lik = likelihood(N, t_n, x_n, beta)
lik = zeros(N, N);
w0 = linspace(-1, 1, N);
w1 = linspace(-1, 1, N);
for xt = 1:N
    for yt = 1:N
        w = [w0(xt), w1(yt)];
        gx = w(1) + w(2) * x_n;
        lik(xt, yt) = normpdf(t_n, gx, sqrt(1/beta));
    end
end
end