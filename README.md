# Wavelet-Enhanced ICA
This repository contains a script to remove motion, muscle, and eye movement artifacts from multi-channel electroencephalogram (EEG) data using wavelet decomposition-enhanced independent component analysis (ICA). It also contains helper and data visualization functions. 

## Overview
EEG signals are prone to noise contamination, especially in dynamic experiments. The tool in this repository improves on the traditional ICA method of noise removal by wavelet-decomposing each independent component.

Components which resemble artifacts based on their frequency characteristics are automatically suggested for removal. The user can also specify additional components to remove. The results of artifact removal are plotted for visual comparison.

## Dependencies
- **[EEGLAB:](https://sccn.ucsd.edu/eeglab/index.php)** `runica.m` for ICA
- **[MATLAB's Wavelet Toolbox:](https://www.mathworks.com/products/wavelet.html)** `wavedec` and `wrcoef` for wavelet decomposition
- **[MATLAB's DSP System Toolbox:](https://www.mathworks.com/products/dsp-system.html)** `ZeroCrossingDetector` for calculating average frequencies

## Usage
`wavelet_ica(input_eeg,num_components,fs,cutoff)` runs the wavelet-ICA tool. 
- a figure will be generated which highlights suggested components to remove in red
- follow the instructions in the pop-up dialog box to choose wavelet-ICA components to remove

See the help documentation in each function for more information.

## Bibliography
Listed here is some helpful literature for getting acquainted with EEG artifact removal using methods like this one.

[1] S. Makeig, A. J. Bell, T.-P. Jung, and T. J. Sejnowski, “Independent Component Analysis of Electroencephalographic Data,” Adv. Neural Inf. Process. Syst., vol. 8, pp. 145–151, 1996.

[2] A. Delorme and S. Makeig, “EEGLAB: An Open Source Toolbox for Analysis of Single-Trial EEG Dynamics Including Independent Component Analysis,” J. Neurosci. Methods, vol. 134, no. 1, pp. 9–21, Mar. 2004.

[3] X. Chen et al., “ReMAE: User-Friendly Toolbox for Removing Muscle Artifacts from EEG,” IEEE Trans. Instrum. Meas., vol. 69, no. 5, pp. 2105–2119, May 2020.
