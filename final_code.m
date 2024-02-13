
fs = 200;  % Sampling frequency
ecg_new=ecg88(14161:19161);

%applying high pass filter
ecg_high=filter(Hd1,ecg_new);

ecg_high(1:1000)=[];





% Smooth the interval signal using a moving average filter
window_size =3;  % Adjust the window size as needed
smooth_ecg = movmean(ecg_high, window_size);
y=smooth_ecg;

%find r peak
ecg_peak=[];
ecg_pos=[];
j=1;
for i=2:1:(length(y)-1);
   if y(i-1)<y(i) && y(i+1)<y(i)&&y(i)>0.70*max(y)&& max(y)-y(i)<=370 
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

%remove first r peak
ecg_peak(1)=[];
ecg_pos(1)=[];

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
              if y(j-1)<y(j)&&y(j+1)<y(j)&&j<ecg_pos(1) && ecg_peak(i)-abs(y(j))>200 && j<ecg_pos(i) && ecg_pos(1)-j>25
                    p_peak(1)=y(j);
                    p_pos(1)=j;
                   
              end
               
        end
        i=i+1;
  end

   if i>1       
             for k=ecg_pos(i-1):1:ecg_pos(i)   
                    if y(k-1)<y(k) && y(k+1)<y(k) && k<ecg_pos(i)&&ecg_peak(i)-y(k)>200 && ecg_pos(i)-k>20
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
             if y(k)<y(k+1) && y(k)<y(k-1) && k<m && k<(p_pos(i)+((p_pos(i+1)-p_pos(i))/2))&& k-ecg_pos(i)<40 &&y(k)<q_peak(i)&&abs(y(k))-abs(q_peak(i))>15 && (abs(y(k))-abs(q_peak(i)))>16
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
for i=1:length(s_peak )-1
    for j=ecg_pos(i):1:ecg_pos(i+1)
         m=((ecg_pos(i+1)-ecg_pos(i))/2)+ecg_pos(i); 
         if y(j)>y(j-1) && y(j)>y(j+1) && y(j)<ecg_peak(i+1) && j>s_pos(i) && j<p_pos(i+1) && j~=p_pos(i) && y(j)<min(ecg_peak) && j<m  && y(j)>s_peak(i) &&j<(p_pos(i)+((p_pos(i+1)-p_pos(i))*0.7)) && y(j)>p_peak(i)
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

%find the minimum size from all peaks

y_min1=min(length(p_peak),length(q_peak));
y_min2=min(y_min1,length(ecg_peak));
y_min3=min(y_min2,length(s_peak));
y_min=min(y_min3,length(t_peak));

%finding missed peaks
pos_mispeak=[];
p=[];
p_index=1;
q=[];
q_index=1;
r=[];
r_index=1;
s=[];
s_index=1;
t=[];
t_index=1;
j=1;
l=1;
m=1;
n=1;
o=1;

leave=1;
t_out=[];
for i=1:1:y_min
   if t_pos(i)-ecg_pos(i)>60  && t_pos(i)<ecg_pos(i+1)  %>70
     t_out(leave)=i;
     leave=leave+1;
   end
end

if length(t_out)>0
for i=1:t_out(length(t_out))

    p_pos(1)=[];
    q_pos(1)=[];
    ecg_pos(1)=[];
    s_pos(1)=[];
    t_pos(1)=[];
    p_peak(1)=[];
    q_peak(1)=[];
    ecg_peak(1)=[];
    s_peak(1)=[];
    t_peak(1)=[];
    i=i+1;                  
end
else
    t_out=0; 
end

y_min=y_min-t_out(length(t_out));
k=1;

