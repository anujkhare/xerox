# true_living, labels_living
# true_dead, labels_dead

n_living = size(true_living, 1);
n_dead = size(true_dead, 1);

misind_living = true_living ~= labels_living;
misind_dead = true_dead ~= labels_dead;
ind_living = true_living == labels_living;
ind_dead = true_dead == labels_dead;
 
figure();
hold on;
a = ll_live_living(ind_living);
scatter(ones(size(a, 1), 1), a, c='r'); 
a = ll_live_living(misind_living);
scatter(ones(size(a, 1), 1), a, c='b'); 



lldiff_dead = abs(ll_live_dead - ll_die_dead);
lldiff_living = abs(ll_live_living - ll_die_living);

l = lldiff_living(misind_living, 1);
c = lldiff_living(ind_living, 1);
ll = l; cl = c;
%figure(); hold on;
%plot(sort(l), 'rx-');
%plot(sort(c), 'bx-');

printf('\nLiving accuracy: %f\nLL correct: Min: %f\tMax: %f\tMean: %f\nLL miss: Min: %f\tMax: %f\tMean: %f\n', ...
        sum(ind_living) * 100.0 / n_living, min(c), max(c), mean(c),
        min(l), max(l), mean(l));
        
l = lldiff_dead(misind_dead, 1);
c = lldiff_dead(ind_dead, 1);
ld = l; cd = c;
%plot(sort(l), 'gx-');
%plot(sort(c), 'kx-');

printf('\nDead accuracy: %f\nLL correct: Min: %f\tMax: %f\tMean: %f\nLL miss: Min: %f\tMax: %f\tMean: %f\n', ...
        sum(ind_dead) * 100.0 / n_dead, min(c), max(c), mean(c),
        min(l), max(l), mean(l));
        
figure();
axis ([0,3]);
boxplot ({ll, cl, ld, cd});
set(gca (), "xtick", [1 2 3 4], "xticklabel", {"Living-wrong", "Living-cor", "Dead-wrong", "Dead-cor"})
title ("Log Likelihood differences");
%% We see from raw boxplots that there is not a very significant distinction in
%% the living case, but deads are quite distinct

%% I will scale the lldiff somehow?? on the basis of lengths, more the length,
%% more the lesser the ll is expected to be, so, multiply by the length
%lls = ll .* (lens_living(misind_living) .^ 1);
%cls = cl .* (lens_living(ind_living) .^ 1);
%lds = ld .* (lens_dead(misind_dead) .^ 1);
%cds = cd .* (lens_dead(ind_dead) .^ 1);

%figure();
%axis ([0,3]);
%boxplot ({lls, cls, lds, cds});
%set(gca (), "xtick", [1 2 3 4], "xticklabel", {"Living-wrong", "Living-cor", "Dead-wrong", "Dead-cor"})
%title ("SCALED Log Likelihood differences");


%% REMOVE THE OUTLIERS, PLOT AGAIN, THEN DECIDE ON A THRESHOLD.
%% It seems that for living patients, the log likelihood

%% Is there a correlation between the ll of a sequence and it's length?