clear;
close all;
clc;

[y,fs]=audioread('corrupt-sound20.wav');
y_1=medfilt1(y);
%fs=8000HZ 
Ts = 1/fs;
N  = size(y_1,1); 
t = (0:N-1)*Ts;
delta_f = 1*fs/N;
x =y_1;

X = fftshift(abs(fft(x)))/N;
X_angle = fftshift(angle(fft(x)));
wf = (-N/2:N/2-1)*delta_f;
 
figure(1);
subplot(2,1,1);
plot(t,x);
title('original signal after median filter'),grid on,xlabel('frequency(HZ)');
subplot(2,1,2);
plot(wf,X);
grid on;
title('original signal frequency after median filter'),xlabel('frequency(HZ)');

%% Chebyshev filter design
wp = 1/(fs/2);  %Passband cut-off frequency to be normalized
ws = 1000/(fs/2);  %Stop band cutoff frequency to be normalized
alpha_p = 3; %maximum attenuation allowed by the passband is 3 db
alpha_s = 50;%stop band allows a minimum attenuation of 40 db
[ N1 wc1 ] = cheb1ord( wp , ws , alpha_p , alpha_s);
[ b a ] = cheby1(N1,alpha_p,wc1,'low');
%filtering
filter_lp_s = filter(b,a,x);
X_lp_s = fftshift(abs(fft(filter_lp_s)))/N;
figure(2);
freqz(b,a); %Filter spectral characteristics
figure(3);

subplot(2,1,1);
plot(t,filter_lp_s),title('time domain after low-pass-filter'),xlabel('time(S)'),grid on;

subplot(2,1,2);
plot(wf,X_lp_s),title('frequency domain after low-pass-filter'),xlabel('frequency(HZ)'),grid on;

%% figure below is the power spectrum comparison after filtering
xn=y_1;
window=boxcar(length(xn));
nfft=1024;
[Pxx,wf]=periodogram(y_1,window,nfft,fs);
[Pxx_1,f_1]=periodogram(X_lp_s,window,nfft,fs);
figure(2);
subplot(1,2,1);
plot(wf,10*log10(Pxx)),title('the power spectrum of corrupt signal'),xlabel('frequency(HZ)'),grid on;

subplot(1,2,2);
plot(wf,10*log10(Pxx_1)),title('the power spectrum of Chebyshev filter processed signal'),xlabel('frequency(HZ)'),grid on;