for i=1:1:y_min  
   if t_pos(k)-ecg_pos(i) > 60|| t_pos(k)>ecg_pos(i+1)  %>70
        pos_mispeak(j)=i;
        j=j+1;
        t(t_index)=i;
        t_index=t_index+1;
        k=k-1;  
    end
     if ecg_pos(i)-p_pos(l)>50     %40
          pos_mispeak(j)=i;
          j=j+1;
          p(p_index)=i;
          p_index= p_index+1;
          l=l-1;
     end
     if ecg_pos(i)-q_pos(m)>20
          pos_mispeak(j)=i;
          j=j+1;
          q(q_index)=i;
          q_index=q_index+1;
          m=m-1;
     end
     if s_pos(n)-ecg_pos(i) >85
           pos_mispeak(j)=i;
           j=j+1;
           s(s_index)=i;
           s_index= s_index+1;
           n=n-1;
     end
     if ecg_pos(i+1)-ecg_pos(i)>300
           pos_mispeak(j)=i;
           j=j+1;
           r(r_index)=i;
           r_index=r_index+1;
           o=o-1;
     end     
   k=k+1;
   l=l+1;
   m=m+1;
   n=n+1;
   o=o+1;
end


if length(pos_mispeak)>0
   
    if pos_mispeak(1)==1
       if p_pos(1)<ecg_pos(2)
         p_pos(1)=[];
       else
             p(1)=[];
             
             for i=1:1:length(p)
              p(i)=p(i)-1;
             end
        end

        if q_pos(1)<ecg_pos(2)
            q_pos(1)=[];
        else
            q(1)=[];

            for i=1:1:length(q)
              q(i)=q(i)-1;
             end
        end

        if s_pos(1)<ecg_pos(2)
           s_pos(1)=[];
        else
           s(1)=[];
            for i=1:1:length(s)
              s(i)=s(i)-1;
            end
        end

        if t_pos(1)<ecg_pos(2)
            t_pos(1)=[];
        else
            t(1)=[];
            for i=1:1:length(t)
              t(i)=t(i)-1;
            end
        end

        ecg_pos(1)=[];
        pos_mispeak(1)=[];
  
         for i=1:1:length(pos_mispeak)
           pos_mispeak(i)=pos_mispeak(i)-1;
         end
   end
end

%RR interval

rr_int=[];
j=1;

if length(pos_mispeak)==0
  for i=1:y_min-1
    rr_int(j)=(ecg_pos(i+1)-ecg_pos(i))/fs;
    j=j+1;
    i=i+1;
  end
end

if length(pos_mispeak)>0
     index=1;
     avg_rr=0;
       if pos_mispeak(1)>2
          for i=1:1:pos_mispeak(1)
            rr_int(index) =(ecg_pos(i+1)-ecg_pos(i))/fs;
            avg_rr=avg_rr+rr_int(index);
            index=index+1;
          end
 
       end
      if length(pos_mispeak)==1     
           for j=pos_mispeak(1)+1:1:y_min
             rr_int(index) =(ecg_pos(j+1)-ecg_pos(j))/fs;
             index=index+1; 
           end 
     end
    
 if length(pos_mispeak)>1
      index1=1;
         for k=1:1:length(pos_mispeak)-1
            for l=pos_mispeak(k):1:pos_mispeak(k+1)
            rr_int(index) =(ecg_pos(l+1)-ecg_pos(l))/fs;
            index=index+1;  
            index1=index1+1;
               if k== length(pos_mispeak) && pos_mispeak(length(pos_mispeak))
                  for m=length(pos_mispeak):y_min
                   rr_int(index) =(ecg_pos(l+1)-ecg_pos(l))/fs;
                   index=index+1;
                   index1=index1+1;
                  end
              end
          end


  end
 end
end

%average of rr interval
avg_rr=mean(rr_int);

%heart rate calculation
HR=60/avg_rr;
disp(HR);


%Calculation of pr interval
pr_int=[];
j=1;
index=1;
 pr_p_incr=0;
pr_r_incr=0;
if  length (pos_mispeak)==0
for i=1:1:y_min
    pr_int(index)=(ecg_pos(i)-p_pos(i))/fs;
    index=index+1;
end 
end

if length (pos_mispeak)>=1
    if pos_mispeak(1)>2
        for i=1:1:pos_mispeak(1)-1
        pr_int(index)=(ecg_pos(i)-p_pos(i))/fs;
        index=index+1;

        end 
    end 

    if length(r)>=1
    if pos_mispeak(1)==r(1)
            pr_r_incr=pr_r_incr+1;
    end
    end

    if length(p)>=1
    if pos_mispeak(1)==p(1)
            pr_p_incr=pr_p_incr+1;
    end 
    end

end

