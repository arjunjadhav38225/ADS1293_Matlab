fs=200;
% Specify the starting and ending intervals (in seconds)
start_time =2;  % Starting time
end_time =8;   % Ending` time

% Convert the time range to corresponding indices
start_index = round(start_time * fs);
end_index = round(end_time * fs);

% Extract the desired segment of the ECG signal
ecg_segment =ecg(start_index:end_index);
t_segment = (start_index:end_index) / fs;

% Apply high-pass filter to remove baseline wander and low-frequency noise
ecg_high=filter(Hd1,ecg_segment);
 
% Apply low-pass filter to remove high-frequency noise
ecg_low=filter(Hd2,ecg_high);


% Smooth the interval signal using a moving average filter
window_size = 6;  % Adjust the window size as needed
smooth_ecg = movmean(ecg_low, window_size);
figure;
subplot(2, 1, 1);
plot(ecg);
title('Original ECG Signal');
xlabel('Sample');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t_segment, smooth_ecg);
title('Zeroed ECG Signal');
xlabel('Sample');
ylabel('Amplitude');
