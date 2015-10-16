function [LL_living, prior_living, transmat_living, mu_living, Sigma_living, mixmat_living, ...
          LL_dead, prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead] = ...
                                  hmm_try1(data_living, data_dead)
O = 6;          %Number of coefficients in a vector 
M = 1;          %Number of mixtures 
Q = 8;          %Number of states 

### LIVING HMM
data0 = data_living;
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
[mu0, Sigma0] = mixgauss_init(Q*M, data0{2}, 'full', 'kmeans');
mu0 = reshape(mu0, [O Q M]);
Sigma0 = reshape(Sigma0, [O O Q M]);
mixmat0 = ones(Q, 1); #mixmat0 = mk_stochastic(rand(Q,M));

[LL_living, prior_living, transmat_living, mu_living, Sigma_living, mixmat_living] = ...
    mhmm_em(data0, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 100, 'verbose', 0);
 ### DEAD HMM
data1 = data_dead;
transmat1 = transmat0;
prior1 = prior0;

[mu1, Sigma1] = mixgauss_init(Q*M, data1{1}, 'full', 'kmeans');
mu1 = reshape(mu1, [O Q M]);
Sigma1 = reshape(Sigma1, [O O Q M]);
mixmat1 = ones(Q, 1); #mixmat1 = mk_stochastic(rand(Q,M));

[LL_dead, prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead] = ...
    mhmm_em(data1, prior1, transmat1, mu1, Sigma1, mixmat1, 'max_iter', 100, 'verbose', 0);

end