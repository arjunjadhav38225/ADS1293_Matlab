
fs = 200;  % Sampling frequency
ecg_high=filter(Hd1,ecg7);
ecg_high(1:2000)=[];
y=ecg_high;
y_max=[];
max=0;
for i=1 :1: length(y)
if max<y(i)
    y_max(i)


end
     