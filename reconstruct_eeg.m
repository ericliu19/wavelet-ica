function reconstructed = reconstruct_eeg(components,num_components,num_channels)
%RECONSTRUCT_EEG reconstructs an EEG signal from cleaned-up components.
%
%   INPUTS
%   components: cleaned-up components to be summed [matrix]
%   num_components: number of components to be summed [number]
%   num_channels: number of channels in the original EEG [number]
%
%   OUTPUTS
%   reconstructed: reconstructed EEG [matrix]

    reconstructed = NaN(num_channels,size(components,2));
    first_components = num_components*[0:num_channels - 1] + 1;
    last_components = num_components*[1:num_channels];
    for i = 1:num_channels
        reconstructed(i,:) = sum(components(first_components(i):last_components(i),:));
    end
    
end

