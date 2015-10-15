data = data_valid_living;
ncases = length(data);
true_labels = zeros(size(data, 1), 1);

labels=ones(size(data), 1);

printf('\n\nClustering HMMs!');
for m=1:size(data, 1)
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
   else
     labels(m) = 1;
   endif
end

printf ('\nCluter Test Accuracy - %f%%\n\n',  sum(labels == true_labels) * 100.0 / ncases);