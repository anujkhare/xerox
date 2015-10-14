function y = view_viterbi_paths(data, prior, transmat, mu, Sigma, mixmat)

# data must be a cell array
ncases = length(data);

loglik = 0;
errors = [];
for m=1:ncases
  obslik = mixgauss_prob(data{m}, mu, Sigma, mixmat);
  [alpha, beta, gamma, ll] = fwdback(prior, transmat, obslik, 'fwd_only', 1);
  printf('%i\t-%f\n', m, ll);
  path = viterbi_path(prior, transmat, obslik) - 1;
  disp(path);
  printf('\n\n');
end
end