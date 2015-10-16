  obslik = mixgauss_prob(data_train(1:1, 1), mu_combined, Sigma_combined, mixmat_combined);
%  [alpha, beta, gamma, ll] = fwdback(prior_combined, transmat_combined, obslik)