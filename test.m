N = 100;

if 1
data_classify = patient_vitals_living(1:N, 1);
labels = zeros(N, 1);
else
data_classify = patient_vitals_dead(1:N, 1);
labels = ones(N, 1);
endif

classify(data_classify, labels,
         prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
         prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead)