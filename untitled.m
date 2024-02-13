fs = 160;  % Sampling frequency


ecg_high=filter(Hd1,ecg1);

ecg_high(1:2000)=[];

% Smooth the interval signal using a moving average filter
window_size = 20;  % Adjust the window size as needed
smooth_ecg = movmean(ecg_high, window_size);


y=smooth_ecg;

%find r peak
ecg_peak=[];
ecg_pos=[];
j=1;
for i=2:1:(length(y)-1);
if y(i-1)<y(i) && y(i+1)<y(i)&&y(i)>0.45*max(y)&& max(y)-y(i)<=200
   ecg_peak(j)=y(i);
   ecg_pos(j)=i;
   j=j+1;
end
end

% plot original signal
figure,plot(y);                                                                                                                                                                                                       
hold on
title('ECG signal');
xlabel('time');
ylabel('amplitude');

%plot r peaks
plot(ecg_pos,ecg_peak,'*r');
title('ECG peak');

%find p peak
 p_peak=[];
 p_pos=[];

for i=1: length(ecg_peak)-1;
  if i==1 
        for j=2:1:ecg_pos(1);
              if y(j-1)<y(j)&&y(j+1)<y(j)&&j<ecg_pos(1)
                    p_peak(1)=y(j);
                    p_pos(1)=j;
                     i=i+1;
                     
          
end
end
  end

   if i>1       
             for k=ecg_pos(i-1):1:ecg_pos(i)   
                    if y(k-1)<y(k) && y(k+1)<y(k) && k<ecg_pos(i)
                    p_peak(i)=y(k);
                    p_pos(i)=k;
                     
                    end
                    
             end
             i=i+1;
                   
   end
end

%plot p peaks
plot(p_pos,p_peak,'*b');
title('p peak');

%find
