data_living = patient_vitals_living;
data_dead = patient_vitals_dead;

n_living = size(data_living, 1);
n_dead = size(data_dead, 1);
%n_living = 1000;
%n_dead = 240;

if 0
  ind0 = randperm(size(data_living, 1));
  ind1 = randperm(size(data_dead, 1));

  validation_split = 0.7;
  data_train_living = data_living(ind0(1:int64(validation_split*n_living)), 1);
  data_valid_living = data_living(ind0(int64(validation_split*n_living) + 1:n_living), 1);
  data_train_dead = data_dead(ind1(1:int64(validation_split*n_dead)), 1);
  data_valid_dead = data_dead(ind1(int64(validation_split*n_dead) + 1:n_dead), 1);
endif

if 1
  % Train the HMMs
  [LL_living, prior_living, transmat_living, mu_living, Sigma_living, mixmat_living, ...
          LL_dead, prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead] = ...
                                    hmm_try1(data_train_living, data_train_dead);
endif

lens_dead = ones(size(data_valid_dead, 1), 1);
lens_living = ones(size(data_valid_living, 1), 1);
for i = 1:size(data_valid_dead, 1)
  lens_dead(i) = size(data_valid_dead{i}, 2);
end
for i = 1:size(data_valid_living, 1)
  lens_living(i) = size(data_valid_living{i}, 2);
end

# TRAINING DATA
printf('Training: Dead:\n');
[lables_train_dead, ll_train_live_dead, ll_train_die_dead] = ...
        classify(data_train_dead, ones(size(data_train_dead, 1), 1),
               prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
               prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead);

printf('Training: Alive:\n');
[labels_train_living, ll_train_live_living, ll_train_die_living] = ...
        classify(data_train_living, zeros(size(data_train_living, 1), 1),
               prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
               prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead);

# VALIDATION DATA
true_dead = ones(size(data_valid_dead, 1), 1);
printf('Dead patients data:\n');
[labels_dead, ll_live_dead, ll_die_dead] = ...
        classify(data_valid_dead, true_dead,
               prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
               prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead);

printf('Living patients data:\n');
true_living = zeros(size(data_valid_living, 1), 1);
[labels_living, ll_live_living, ll_die_living] = ...
        classify(data_valid_living, true_living,
               prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
               prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead);
               
misclassifications               