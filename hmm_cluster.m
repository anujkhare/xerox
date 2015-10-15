data = data_train_living;
ncases = length(data);
true_labels = zeros(size(data_train_living, 1), 1);

labels = zeros(size(true_labels, 1), 1);
%lldiff = zeros(size(true_labels, 1), 1);
loglik_dead = zeros(size(true_labels, 1), 1);
loglik_living = zeros(size(true_labels, 1), 1);

for m=1:ncases
  obslik_dead = mixgauss_prob(data{m}, mu_dead, Sigma_dead, mixmat_dead);
  [alpha, beta, gamma, ll_dead] = fwdback(prior_dead, transmat_dead, obslik_dead, 'fwd_only', 1);

  obslik_living = mixgauss_prob(data{m}, mu_living, Sigma_living, mixmat_living);
  [alpha, beta, gamma, ll_living] = fwdback(prior_living, transmat_living, obslik_living, 'fwd_only', 1);

  %lldiff(m) = abs(ll_living - ll_dead);
  loglik_dead(m) = ll_dead;
  loglik_living(m) = ll_living;
  
   if(ll_living > ll_dead)
     labels(m) = 0;
     %printf('LIVE %f\n', abs(ll_dead - ll_living));
   else
     labels(m) = 1;
     %printf('DIE %f\n', abs(ll_dead - ll_living));
   endif
end

disp([labels~=true_labels loglik_living loglik_dead]);
printf ('Training Accuracy - %f%%\n',  sum(labels == true_labels) * 100.0 / ncases);

% Find indices in the train array based on value of log likelihood (Somehow!) :P
log_loglik = log(abs(loglik_living));
ind1 = log_loglik <= 6;
ind2 = log_loglik > 6;

% Find the clusters in the data
n_clusters = 2;
data_living_clusters = cell(n_clusters, 1);
data_living_clusters{1} = data_train_living(ind1, 1);
data_living_clusters{2} = data_train_living(ind2, 1);

% Train the HMMs
O = 6;          %Number of coefficients in a vector 
M = 1;          %Number of mixtures 
Q = 2;          %Number of states

prior0 = [0.5 0.5];
transmat0 = [0.5 0.5 ; 0.5 0.5];
mixmat0 = ones(Q, 1); #mixmat0 = mk_stochastic(rand(Q,M));

LL_clusters = cell(n_clusters, 1);
prior_living_clusters = cell(n_clusters, 1);
transmat_living_clusters = cell(n_clusters, 1);
mixmat_living_clusters = cell(n_clusters, 1);
mu_living_clusters = cell(n_clusters, 1);
Sigma_living_clusters = cell(n_clusters, 1);

for i = 1:n_clusters
  data0 = data_living_clusters{i};
  [mu0, Sigma0] = mixgauss_init(Q*M, data0{1}, 'full', 'kmeans');
  mu0 = reshape(mu0, [O Q M]);
  Sigma0 = reshape(Sigma0, [O O Q M]);
  
  [LL_clusters{i}, prior_living_clusters{i}, transmat_living_clusters{i}, ...
      mu_living_clusters{i}, Sigma_living_clusters{i}, mixmat_living_clusters{i}] = ...
      mhmm_em(data0, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 100, 'verbose', 1);
end 

for m=1:ncases
  obslik_dead = mixgauss_prob(data{m}, mu_dead, Sigma_dead, mixmat_dead);
  [alpha, beta, gamma, ll_dead] = fwdback(prior_dead, transmat_dead, obslik_dead, 'fwd_only', 1);

  ll_living_clusters = cell(n_clusters, 1);
  for i = 1:n_clusters
  obslik_living = mixgauss_prob(data{m}, mu_living_clusters{i}, Sigma_living_clusters{i}, mixmat_living_clusters{i});
  [alpha, beta, gamma, ll_living_clusters{i}] = fwdback(prior_living_clusters{i}, transmat_living_clusters{i}, obslik_living, 'fwd_only', 1);
  end

  %lldiff(m) = abs(ll_living - ll_dead);
%  loglik_dead(m) = ll_dead;
%  loglik_living(m) = ll_living;
  
   if(ll_living_clusters{1} > ll_dead || ll_living_clusters{2} > ll_dead)
     labels(m) = 0;
     %printf('LIVE %f\n', abs(ll_dead - ll_living));
   else
     labels(m) = 1;
     %printf('DIE %f\n', abs(ll_dead - ll_living));
   endif
end

%disp([labels~=true_labels loglik_living loglik_dead]);
printf ('\nCluter Training Accuracy - %f%%\n',  sum(labels == true_labels) * 100.0 / ncases);