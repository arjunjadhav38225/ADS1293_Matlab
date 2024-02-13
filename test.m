fs = 450;  % Sampling frequency


ecg_high=filter(Hd1,ECGIFiltered);

ecg_high(1:4000)=[];

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

%chek that r peak is not ocuurs immidiately after one peak due to double slope
ecg_pos1=[];
j=1;

for i=1:1:length(ecg_peak)-1
   if ecg_pos(i+1)-ecg_pos(i)<20
     ecg_pos1(j)=i;
     j=j+1;
 
   end
end

for i=1:length(ecg_pos1)
    ecg_pos(ecg_pos1(i))=[];
    ecg_peak(ecg_pos1(i))=[];
   
    for j=i+1:1:length(ecg_pos1)
    ecg_pos1(j)=ecg_pos1(j)-1;
    
    end
   
end  

%remove pos and value if it's zero
ecg_pos2=[];
j=1;

for i=1:1:length(ecg_peak)
   if ecg_pos(i) == 0 
     ecg_pos2(j)=i;
     j=j+1;
 
   end
end

for i=1:length(ecg_pos2)
    ecg_pos(ecg_pos2(i))=[];
    ecg_peak(ecg_pos2(i))=[];
   
    for j=i+1:1:length(t_pos1)
    ecg_pos2(j)=ecg_pos2(j)-1;
    
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

for i=1: length(ecg_peak);
  if i==1 
        for j=2:1:ecg_pos(1);
              if y(j-1)<y(j)&&y(j+1)<y(j)&&j<ecg_pos(1)&& ecg_peak(i)-abs(y(j))>200 && j<ecg_pos(i)
                    p_peak(1)=y(j);
                    p_pos(1)=j;
                     i=i+1;
                     
          
end
end
  end

   if i>1       
             for k=ecg_pos(i-1):1:ecg_pos(i)   
                    if y(k-1)<y(k) && y(k+1)<y(k) && k<ecg_pos(i)&&ecg_peak(i)-y(k)>200
                    p_peak(i)=y(k);
                    p_pos(i)=k;
                     
                    end
                    
             end
             i=i+1;
             
                   
   end
end

%remove pos and value if it's zero
p_pos1=[];
j=1;

for i=1:1:length(p_peak)
   if p_pos(i) == 0 
     p_pos1(j)=i;
     j=j+1;
 
   end
end

for i=1:length(p_pos1)
    p_pos(p_pos1(i))=[];
    p_peak(p_pos1(i))=[];
   
    for j=i+1:1:length(p_pos1)
    p_pos1(j)=p_pos1(j)-1;
    
    end
   
end


%plot p peaks
plot(p_pos,p_peak,'*b');
title('p peak');








%find q peak
q_peak=[];
q_pos=[];

for i=1:length(ecg_peak)
     if i==1
         for j=2:1:ecg_peak(1)
             if y(j)<y(j+1) && y(j)<y(j-1) && j<ecg_pos(i) && ecg_peak(i)-y(j)>150
                 q_pos(i)=j;
                 q_peak(i)=y(j);
             
             end 
             
         end
       
         i=i+1;
 
        
         
     end
    
     if i>1
         for k=ecg_pos(i-1):1:ecg_pos(i)
             if y(k)<y(k+1) && y(k)<y(k-1) && k<ecg_pos(i) && ecg_peak(i)-abs(y(k))>150
                 q_pos(i)=k;
                 q_peak(i)=y(k);
                 
                 
                 
             end 
         end
          
         i=i+1;
         

     end


end

%remove pos and value if it's zero
q_pos1=[];
j=1;

for i=1:1:length(q_peak)
   if q_pos(i) == 0 
     q_pos1(j)=i;
     j=j+1;
 
   end
end

for i=1:length(q_pos1)
    q_pos(q_pos1(i))=[];
    q_peak(q_pos1(i))=[];
   
    for j=i+1:1:length(q_pos1)
    q_pos1(j)=q_pos1(j)-1;
    
    end
   
end

%plot q peaks
plot(q_pos,q_peak,'*g');
title('q peak');










%find s peak
s_peak=[];
s_pos=[];
for i=1:length(ecg_peak)-1
for k=ecg_pos(i):1:ecg_pos(i+1)
    m=(0.40*(ecg_pos(i+1)-ecg_pos(i)))+ecg_pos(i); 
             if y(k)<y(k+1) && y(k)<y(k-1) && k<m
                 s_pos(i)=k;
                 s_peak(i)=y(k);
                 
            end 
         end
         
         i=i+1;
