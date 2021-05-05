function highlight_eeg(eeg, fs, highlight, spacing)
% HIGHLIGHT_EEG(eeg, fs, highlight) plots input EEG channels with
% specified channels highlighted in red.
%
%    INPUTS
%    eeg: input data [matrix]
%    fs: sampling frequency [number]
%    highlight: channels to highlight [vector]
%    spacing: amount of spacing between channels [number]
%
%    See also PLOT_EEG, SPACING_FACTOR

    dt = 1/fs;
    t = 0:dt:(length(eeg)/fs) - dt;
    numchannels = size(eeg,1);
    offset = 0;                                 % increasing amount of vertical translation
    ymarkers = NaN(1,numchannels);
    ymarkerlabels = NaN(1, numchannels);
    for i = 1:numchannels
        toplot = (eeg(i,:)-mean(eeg(i,:)));
        if highlight(i) ~= 0
            plot(t, toplot - offset, 'r')
        else
            plot(t, toplot - offset, 'k')
        end
        hold on
        ymarkers(i) = mean(toplot - offset);    
        ymarkerlabels(i) = i;
        offset = offset + spacing;
    end
    hold off
    ymarkers = flip(ymarkers);                  % yticks must be in increasing order
    ymarkerlabels = flip(ymarkerlabels);
    yticks(ymarkers)
    yticklabels(ymarkerlabels)
    xlabel('Time (s)')
    ylabel('Channel Number')
end