if length(pos_mispeak)==1
    for i=pos_mispeak(1):1:y_min
        pr_int(index)=(ecg_pos(i+pr_p_incr)-p_pos(i+pr_r_incr))/fs;
        index=index+1;
      
    end 
end


pr_check_miss=0;


if length(pos_mispeak)>1
    
    for i=1:1:length(pos_mispeak)
        pr_check_miss=pr_check_miss+1;
        
        if i ==1 && (pr_r_incr == 0 && pr_p_incr == 0)
            

              if length(r)>=1
                  if r(pr_check_miss)==pos_mispeak(i)
                  pr_r_incr=pr_r_incr+1;
           
            
                  end
              end
    
                    if length(p)>=1
                        if p(pr_check_miss)==pos_mispeak(i)
                             pr_p_incr=pr_p_incr+1;
                         end
                    end
                    
        end 
        
        if i>1 && i~=length(pos_mispeak)

            
                   if length(r)>=1
                       if r(pr_check_miss)==pos_mispeak(i)
                         pr_r_incr=pr_r_incr+1;
           
            
                        end
                   end

                   if length(p)>=1
                      if p(pr_check_miss)==pos_mispeak(i)
                         pr_p_incr=pr_p_incr+1;
                      end
                   end

        end
        
        if i ~= length(pos_mispeak)
     
        for j=pos_mispeak(i):1:pos_mispeak(i+1)-1
            
       if ecg_pos(j+pr_p_incr)<ecg_pos(pos_mispeak(i+1)) && p_pos(j+pr_r_incr)<ecg_pos(pos_mispeak(i+1))

            pr_int(index)=(ecg_pos(j+pr_p_incr)-p_pos(j+pr_r_incr))/fs;
            index=index+1;
    
        end
        end
        else
               
                if length(r)>=1
                    if r(pr_check_miss)==pos_mispeak(i)
                     pr_r_incr=pr_r_incr+1;
                    end
                end
                   if length(p)>=1
                    if p(pr_check_miss)==pos_mispeak(i)
                     pr_p_incr=pr_p_incr+1;
                    end
                   end
                  
                   if i==length(pos_mispeak) && pos_mispeak(i) ~= y_min
                 
                   for k=pos_mispeak(i):1:y_min
                       
                       
                      pr_int(index)=(ecg_pos(k+pr_p_incr)-p_pos(k+pr_r_incr))/fs;
                      index=index+1;
                      
                   end
                   end  
            end
        end
    end

   
%average of pr interval

 avg_pr =mean(pr_int);

%calculation of qrs duration 

qrs_int=[];
j=1;
index=1;
 qrs_q_incr=0;
qrs_s_incr=0;
if  length (pos_mispeak)==0
for i=1:1:y_min
    qrs_int(index)=(s_pos(i)-q_pos(i))/fs;
    index=index+1;
end 
end

if length (pos_mispeak)>=1
    if pos_mispeak(1)>2
        for i=1:1:pos_mispeak(1)-1
        qrs_int(index)=(s_pos(i)-q_pos(i))/fs;
        index=index+1;

        end 
    end 

    if length(q)>=1
    if pos_mispeak(1)==t(1)
            qrs_q_incr=qrs_q_incr+1;
    end
    end

    if length(s)>=1
    if pos_mispeak(1)==s(1)
            qrs_s_incr=qrs_s_incr+1;
    end 
    end

end

if length(pos_mispeak)==1
    for i=pos_mispeak(1):1:y_min
        qrs_int(index)=(s_pos(i+qrs_q_incr)-q_pos(i+qrs_s_incr))/fs;
        index=index+1;
      
    end 
end


qrs_check_miss=0;


