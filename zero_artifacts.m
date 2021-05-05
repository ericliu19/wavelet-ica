function [result] =  zero_artifacts(original, to_delete)
% ZERO_ARTIFACTS(original, to_delete) "zeroes" the rows of the input matrix
% corresponding to noisy channels (to_delete)
%
%   INPUTS
%   original: decomposed data [matrix]
%   to_delete: components to remove [vector]
%
%   OUTPUTS
%   result: data with components zeroed [matrix]

   result = original;
   for i = 1:length(to_delete)
       result(to_delete(i), :) = zeros(1, size(result,2));
   end
   
end