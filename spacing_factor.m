function [spacing] = spacing_factor(input_mat)
%SPACING_FACTOR(input_mat) determines the optimal 
%spacing between channels for multichannel signal plotting
%
%   INPUTS
%   input_mat: input data [matrix]
%
%   OUTPUTS
%   spacing: ideal spacing [number]

    spacing = abs(mean(range(input_mat.')));
end

