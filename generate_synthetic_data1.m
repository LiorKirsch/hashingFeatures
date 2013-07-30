function [X,Y,trueW] = generate_synthetic_data1


%Parameters
d = 10^4; %total number of features
n = 10^5; %total number of examples, also the number of rounds
initial_support_size = 200;
birth_rate = 0.10; %each round the number of new active features is Poisson(3)
death_rate = birth_rate; %each round the number of deactivated features is Poisson(3)
mean_feature = 5; %features are Poisson counts with this parameter
label_noise = 0.00; %chance that a label is flipped
seed = 2;
rng(seed);
%X = sparse(d,n);

rows = nan(initial_support_size*n*2,1);
columns = rows;

number_of_deaths = poissrnd(death_rate,[n 1]);
number_of_births = poissrnd(birth_rate,[n 1]);


support_size = initial_support_size;
support_set = sparse(false(d,1));
support_set(1:support_size) = true;
last_new_feature = support_size;

trueW = rand(d,1)*2-1;
running_ind = 1;
i = 1;
%number_of_deaths = 5*ones(size(number_of_deaths));
%number_of_births = 5*ones(size(number_of_births));
while last_new_feature <=d && i<=n 
    
    rows(running_ind:running_ind + support_size-1) = find(support_set);
    columns(running_ind:running_ind + support_size-1) = i;

    if number_of_deaths(i) > 0
        active_support_indices = find(support_set);
        if number_of_deaths(i)>length(active_support_indices)
            support_set(active_support_indices) = false;
        else
            rp = randperm(length(active_support_indices));        
            support_set(active_support_indices(rp(1:number_of_deaths(i)))) = false;
        end        
    end    
    if number_of_births(i) > 0
        support_set(last_new_feature + 1: last_new_feature + number_of_births(i)) = true;
        last_new_feature = last_new_feature + number_of_births(i);
    end
    
    %support_size = support_size + max(number_of_births(i) - number_of_deaths(i),0);    
    running_ind = running_ind + support_size;
    support_size = sum(support_set);
    
    i = i+1;
    if mod(i,1000) == 0
        fprintf('i = %d out of %d, size of support set %d, last_new_feature = %d \n',i,n,full(sum(support_set)),last_new_feature);
    end
end

last_entry = find(~isnan(rows),1,'last');
rows = rows(1:last_entry);
columns = columns(1:last_entry);
values = poissrnd(mean_feature,[last_entry 1]);
new_d = max(rows);
new_n = max(columns);

X = sparse(rows,columns,values,new_d,new_n,last_entry);
trueW = trueW(1:new_d);
Y = sign(trueW'*X)';
noise = rand(new_n,1)<label_noise;
Y(noise) = -Y(noise);




