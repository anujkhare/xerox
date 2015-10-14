function [labels, lldiff] = classify(data, true_labels, prior_living, 
                            transmat_living, mu_living, Sigma_living, mixmat_living,
                            prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead)

# data must be a cell array
ncases = length(data);

errors = [];
labels = zeros(size(true_labels, 1), 1);
lldiff = zeros(size(true_labels, 1), 1);

for m=1:ncases
  obslik_dead = mixgauss_prob(data{m}, mu_dead, Sigma_dead, mixmat_dead);
  [alpha, beta, gamma, ll_dead] = fwdback(prior_dead, transmat_dead, obslik_dead, 'fwd_only', 1);

  obslik_living = mixgauss_prob(data{m}, mu_living, Sigma_living, mixmat_living);
  [alpha, beta, gamma, ll_living] = fwdback(prior_living, transmat_living, obslik_living, 'fwd_only', 1);

   lldiff(m) = abs(ll_living - ll_dead);
  
   if(ll_living > ll_dead)
     labels(m) = 0;
     %printf('LIVE %f\n', abs(ll_dead - ll_living));
   else
     labels(m) = 1;
     %printf('DIE %f\n', abs(ll_dead - ll_living));
   endif
end

#disp(labels

printf ('Accuracy - %f%%\n',  sum(labels == true_labels) * 100.0 / ncases);

%miss_index = labels ~= true_labels;
%disp(lldiff(miss_index, 1));

end