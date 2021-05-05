function [clean_eeg] = wavelet_ica(input_eeg, num_components, fs, cutoff)
% WAVELET_ICA(input_eeg, num_components, fs) Performs 
% ICA-Wavelet decomposition on the input data. Determines components to remove 
% based on the average frequency of each wavelet-decomposed component.
%
%    INPUTS
%    input_eeg: EEG data [matrix]
%    num_components: number of wavelet-decomposed components to make [number]
%    fs: sampling rate for the EEG data [scalar]
%    cutoff: low- and high-frequency cutoffs for wavelet component removal
%    [vector]
%
%    OUTPUTS
%    clean: ICA-Wavelet processed data [matrix]
%
%    See also RUNICA.


    % find independent components
    [weights, ~] = runica(input_eeg);
    post_ica = double(weights*input_eeg);

    % calculate wavelet coefficients and plot
    [post_wavelet, num_components, ~, ~] = wavelet_decomp(post_ica, num_components - 1, 'db4');
    
    % flag channels by average frequency
    time = size(post_wavelet, 2)/fs;
    zcd = dsp.ZeroCrossingDetector;
    zero_crossings = double(zcd(post_wavelet.'));
    release(zcd);
    avg_freq = zero_crossings/time*0.5;
    flagged_inds = avg_freq < cutoff(1) | avg_freq > cutoff(2);     % 0 or 1
    
    % plot components with potential removals highlighted
    figure('Name', 'Components to Remove')
    highlight_eeg(post_wavelet, fs, flagged_inds, spacing_factor(post_wavelet));
    title('Flagged Components in Red')
    
    % zero any flagged or user-specified components
    component_list = 1:size(flagged_inds, 2);
    flags = flagged_inds.*component_list;
    flags = flags(flags ~= 0);                                      % component numbers
    disp(['The selected components to delete are: ', num2str(flags)])
    prompt = '\nInput a vector of additional components to remove: ';
    flags = [flags input(prompt)];
    clean_components = zero_artifacts(post_wavelet, flags);
    
    % reconstruct cleaned signal
    if num_components > 1
        clean_eeg = reconstruct_eeg(clean_components, num_components, size(input_eeg,1));
    else
        clean_eeg = clean_components;
    end
    clean_eeg = inv(weights)*clean_eeg;
    
    % plot clean vs original    
    figure('Name', 'Side-by-Side')
    subplot(2, 1, 1)
    plot_eeg(input_eeg, fs, spacing_factor(input_eeg))
    title('Original')
    subplot(2, 1, 2)
    plot_eeg(clean_eeg, fs, spacing_factor(input_eeg))      % same spacing factor as above to show differences
    title('Clean')

end

