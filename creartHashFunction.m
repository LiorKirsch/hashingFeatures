function [hashFunction, collisions] = creartHashFunction(featureSpaceSize, hashTableSize)
% [hashFunction, collisions] = creartHashFunction(featureSpaceSize, hashTableSize)
%
% returns a hash-matrix-function 
% use it:   hasedVector = hashFunction * originalSizeVector


%     seed = 3;
%     rng(seed);
    newIndices = randi(hashTableSize, [featureSpaceSize,1]  );
    
%     newIndices = mod( (1:featureSpaceSize)' .* newIndices, hashTableSize );
%     newIndices = newIndices + 1; % now starting at 1 not at zero
    
    hashFunction = sparse(newIndices , 1: featureSpaceSize, ones(size(newIndices)) , hashTableSize, featureSpaceSize);
    howManyMappedToSame = full(sum(hashFunction,2));
    collisions  = hist(howManyMappedToSame ,0 : max(howManyMappedToSame ) );
    bar(0 : max(howManyMappedToSame ), collisions);

end