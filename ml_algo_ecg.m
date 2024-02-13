fs = 200;  % Sampling frequency
a=0;

% Specify the starting and ending intervals (in seconds)
start_time = 10;  % Starting time
end_time = 15;   % Ending time

% Convert the time range to corresponding indices
start_index = round(start_time * fs);
end_index = round(end_time * fs);

% Extract the desired segment of the ECG signal
ecg_segment = ecg2(start_index:end_index);
t_segment = (start_index:end_index) / fs;

% Apply high-pass filter to remove baseline wander and low-frequency noise
cutoff_freq_hp = 0.5;  % Cutoff frequency for high-pass filter (adjust as needed)
[b_hp, a_hp] = butter(2, cutoff_freq_hp / (fs / 2), 'high');  % 2nd-order Butterworth high-pass filter coefficients
ecg_segment_hp = filtfilt(b_hp, a_hp, ecg_segment);

% Apply low-pass filter to remove high-frequency noise
cutoff_freq_lp = 40;  % Cutoff frequency for low-pass filter (adjust as needed)
[b_lp, a_lp] = butter(2, cutoff_freq_lp / (fs / 2), 'low');  % 2nd-order Butterworth low-pass filter coefficients
ecg_segment= filtfilt(b_lp, a_lp, ecg_segment_hp);

% Smooth the interval signal using a moving average filter
window_size = 5;  % Adjust the window size as needed
smooth_ecg = movmean(ecg_segment, window_size);

% Perform R-peak detection using findpeaks
[~, r_locs] = findpeaks(smooth_ecg, 'MinPeakHeight', 0.5 * max(smooth_ecg), 'MinPeakProminence', 0.1 * max(smooth_ecg));

% Define the search window for P, Q, R, S, and T waves around the R-peaks
p_window_start = round(0.15 * fs);  % Start of the P-wave search window
p_window_end = round(0.25 * fs);    % End of the P-wave search window
q_window = round(0.05 * fs);
s_window = round(0.1 * fs);
t_window = round(0.3 * fs);

% Initialize arrays to store the locations of detected waves
p_locs = zeros(size(r_locs));
q_locs = zeros(size(r_locs));
s_locs = zeros(size(r_locs));
t_locs = zeros(size(r_locs));
t_polarity = cell(size(r_locs));

% Detect P, Q, R, S, and T waves around each R-peak
for i = 1:length(r_locs)
    r_loc = r_locs(i);
    
    % P-wave detection
    p_search_window = max(r_loc - p_window_end, 1) : min(r_loc - p_window_start, length(smooth_ecg));
    [~, p_index] = max(smooth_ecg(p_search_window));
    p_locs(i) = p_search_window(p_index);
    
    % Q-wave detection
    q_search_window = r_loc - q_window : r_loc;
    [~, q_index] = min(smooth_ecg(q_search_window));
    q_locs(i) = q_search_window(q_index);
    
    % S-wave detection
    s_search_window = r_loc : min(r_loc + s_window, length(smooth_ecg));
    [~, s_index] = min(smooth_ecg(s_search_window));
    s_locs(i) = s_search_window(s_index);
    
    % T-wave detection
    t_search_window = min(r_loc + s_window, length(smooth_ecg)) : min(r_loc + t_window, length(smooth_ecg));
    [~, t_index] = max(smooth_ecg(t_search_window));
    t_locs(i) = t_search_window(t_index);
    
    % Determine T-wave polarity
    s_amplitude = smooth_ecg(s_locs(i));
    t_amplitude = smooth_ecg(t_locs(i));
    if t_amplitude > s_amplitude
        t_polarity{i} = 'Positive';
    else
        t_polarity{i} = 'Negative';
    end
end

% Check if any T-wave polarity is negative
is_negative_t_wave = any(strcmp(t_polarity, 'Negative'));

% Calculate QRS duration
qrs_duration = (s_locs - q_locs) / fs;  % Duration in seconds

