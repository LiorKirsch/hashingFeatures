
%Parameters
dataConf.d = 10^4; %total number of features
dataConf.n = 10^5; %total number of examples, also the number of rounds
dataConf.initial_support_size = 200;
dataConf.birth_rate = 0.10; %each round the number of new active features is Poisson(3)
dataConf.death_rate = conf.birth_rate; %each round the number of deactivated features is Poisson(3)
dataConf.mean_feature = 5; %features are Poisson counts with this parameter
dataConf.label_noise = 0.00; %chance that a label is flipped
seed = 2;
%rng(seed);
%X = sparse(d,n);
hashConf.useMinusOne = true;
hashConf.h = 10^4 -1; %number of entries in the hash talbe

[X,Y,trueW] = generate_synthetic_data1(dataConf) ;
[hashFunction, collisions] = createHashFunction(dataConf.d, hashConf.h, hashConf.useMinusOne);

hashedX = hashFunction * X;