if length(pos_mispeak)>1
    
    for i=1:1:length(pos_mispeak)
        qrs_check_miss=qrs_check_miss+1;
        
        if i ==1 && (qrs_q_incr == 0 && qrs_s_incr == 0)
            

              if length(q)>=1
                  if q(qrs_check_miss)==pos_mispeak(i)
                  qrs_q_incr=qrs_q_incr+1;
           
            
                  end
              end
    
                    if length(s)>=1
                        if s(qrs_check_miss)==pos_mispeak(i)
                             qrs_s_incr=qrs_s_incr+1;
                         end
                    end
                    
        end 
        
        if i>1 && i~=length(pos_mispeak)

            
                   if length(q)>=1
                       if q(qrs_check_miss)==pos_mispeak(i)
                         qrs_q_incr=qrs_q_incr+1;
           
            
                        end
                   end

                   if length(s)>=1
                      if s(qrs_check_miss)==pos_mispeak(i)
                         qrs_s_incr=qrs_s_incr+1;
                      end
                   end

        end
        
        if i ~= length(pos_mispeak)
     
        for j=pos_mispeak(i):1:pos_mispeak(i+1)-1
            
       if q_pos(j+qrs_s_incr)<ecg_pos(pos_mispeak(i+1)) && s_pos(j+qrs_q_incr)<ecg_pos(pos_mispeak(i+1))

            qrs_int(index)=(s_pos(j+qrs_q_incr)-q_pos(j+qrs_s_incr))/fs;
            index=index+1;
    
        end
        end
        else
               
                if length(q)>=1
                    if q(qrs_check_miss)==pos_mispeak(i)
                     qrs_q_incr=qrs_q_incr+1;
                    end
                end
                   if length(s)>=1
                    if s(qrs_check_miss)==pos_mispeak(i)
                     qrs_s_incr=qrs_s_incr+1;
                    end
                   end
                  
                   if i==length(pos_mispeak) && pos_mispeak(i) ~= y_min
                 
                   for k=pos_mispeak(i):1:y_min
                       
                       
                      qrs_int(index)=(s_pos(k+qrs_q_incr)-q_pos(k+qrs_s_incr))/fs;
                      index=index+1;
                      
                   end
                   end  
            end
        end
    end

%average of st interval
avg_qrs=mean(qrs_int);


%calculation of st interval

st_int=[];
j=1;
index=1;
 st_t_incr=0;
st_s_incr=0;
if  length (pos_mispeak)==0
for i=1:1:y_min
    st_int(index)=(t_pos(i)-s_pos(i))/fs;
    index=index+1;
end 
end

if length (pos_mispeak)>=1
    if pos_mispeak(1)>2
        for i=1:1:pos_mispeak(1)-1
        st_int(index)=(t_pos(i)-s_pos(i))/fs;
        index=index+1;

        end 
    end 

    if length(t)>=1
    if pos_mispeak(1)==t(1)
            st_t_incr=st_t_incr+1;
    end
    end

    if length(s)>=1
    if pos_mispeak(1)==s(1)
            st_s_incr=st_s_incr+1;
    end 
    end

end

if length(pos_mispeak)==1
    for i=pos_mispeak(1):1:y_min
        st_int(index)=(t_pos(i+st_s_incr)-s_pos(i+st_t_incr))/fs;
        index=index+1;
      
    end 
end


st_check_miss=0;


if length(pos_mispeak)>1
    
    for i=1:1:length(pos_mispeak)
        st_check_miss=st_check_miss+1;
        
        if i ==1 && (st_t_incr == 0 && st_s_incr == 0)
            

              if length(t)>=1
                  if t(st_check_miss)==pos_mispeak(i)
                  st_t_incr=st_t_incr+1;
           
            
                  end
              end
    
                    if length(s)>=1
                        if s(st_check_miss)==pos_mispeak(i)
                             st_s_incr=st_s_incr+1;
                         end
                    end
                    
        end 
        
        if i>1 && i~=length(pos_mispeak)

            
                   if length(t)>=1
                       if t(st_check_miss)==pos_mispeak(i)
                         st_t_incr=st_t_incr+1;
           
            
                        end
                   end

                   if length(s)>=1
                      if s(st_check_miss)==pos_mispeak(i)
                         st_s_incr=st_s_incr+1;
                      end
                   end

        end
        
        if i ~= length(pos_mispeak)
     
        for j=pos_mispeak(i):1:pos_mispeak(i+1)-1
            
       if t_pos(j+st_s_incr)<ecg_pos(pos_mispeak(i+1)) && s_pos(j+st_t_incr)<ecg_pos(pos_mispeak(i+1))

            st_int(index)=(t_pos(j+st_s_incr)-s_pos(j+st_t_incr))/fs;
            index=index+1;
    
        end
        end
        else
               
                if length(t)>=1
                    if t(st_check_miss)==pos_mispeak(i)
                     st_t_incr=st_t_incr+1;
                    end
                end
                   if length(s)>=1
                    if s(st_check_miss)==pos_mispeak(i)
                     st_s_incr=st_s_incr+1;
                    end
                   end
                  
                   if i==length(pos_mispeak) && pos_mispeak(i) ~= y_min
                 
                   for k=pos_mispeak(i):1:y_min
                       
                       
                      st_int(index)=(t_pos(k+st_s_incr)-s_pos(k+st_t_incr))/fs;
                      index=index+1;
                      
                   end
                   end  
            end
        end
    end

