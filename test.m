data_living = patient_vitals_living;
data_dead = patient_vitals_dead;

%n_living = size(data_living, 1);
%n_dead = size(data_dead, 1);
n_living = 30;
n_dead = 30;

if 1
  
  ind0 = randperm(size(data_living, 1));
  ind1 = randperm(size(data_dead, 1));

  validation_split = 0.6;
  data_train_living = data_living(ind0(1:int64(validation_split*n_living)), 1);
  data_valid_living = data_living(ind0(int64(validation_split*n_living) + 1:n_living), 1);
  data_train_dead = data_dead(ind1(1:int64(validation_split*n_dead)), 1);
  data_valid_dead = data_dead(ind1(int64(validation_split*n_dead) + 1:n_dead), 1);

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

%miss_index = labels ~= true_labels;
%disp(lldiff(miss_index, 1));

%N = 100;
%start = 50;
%if 1
%data_classify = patient_vitals_living(1000+1:1000+N, 1);
%labels = zeros(N, 1);
%labels = zeros(size(data_valid_living, 1));
%else
%data_classify = patient_vitals_dead(start+1:start+N, 1);
%labels = ones(N, 1);
%labels = ones(size(data_valid_dead, 1));
%endif

%classify(data_classify, labels,
%         prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
%         prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead)