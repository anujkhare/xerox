n_living = size(patient_vitals_living, 1);
n_dead = size(patient_vitals_dead, 1);

ind0 = randperm(1:n_living);
ind1 = randperm(1:n_dead);

validation_split = 0.6;
data_train_living = patient_vitals_living(1:int64(validation_split*n_living), 1);
data_valid_living = patient_vitals_living(int64(validation_split*n_living) + 1:end, 1);
data_train_dead = patient_vitals_dead(1:int64(validation_split*n_dead), 1);
data_valid_dead = patient_vitals_dead(int64(validation_split*n_dead) + 1:end, 1);


% Train the HMMs
hmm_try1(data_train_living, data_train_dead);

classify(data_valid_dead, ones(size(data_valid_dead, 1), 1),
         prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
         prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead)

classify(data_valid_living, zeros(size(data_valid_living, 1), 1),
         prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
         prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead)

%N = 100;
%start = 50;
if 1
%data_classify = patient_vitals_living(1000+1:1000+N, 1);
%labels = zeros(N, 1);
%labels = zeros(size(data_valid_living, 1));
else
%data_classify = patient_vitals_dead(start+1:start+N, 1);
%labels = ones(N, 1);
%labels = ones(size(data_valid_dead, 1));
endif

%classify(data_classify, labels,
%         prior_living, transmat_living, mu_living, Sigma_living, mixmat_living,
%         prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead)