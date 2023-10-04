clear, close all

% Parameters
fd = 926;   % Doppler frequency
Ts = 1e-6;  % Sampling time
M = 2^12;
t = (0:M-1)*Ts;
f = (-M/2:M/2-1)/(M*Ts*fd);
Ns = 50000;
t_state= 0;
% Channel generation
[h,t_state] = Jakes_Flat(fd,Ts,Ns,t_state,1,0);

subplot(311)
plot((1:Ns)*Ts,10*log10(abs(h)),'k-'), axis([0 Ns*Ts -20 10])
title(['Jakes Model, f_d=',num2str(fd),'Hz, T_s=',num2str(Ts),'s']);
xlabel('Time [s]'), ylabel('Magnitude[dB]')
subplot(323)
hist(abs(h),50);
title(['Jakes Model, f_d=',num2str(fd),'Hz, T_s=',num2str(Ts),'s']);
xlabel('Magnitude'), ylabel('Occasions')
subplot(324)
hist(angle(h),50);
title(['Jakes Model, f_d=',num2str(fd),'Hz, T_s=',num2str(Ts),'s']);
xlabel('Phase [rad]'), ylabel('Occasions')
% Autocorrelation of channel
temp = zeros(2,Ns);
for i = 1:Ns
    j = i:Ns;
    temp1(1:2,j-i+1)= temp(1:2,j-i+1)+[h(i)'*h(j); ones(1,Ns-i+1)];
end
for k = 1:M
    Simulated_corr(k) = real(temp1(1,k))/temp1(2,k);
end
Classical_corr = besselj(0,2*pi*fd*t);
% Fourier transform of autocorrelation
Classical_Y = fftshift(fft(Classical_corr));
Simulated_Y = fftshift(fft(Simulated_corr));
subplot(325)
plot(t,abs(Classical_corr),'k-', t,abs(Simulated_corr),'b:')
title(['Autocorrelation, f_d=',num2str(fd),'Hz'])
grid on, xlabel('Delay \tau [s]'), ylabel('Correlation')
legend('Classical','Simulation')
subplot(326)
plot(f,abs(Classical_Y),'k-', f,abs(Simulated_Y),'b:')
title(['Doppler Spectrum,f_d=',num2str(fd),'Hz'])
axis([-1 1 0 600]), xlabel('f/f_d'), ylabel('Magnitude')
legend('Classical','Simulation')