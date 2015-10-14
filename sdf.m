 NP = 50;
for i=50:100

 [loglik_living, errors_living] = mhmm_logprob(patient_vitals_dead(i:i, 1), ...
                                prior_living, transmat_living, mu_living, Sigma_living, mixmat_living);
 [loglik_dead, errors_dead] = mhmm_logprob(patient_vitals_dead(i:i, 1), ...
                                prior_dead, transmat_dead, mu_dead, Sigma_dead, mixmat_dead);


  if(loglik_living > loglik_dead)
    printf('LIVE %f\n', loglik_living - loglik_dead);
   else
    printf('DIE %f\n', loglik_dead - loglik_living);
   endif
end 