%average of st interval
avg_st=mean(st_int);

%calculation of st interval

qt_int=[];
j=1;
index=1;
 qt_t_incr=0;
qt_q_incr=0;
if  length (pos_mispeak)==0
for i=1:1:y_min
   qt_int(index)=(t_pos(i)-q_pos(i))/fs;
    index=index+1;
end 
end

if length (pos_mispeak)>=1
    if pos_mispeak(1)>2
        for i=1:1:pos_mispeak(1)-1
       qt_int(index)=(t_pos(i)-q_pos(i))/fs;
        index=index+1;

        end 
    end 

    if length(t)>=1
    if pos_mispeak(1)==t(1)
            qt_t_incr=qt_t_incr+1;
    end
    end

    if length(q)>=1
    if pos_mispeak(1)==q(1)
            qt_q_incr=qt_q_incr+1;
    end 
    end

end

if length(pos_mispeak)==1
    for i=pos_mispeak(1):1:y_min
        qt_int(index)=(t_pos(i+qt_q_incr)-q_pos(i+qt_t_incr))/fs;
        index=index+1;
      
    end 
end


qt_check_miss=0;


if length(pos_mispeak)>1
    
    for i=1:1:length(pos_mispeak)
        qt_check_miss=qt_check_miss+1;
        
        if i ==1 && (qt_t_incr == 0 && qt_q_incr == 0 )
            

              if length(t)>=1
                  if t(qt_check_miss)==pos_mispeak(i)
                  qt_t_incr=qt_t_incr+1;
           
            
                  end
              end
    
                    if length(q)>=1
                        if q(qt_check_miss)==pos_mispeak(i)
                             qt_q_incr=qt_q_incr+1;
                         end
                    end
                    
        end 
        
        if i>1 && i~=length(pos_mispeak)

            
                   if length(t)>=1
                       if t(qt_check_miss)==pos_mispeak(i)
                         qt_t_incr=qt_t_incr+1;
           
            
                        end
                   end

                   if length(q)>=1
                      if q(qt_check_miss)==pos_mispeak(i)
                         qt_q_incr=qt_q_incr+1;
                      end
                   end

        end
        
        if i ~= length(pos_mispeak)
     
        for j=pos_mispeak(i):1:pos_mispeak(i+1)-1
            
       if t_pos(j+qt_q_incr)<ecg_pos(pos_mispeak(i+1)) && q_pos(j+qt_t_incr)<ecg_pos(pos_mispeak(i+1))

            qt_int(index)=(t_pos(j+qt_q_incr)-q_pos(j+qt_t_incr))/fs;
            index=index+1;
    
        end
        end
        else
               
                if length(t)>=1
                    if t(qt_check_miss)==pos_mispeak(i)
                    qt_t_incr=qt_t_incr+1;
                    end
                end
                   if length(q)>=1
                    if q(qt_check_miss)==pos_mispeak(i)
                     qt_q_incr=qt_q_incr+1;
                    end
                   end
                  
                   if i==length(pos_mispeak) && pos_mispeak(i) ~= y_min
                 
                   for k=pos_mispeak(i):1:y_min
                       
                       
                      qt_int(index)=(t_pos(k+qt_q_incr)-q_pos(k+qt_t_incr))/fs;
                      index=index+1;
                      
                   end
                   end  
            end
        end
    end

    


%average of qt interval
avg_qt=mean(qt_int);


%calculation of rt interval
rt_int=[];

j=1;
index=1;
 rt_t_incr=0;
