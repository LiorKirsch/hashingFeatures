function [X,Y,trueW] = generate_synthetic_data1


%Parameters
d = 10^4; %total number of features
n = 10^5; %total number of examples, also the number of rounds
initial_support_size = 100;
birth_rate = 3; %each round the number of new active features is Poisson(3)
death_rate = birth_rate; %each round the number of deactivated features is Poisson(3)
mean_feature = 5; %features are Poisson counts with this parameter
label_noise = 0.00; %chance that a label is flipped
seed = 1;
rng(seed);
X = sparse(d,n);

trueW = rand(d,1)*2-1;

Y = nan(n,1);
support_size = initial_support_size;
support_set = [1:initial_support_size];
i = 1;
while max(support_set)<=d && i<=n
    p = poissrnd(mean_feature,[support_size 1]);
    X(support_set,i) = p;
    Y(i) = sign(trueW'*X(:,i));
    if rand(1)<label_noise
        Y(i) = -Y(i);
    end
    number_of_deaths = poissrnd(death_rate);
    rp = randperm(support_size);
    support_set = support_set(rp(number_of_deaths+1:end));
    support_size = support_size - number_of_deaths;
    number_of_births = poissrnd(birth_rate);
    support_set = [support_set (max(support_set)+(1:number_of_births))];
    support_size = support_size+number_of_births;
    i = i+1;    
end

if i<n 
%this happens if we exhausted our feature set [1:d] before we saw n samples
    X = X(:,1:i);
end