

fs = 160;  % Sampling frequency

% Specify the starting and ending intervals (in seconds)
start_time = 4;  % Starting time
end_time = 8;   % Ending time

% Convert the time range to corresponding indices
start_index = round(start_time * fs);
end_index = round(end_time * fs);

% Extract the desired segment of the ECG signal
ecg_segment = ecg(start_index:end_index);
t_segment = (start_index:end_index) / fs;

% Smooth the interval signal using a moving average filter
window_size = 6;  % Adjust the window size as needed
smooth_ecg = movmean(ecg_segment, window_size);

% Perform R-peak detection without findpeaks
r_locs = [];
max_peak_height = 0.5 * max(smooth_ecg);  % Minimum peak height threshold (adjust as needed)
min_peak_prominence = 0.1 * max(smooth_ecg);  % Minimum peak prominence threshold (adjust as needed)
for i = 2:length(smooth_ecg)-1
    if smooth_ecg(i) > smooth_ecg(i-1) && smooth_ecg(i) > smooth_ecg(i+1) && smooth_ecg(i) > max_peak_height
        isPeak = true;
        for j = i-1:-1:max(i-20, 1)  % Check if it is the highest peak in a window of size 20 (adjust as needed)
            if smooth_ecg(i) < smooth_ecg(j)
                isPeak = false;
                break;
            end
        end
        if isPeak
            r_locs(end+1) = i;
        end
    end
end

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

% Detect P, Q, R, S, and T waves around each R-peak
for i = 1:length(r_locs)
    r_loc = r_locs(i);

    % P-wave detection
    p_search_window = max(r_loc - p_window_end, 1) : min(r_loc - p_window_start, length(smooth_ecg));
    [~, p_index] = max(smooth_ecg(p_search_window));
    p_locs(i) = p_search_window(p_index);

    % Q-wave detection
    q_search_window = max(r_loc - q_window, 1) : min(r_loc, length(smooth_ecg));
    [~, q_index] = min(smooth_ecg(q_search_window));
    q_locs(i) = q_search_window(q_index);

    % S-wave detection
    s_search_window = r_loc : min(r_loc + s_window, length(smooth_ecg));
    [~, s_index] = min(smooth_ecg(s_search_window));
    s_locs(i) = s_search_window(s_index);

    % T-wave detection
    t_search_window = min(r_loc + s_window + 1, length(smooth_ecg)) : min(r_loc + t_window, length(smooth_ecg));
    [~, t_index] = max(smooth_ecg(t_search_window));
    t_locs(i) = t_search_window(t_index);
end

% Remove zero entries from the detected wave locations
p_locs_final = p_locs(p_locs ~= 0);
q_locs_final = q_locs(q_locs ~= 0);
s_locs_final = s_locs(s_locs ~= 0);
t_locs_final = t_locs(t_locs ~= 0);

% Calculate QRS duration
qrs_duration = (s_locs_final - q_locs_final) / fs;  % Duration in seconds

% Calculate QT interval
qt_interval = (t_locs_final - q_locs_final) / fs;  % Duration in seconds

% Calculate PR interval
pr_interval = (r_locs - p_locs_final) / fs;  % Duration in seconds

% Calculate heart rate
rr_interval = diff(r_locs) / fs;  % RR intervals in seconds
heart_rate = 60 / mean(rr_interval);  % Heart rate in beats per minute

% Plot the ECG signal with detected waves
figure;
plot(t_segment, ecg_segment);
hold on;
plot(t_segment(r_locs), ecg_segment(r_locs), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
plot(t_segment(p_locs_final), ecg_segment(p_locs_final), 'g^', 'MarkerSize', 8, 'LineWidth', 2);
plot(t_segment(q_locs_final), ecg_segment(q_locs_final), 'bv', 'MarkerSize', 8, 'LineWidth', 2);
plot(t_segment(s_locs_final), ecg_segment(s_locs_final), 'm^', 'MarkerSize', 8, 'LineWidth', 2);
plot(t_segment(t_locs_final), ecg_segment(t_locs_final), 'ks', 'MarkerSize', 8, 'LineWidth', 2);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('ECG Signal with Detected Waves');
legend('ECG Signal', 'R-Peaks', 'P-Waves', 'Q-Waves', 'S-Waves', 'T-Waves');

% Display the results
disp(['Average QRS duration: ' num2str(mean(qrs_duration)) ' seconds']);
disp(['Average QT interval: ' num2str(mean(qt_interval)) ' seconds']);
disp(['Average PR interval: ' num2str(mean(pr_interval)) ' seconds']);
disp(['Heart rate: ' num2str(heart_rate) ' bpm']);
