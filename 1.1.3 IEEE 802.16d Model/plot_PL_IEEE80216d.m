clear, clf, clc

fc = 2e9;  htx = [30 30];  hrx = [2 10];  distance = 1:1000;
for k = 1:2    
  y_IEEE16d(k,:) = PL_IEEE80216d(fc, distance, 'A', htx(k), hrx(k), 'atnt');
  y_MIEEE16d(k,:) = PL_IEEE80216d(fc, distance, 'A', htx(k), hrx(k), 'atnt', 'mod');
end
subplot(121)
semilogx(distance,y_IEEE16d(1,:),'k:','linewidth',1.5), hold on
semilogx(distance,y_IEEE16d(2,:),'k-','linewidth',1.5), grid on 
title(['IEEE 802.16d path loss model, f_c=',num2str(fc/1e6),'MHz'])
axis([1 1000 10 150]), xlabel('Distance [m]'), ylabel('Path loss [dB]')
legend('h_{Tx}=30m, h_{Rx}=2m','h_{Tx}=30m, h_{Rx}=10m','Location','northwest')
subplot(122)
semilogx(distance,y_MIEEE16d(1,:),'k:','linewidth',1.5), hold on
semilogx(distance,y_MIEEE16d(2,:),'k-','linewidth',1.5), grid on 
title(['Modified IEEE 802.16d path loss model, f_c=', num2str(fc/1e6), 'MHz'])
axis([1 1000 10 150]), xlabel('Distance [m]'), ylabel('Path loss [dB]')
legend('h_{Tx}=30m, h_{Rx}=2m','h_{Tx}=30m, h_{Rx}=10m','Location','northwest')