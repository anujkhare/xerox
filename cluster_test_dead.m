data = data_valid_living;
ncases = length(data);
true_labels = zeros(size(data, 1), 1);

labels=zeros(size(data), 1);

printf('\n\nClustering HMMs!');
for m=1:size(data, 1)
  obslik_living = mixgauss_prob(data{m}, mu_dead, Sigma_dead, mixmat_dead);
  [alpha, beta, gamma, ll_living] = fwdback(prior_living, transmat_living, obslik_living, 'fwd_only', 1);

  ll_dead_clusters = cell(n_clusters, 1);
  for i = 1:n_clusters
  obslik_dead = mixgauss_prob(data{m}, mu_dead_clusters{i}, Sigma_dead_clusters{i}, mixmat_dead_clusters{i});
  [alpha, beta, gamma, ll_dead_clusters{i}] = fwdback(prior_dead_clusters{i}, transmat_dead_clusters{i}, obslik_dead, 'fwd_only', 1);
  end

  %lldiff(m) = abs(ll_dead - ll_dead);
%  loglik_dead(m) = ll_dead;
%  loglik_dead(m) = ll_dead;
  
   if(ll_dead_clusters{1} > ll_living || ll_dead_clusters{2} > ll_living)
     labels(m) = 0;
   else
     labels(m) = 1;
   endif
end

printf ('\nCluter Test Accuracy - %f%%\n\n',  sum(labels == true_labels) * 100.0 / ncases);