rt_r_incr=0;
if  length (pos_mispeak)==0
for i=1:1:y_min
   rt_int(index)=(t_pos(i)-ecg_pos(i))/fs;
    index=index+1;
end 
end

if length (pos_mispeak)>=1
    if pos_mispeak(1)>2
        for i=1:1:pos_mispeak(1)-1
       rt_int(index)=(t_pos(i)-ecg_pos(i))/fs;
        index=index+1;

        end 
    end 

    if length(t)>=1
     
    if pos_mispeak(1)==t(1)
         rt_t_incr=rt_t_incr+1;
    end
    end

    if length(r)>=1
    if pos_mispeak(1)==r(1)
            rt_r_incr=rt_r_incr+1;
    end 
    end

end

if length(pos_mispeak)==1
    for i=pos_mispeak(1):1:y_min
        rt_int(index)=(t_pos(i+rt_r_incr)-ecg_pos(i+rt_t_incr))/fs;
        index=index+1;
      
    end 
end


rt_check_miss=0;


if length(pos_mispeak)>1
    
    for i=1:1:length(pos_mispeak)
        rt_check_miss=rt_check_miss+1;
        
        if i ==1 && (rt_t_incr == 0 && rt_r_incr == 0 )
            

              if length(t)>=1
                  if t(rt_check_miss)==pos_mispeak(i)
                  rt_t_incr=rt_t_incr+1;
           
            
                  end
              end
    
                    if length(r)>=1
                        if r(rt_check_miss)==pos_mispeak(i)
                             rt_r_incr=rt_r_incr+1;
                         end
                    end
                    
        end 
        
        if i>1 && i~=length(pos_mispeak)

            
                   if length(t)>=1
                       if t(rt_check_miss)==pos_mispeak(i)
                         rt_t_incr=rt_t_incr+1;
           
            
                        end
                   end

                   if length(r)>=1
                      if r(rt_check_miss)==pos_mispeak(i)
                         rt_r_incr=rt_r_incr+1;
                      end
                   end

        end
        
        if i ~= length(pos_mispeak)
     
        for j=pos_mispeak(i):1:pos_mispeak(i+1)-1
            
       if t_pos(j+rt_r_incr)<ecg_pos(pos_mispeak(i+1)) && ecg_pos(j+rt_t_incr)<ecg_pos(pos_mispeak(i+1))

            rt_int(index)=(t_pos(j+rt_r_incr)-ecg_pos(j+rt_t_incr))/fs;
            index=index+1;
    
        end
        end
        else
               
                if length(t)>=1
                    if t(rt_check_miss)==pos_mispeak(i)
                    rt_t_incr=rt_t_incr+1;
                    end
                end
                   if length(r)>=1
                    if r(rt_check_miss)==pos_mispeak(i)
                     rt_r_incr=rt_r_incr+1;
                    end
                   end
                  
                   if i==length(pos_mispeak) && pos_mispeak(i) ~= y_min
                 
                   for k=pos_mispeak(i):1:y_min
                       
                       
                      rt_int(index)=(t_pos(k+rt_r_incr)-ecg_pos(k+rt_t_incr))/fs;
                      index=index+1;
                      
                   end
                   end  
            end
        end
    end


%average of qt interval
avg_rt=mean(rt_int);

dBp = 210.86774418011 - (394.12035854481 * rt_int);
Bp = mean(dBp);
dDbp = 110.606825109447 - (96.651802662872 * rt_int);
Dbp = mean(dDbp);

max_dBp=max(dBp);
min_dBp=min(dBp);
max_dDbp=max(dDbp);
min_dDbp=min(dDbp);

% check the Bp variation
%mis_bp=[];
%j=1;
%for i=1:1:length(dBp)
 %   if  abs(Bp-dBp(i)) >10
  %      mis_bp(j)=i;
   %     j=j+1;
   % end
%end

%j=0;
%if length(mis_bp)>0
    
%for i=1:1:length(mis_bp)
%     disp(i-j);
%    dBp(mis_bp(i)-j)=[];
%    j=j+1;
   
%end
%end 




%find p wave presence 
p_presence=0;
if length(p_pos)<=1
    p_presence=1;
else
    disp('p wave is present');
end


%find the polarity of t wave
if length(t_pos)<2
  disp('might be ischemia');
end


