function [hashFunction, collisions] = createHashFunction(featureSpaceSize, hashTableSize, useMinusOnes)
% [hashFunction, collisions] = creartHashFunction(featureSpaceSize, hashTableSize)
%
% returns a hash-matrix-function 
% use it:   hasedVector = hashFunction * originalSizeVector


%     seed = 3;
%     rng(seed);
    newIndices = randi(hashTableSize, [featureSpaceSize,1]  );
    
%     newIndices = mod( (1:featureSpaceSize)' .* newIndices, hashTableSize );
%     newIndices = newIndices + 1; % now starting at 1 not at zero

    sparseMatrixContent = ones(size(newIndices));
    if exist('useMinusOnes','var')
        if useMinusOnes
            sparseMatrixContent = randi(2, [featureSpaceSize,1]  ) -1;
        end
    end
    
    hashFunction = sparse(newIndices , 1: featureSpaceSize, sparseMatrixContent , hashTableSize, featureSpaceSize);
    howManyMappedToSame = full(sum(hashFunction,2));
    collisions  = hist(howManyMappedToSame ,0 : max(howManyMappedToSame ) );
    bar(0 : max(howManyMappedToSame ), collisions);

end