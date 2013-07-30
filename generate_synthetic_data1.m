function [X,Y,trueW] = generate_synthetic_data1


%Parameters
d = 10^4; %total number of features
n = 10^4; %total number of examples, also the number of rounds
initial_support_size = 100;
birth_rate = 0.5; %each round the number of new active features is Poisson(3)
death_rate = birth_rate; %each round the number of deactivated features is Poisson(3)
mean_feature = 5; %features are Poisson counts with this parameter
label_noise = 0.001; %chance that a label is flipped
seed = 1;
rng(seed);
X = sparse(d,n);

trueW = rand(d,1)*2-1;

Y = nan(n,1);
support_size = initial_support_size;
support_set = sparse(false(d,1));
support_set(1:support_size) = true;
last_new_feature = support_size;

i = 1;
while last_new_feature <=d && i<=n
    p = poissrnd(mean_feature,[support_size 1]);
    X(support_set,i) = p;
    Y(i) = sign(trueW'*X(:,i));
    if rand(1)<label_noise
        Y(i) = -Y(i);
    end
    
    number_of_deaths = poissrnd(death_rate);
    if number_of_deaths > 0
        active_support_indices = find(support_set);
        rp = randperm(length(active_support_indices));
        %random_ordering = active_support_indices(rp);
        support_set(active_support_indices(rp(1:number_of_deaths))) = false;
    end
    
    number_of_births = poissrnd(birth_rate);
    if number_of_births > 0
        support_set(last_new_feature + 1: last_new_feature + number_of_births) = true;
        last_new_feature = last_new_feature + number_of_births;
    end
    
    support_size = support_size + number_of_births - number_of_deaths;
    i = i+1;  
    if mod(i,100) == 0
        fprintf('i = %d, size of support set is %d, nnz ratio is %g \n',i,full(sum(support_set)),nnz(X(:,1:i))/numel(X(:,1:i)));
        %fprintf('%d \n',i);
    end
end

if i<n 
%this happens if we exhausted our feature set [1:d] before we saw n samples
    X = X(:,1:i);
end