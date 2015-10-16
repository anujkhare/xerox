n_living = size(data_living, 1);
n_dead = size(data_dead, 1);

ind0 = randperm(n_living);
ind1 = randperm(n_dead);

validation_split = 0.6;
data_train_living = data_living(ind0(1:int64(validation_split*n_living)), 1);
data_valid_living = data_living(ind0(int64(validation_split*n_living) + 1:end), 1);
data_train_dead = data_dead(ind1(1:int64(validation_split*n_dead)), 1);
data_valid_dead = data_dead(ind1(int64(validation_split*n_dead) + 1:end), 1);

% Train the HMMs
[LL_living, prior_living, transmat_living, mu_living, Sigma_living, mixmat_living, ...
        LL_dead, prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead] = ...
                                  hmm_try1(data_train_living, data_train_dead);
