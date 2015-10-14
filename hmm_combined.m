# read;
# init;
O = 6;          %Number of coefficients in a vector 
#T = 420;         %Number of vectors in a sequence 
#nex = ;        %Number of sequences 
M = 1;          %Number of mixtures 
Q = 2;          %Number of states 
NP = 30;          % No of patients

### HMM
data = patient_vitals_living(1:NP, 1);
data(NP+1 : NP + NP, 1) = patient_vitals_dead(1:NP, 1);
ind = randperm(1:2*NP);
data = data(ind, 1);

prior0 = [0.8; 0.2];
transmat0 = [0.8 0.2; 0 1];
[mu0, Sigma0] = mixgauss_init(Q*M, data{1}, 'full', 'kmeans');
mu0 = reshape(mu0, [O Q M]);
Sigma0 = reshape(Sigma0, [O O Q M]);
mixmat0 = ones(Q, 1); 
#mixmat0 = mk_stochastic(rand(Q,M));

[LL_mixed, prior_mixed, transmat_mixed, mu_mixed, Sigma_mixed, mixmat_mixed] = ...
    mhmm_em(data0, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 100, 'verbose', 1);