
x = ecg;

% Sample rate and signal duration
fs = 200; % Sample rate (Hz)
duration = numel(x) / fs; % Signal duration (seconds)

% Compute power density and frequency spectrum
[power_density, f] = periodogram(x, [], [], fs, 'power');

% Plot the power density and frequency spectrum
figure;
subplot(2, 1, 1);
plot(f, power_density);
xlabel('Frequency (Hz)');
ylabel('Power Density');
title('Power Density Spectrum');

subplot(2, 1, 2);
plot(f, 10*log10(power_density));
xlabel('Frequency (Hz)');
ylabel('Power Density (dB)');
title('Power Density Spectrum (dB)');