% Calculate QT interval
qt_interval = (t_locs - q_locs) / fs;  % Duration in seconds

% Calculate PR interval
pr_interval = (r_locs - p_locs) / fs;  % Duration in seconds

% Calculate heart rate
rr_interval = diff(r_locs) / fs;  % RR intervals in seconds
heart_rate = 60 / mean(rr_interval);  % Heart rate in beats per minute

% Calculate P wave presence
p_wave_presence = ~any(p_locs == 0);

% Display if P wave is present or not
if p_wave_presence
    disp('P wave is present.');
    p=1;
else
    disp('P wave is not present.');
    p=0;
end

% Display the results
disp(['Average QRS duration: ' num2str(mean(qrs_duration)) ' seconds']);
disp(['Average QT interval: ' num2str(mean(qt_interval)) ' seconds']);
disp(['Average PR interval: ' num2str(mean(pr_interval)) ' seconds']);
disp(['Heart rate: ' num2str(heart_rate) ' bpm']);
disp('Arrythmia:');
% Display if any T-wave polarity is negative
if is_negative_t_wave
    disp('ischemia.');
    a=a+1;
end

% Plot the interval signal with detected P, Q, R, S, and T waves
figure;
plot(t_segment, smooth_ecg);
hold on;
plot(t_segment(r_locs), smooth_ecg(r_locs), 'ro');  % R-peaks
plot(t_segment(p_locs), smooth_ecg(p_locs), 'g^');  % P-waves
plot(t_segment(q_locs), smooth_ecg(q_locs), 'mv');  % Q-waves
plot(t_segment(s_locs), smooth_ecg(s_locs), 'bs');  % S-waves
plot(t_segment(t_locs), smooth_ecg(t_locs), 'gx');  % T-waves
legend('Smoothed Interval ECG Segment', 'R-peaks', 'P-waves', 'Q-waves', 'S-waves', 'T-waves');
xlabel('Time (s)');
ylabel('Amplitude');
title('Smoothed Interval ECG Segment with Detected P, Q, R, S, and T Waves');

%1.Ventricular tachycardia -Ventricular tachycardia -wide qrs complex  The duration of the QRS complex in ventricular tachycardia (VT) is typically greater than 120 milliseconds (ms), which is longer than the normal QRS duration of 80-100 ms.
if mean(qrs_duration) > 0.122
    disp("Ventricular tachyc0ardia type arrythmia detected.")
    a=a+1
end

%2.Torsades de pointes -QT interval of greater than 500 milliseconds
if mean(qt_interval)> 0.500 
        disp("Torsades de pointes type arrythmia detected.")
        a=a+1
end

%3. Long QT syndrome (LQTS)- qt > 440  milliseconds    
if mean(qt_interval)>0.400 
        disp("Long QT syndrome (LQTS) type arrythmia detected.")
        a=a+1
end
        
%4. Atrial flutter-heart rate between 240-340 & sawtooth pattern & narrow qrs duration
if heart_rate>240 && heart_rate < 340 && mean(qt_interval)>440 
        disp("Long QT syndrome (LQTS) type arrythmia detected.")
        a=a+1
end

%5. Atrial fibrillation (AF) - Irregularly irregular rhythm, absence of P waves, and narrow QRS complexes
if mean(qrs_duration) < 00.110 &&  p
    disp("Atrial fibrillation (AF) type arrhythmia detected.")
    a=a+1
end

%6. Supraventricular tachycardia (SVT) - Narrow QRS complexes with a heart rate greater than 150 bpm
if heart_rate > 150 && mean(qrs_duration) < 0.120
    disp("Supraventricular tachycardia (SVT) type arrhythmia detected.")
    a=a+1
 end

%7. Atrioventricular block (AV block) - Prolonged PR interval (>200 ms) or intermittent absence of QRS complexes
if mean(pr_interval) > 200 
    disp("Atrioventricular block (AV block) type arrhythmia detected.")
    a=a+1
end
    
%8 Normal
if a==0
    disp('Normal');
end