end     


%remove pos and value if it's zero
s_pos1=[];
j=1;

for i=1:1:length(s_peak)
   if s_pos(i) == 0 
     s_pos1(j)=i;
     j=j+1;
 
   end
end

for i=1:length(s_pos1)
    s_pos(s_pos1(i))=[];
    s_peak(s_pos1(i))=[];
   
    for j=i+1:1:length(s_pos1)
    s_pos1(j)=s_pos1(j)-1;
    
    end
   
end

%plot s peaks
plot(s_pos,s_peak,'*k');
title('s peak');
 





%find t peak
t_peak=[];
t_pos=[];
for i=1:length(p_peak )-1
    for j=ecg_pos(i):1:ecg_pos(i+1)
         m=((ecg_pos(i+1)-ecg_pos(i))/2)+ecg_pos(i); 
         if y(j)>y(j-1) && y(j)>y(j+1) && y(j)<ecg_peak(i+1) && j>s_pos(i) && j<p_pos(i+1) && j~=p_pos(i) && y(j)<min(ecg_peak) && j<m && y(j) && y(j)>s_peak(i)
              t_peak(i)=y(j);
              t_pos(i)=j;
         end
    end
    
    i=i+1;
end

%remove pos and value if it's zero
t_pos1=[];
j=1;

for i=1:1:length(t_peak)
   if t_pos(i) == 0 
     t_pos1(j)=i;
     j=j+1;
 
   end
end

for i=1:length(t_pos1)
    t_pos(t_pos1(i))=[];
    t_peak(t_pos1(i))=[];
   
    for j=i+1:1:length(t_pos1)
    t_pos1(j)=t_pos1(j)-1;
    
    end
   
end

%plot t peaks
plot(t_pos,t_peak,'*m');
title('t peak');

y_min1=min(length(p_peak),length(q_peak));
y_min2=min(y_min1,length(ecg_peak));
y_min3=min(y_min2,length(s_peak));
y_min=min(y_min3,length(t_peak));


%RR interval
rr_int=[];
j=1;
for i=1:y_min-1
   rr_int(j)=(ecg_pos(i+1)-ecg_pos(i))/fs;
   
    j=j+1;
    i=i+1;
end
mean=0;
for i=1:length(rr_int)
    mean=mean+rr_int(i);
end

avg_rr=mean/length(rr_int);

%heart rate calculation

HR=60/avg_rr;
disp(HR);
disp(avg_rr);


%PR interval
pr_int=[];
if (ecg_pos(1)<p_pos(1))
for i=1:1:y_min
    pr_int(i)=ecg_pos(i+1)-p_pos(i);
end
end

if p_pos(1)<ecg_pos(1)
for i=1:1:y_min
    pr_int(i)=ecg_pos(i)-p_pos(i);
   
end
end

%average of pr interval
pr_sum=0;
for i=1:1:length(pr_int)
    pr_sum=pr_sum+pr_int(i);
end 

 avg_pr =pr_sum/(fs*length(pr_int))

%calculation of qrs duration 
qrs_int=[];
j=1;
for i=1:1:y_min
    qrs_int(j)=s_pos(i)-q_pos(i);
    j=j+1;
end
qrs_sum=0;

%average of qrs interal
for i=1:1:length(qrs_int)
    qrs_sum=qrs_sum+qrs_int(i);
end 

avg_qrs=qrs_sum/(fs*length(qrs_int));

%calculation of st interval

st_int=[];
j=1;
for i=1:1:y_min
    st_int(j)=t_pos(i)-s_pos(i);
end 

%average of st interval
st_sum=0;
for i=1:1:length(st_int)
    st_sum=st_sum+st_int(i)
end
avg_st=st_sum/(fs*length(st_int));




%calculation of qt interval

qt_int=[];
j=1;
for i=1:1:y_min
    qt_int(j)=t_pos(i)-q_pos(i);
end 

%average of qt interval
qt_sum=0;
for i=1:1:length(qt_int)
    qt_sum=qt_sum+qt_int(i)
end
avg_qt=qt_sum/(fs*length(qt_int));

%find p wave presence 
p=0;
if length(p_pos)<=1
    p=1;
else
    disp('p wave is present');
end 



%find the polarity of t wave
if length(t_pos)<2
  disp('might be ischemia');
end


