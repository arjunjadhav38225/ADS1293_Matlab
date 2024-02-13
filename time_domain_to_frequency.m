
fs=200e3;
t=1/fs;
dt=0:t:5e-3-t;
f1=1e3;
f2=20e3;
f3=30e3;
y=5*sin(2*pi*f1*dt)+5*sin(2*pi*f2*dt)+5*sin(2*pi*f3*dt);

z=fft(y);
plot(z);