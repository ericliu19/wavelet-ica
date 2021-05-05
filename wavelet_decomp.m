function [result,num_components,C,L] = wavelet_decomp(input_eeg, num_levels, wname)
% WAVELET_DECOMP(input_eeg, num_levels, wname) returns the reconstructed
% wavelet coefficients of the input signal for the given number of
% decomposition levels and mother wavelet.
%      
%   INPUTS
%   input_eeg: the input signal [matrix]
%   num_levels: number of levels of decomposition [number]
%   wname: name of the mother (basis) wavelet [string]
%
%   OUTPUT
%   result: decomposed coefficients [matrix]
%   num_components: number of decomposed components [number]
%   C: wavelet (non-reconstructed) coeffs for each channel [matrix]
%   L: number of coeffs per decomposition level for each vector [matrix]
%
%   See also WAVEDEC, WRCOEF.

    [num_channels, signal_length] = size(input_eeg);
    num_components = num_levels + 1;
    result = [];
    C = [];
    L = [];
    for i = 1:num_channels
        coeffs = NaN(num_components, signal_length);
        [c, l] = wavedec(input_eeg(i,:), num_levels, wname);
        coeffs(1,:) = wrcoef('a', c, l, wname, num_levels);
        for j = 2:num_components
            coeffs(j,:) = wrcoef('d', c, l, wname, j - 1);
        end
        result = cat(1, result, coeffs);
        C = cat(1, C, c);
        L = cat(1, L, l);
    end
    
end

