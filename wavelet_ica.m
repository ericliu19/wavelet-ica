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
    
    % automatic flags
    component_list = 1:size(flagged_inds, 2);
    flags = flagged_inds.*component_list;
    flags = flags(flags ~= 0);                        % component numbers
    
    % get user-specified flags
    input_1 = NaN;
    input_2 = NaN;
    input_3 = NaN;
    check_input = [isempty(input_1) isempty(input_2) isempty(input_3)];
    
    while (sum(check_input) < 2)
        dlg_prompts = {['Enter text in\bf one\rm of the following boxes.' newline...
            'Entries should be space-separated numbers.' sprintf('\n\n')...
            'Remove all suggested components\bf except:\rm'],...
            'Remove all suggested components\bf and:\rm', ...
            'Remove\bf only\rm these components:'};
        dlg_title = 'Components to Remove';
        dlg_dims = [1 70];
        dlg_defaults = {'','',''};
        opts.Interpreter = 'tex';
        opts.Resize = 'on';
        opts.WindowStyle = 'normal';
        user_input = inputdlg(dlg_prompts, dlg_title, dlg_dims, dlg_defaults, opts);
        input_1 = str2num(user_input{1});
        input_2 = str2num(user_input{2});
        input_3 = str2num(user_input{3});
        check_input = [isempty(input_1) isempty(input_2) isempty(input_3)];
    end
    
    % update flags to reflect user input
    if ~isempty(input_1)
        for i = 1:length(input_1)
            flags(flags == input_1(i)) = [];
        end
    elseif ~isempty(input_2)
        flags = [flags input_2];
    elseif ~isempty(input_3)
        flags = input_3;
    end

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
    plot_eeg(clean_eeg, fs, spacing_factor(input_eeg))              % same spacing factor as above to show differences
    title('Clean')
    
    msgbox({'Artifact removal complete.';['Removed components ' num2str(sort(unique(flags))) '.']});

end

