data_living = patient_vitals_living;
data_dead = patient_vitals_dead;

n_living = size(data_living, 1);
n_dead = size(data_dead, 1);
N = n_living + n_dead;

if 0
  ind0 = randperm(n_living + n_dead);
%  ind1 = randperm(n_dead);

  validation_split = 0.7;

  data = [data_living; data_dead];
  labels = [zeros(size(data_living, 1), 1); ones(size(data_dead, 1), 1)];
  
  data_train = data(ind0(1:int64(validation_split*N)), 1);
  labels_train = labels(ind0(1:int64(validation_split*N)), 1);
  data_valid = data(ind0(int64(validation_split*N) + 1:N), 1);
  labels_valid = labels(ind0(int64(validation_split*N) + 1:N), 1);
endif

if 1
  % Train the HMMs
  [LL_combined, prior_combined, transmat_combined, mu_combined, Sigma_combined, mixmat_combined] = ...
                                      hmm_try2(data_train);
endif

%view_viterbi_paths(data, prior_combined, transmat_combined, ...
%                    mu_combined, Sigma_combined, mixmat_combined);