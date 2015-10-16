function [LL_combined, prior_combined, transmat_combined, mu_combined, Sigma_combined, mixmat_combined] = ...
                                  hmm_try2(data_combined)
O = 6;          %Number of coefficients in a vector 
M = 1;          %Number of mixtures 
Q = 8;          %Number of states 

### LIVING HMM
data0 = data_combined;
%prior0 = [0.5 0.5];
%transmat0 = [0.5 0.5 ; 0.5 0.5];
prior0 = [0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
         ];
transmat0 = [0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125;
             ];
[mu0, Sigma0] = mixgauss_init(Q*M, data0{1}, 'full', 'kmeans');
mu0 = reshape(mu0, [O Q M]);
Sigma0 = reshape(Sigma0, [O O Q M]);
mixmat0 = ones(Q, 1); #mixmat0 = mk_stochastic(rand(Q,M));

[LL_combined, prior_combined, transmat_combined, mu_combined, Sigma_combined, mixmat_combined] = ...
    mhmm_em(data0, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 100, 'verbose', 1);
end