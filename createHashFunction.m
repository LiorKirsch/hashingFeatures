function [hashFunction, collisions] = createHashFunction(featureSpaceSize, hashTableSize, useMinusOnes)
% [hashFunction, collisions] = creartHashFunction(featureSpaceSize, hashTableSize)
%
% returns a hash-matrix-function 
% use it:   hasedVector = hashFunction * originalSizeVector


%     seed = 3;
%     rng(seed);
    newIndices = randi(hashTableSize, [featureSpaceSize,1]  );
    
    sparseMatrixContent = ones(size(newIndices));
    if exist('useMinusOnes','var')
        if useMinusOnes
            sparseMatrixContent = 2* randi(2, [featureSpaceSize,1]  ) -3;
        end
    end
    
    hashFunction = sparse(newIndices , 1: featureSpaceSize, sparseMatrixContent , hashTableSize, featureSpaceSize);
    howManyMappedToSame = full(sum(abs(hashFunction),2));
    collisions  = hist(howManyMappedToSame ,0 : max(howManyMappedToSame ) );
%     bar(0 : max(howManyMappedToSame ), collisions);

end