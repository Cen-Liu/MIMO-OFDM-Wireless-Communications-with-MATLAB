clear, clf, clc

fc = 1.5e9;
d0 = 100;
sigma = 3;
distance = (1:2:31).^2;
Gt = [1, 1, 0.5];
Gr = [1, 0.5, 0.5];
Exp = [2, 3, 6]; 
for k = 1:3
    y_Free(k,:) = PL_free(fc, distance, Gt(k), Gr(k));
    y_logdist(k,:) = PL_logdist_or_norm(fc, distance, d0, Exp(k));
    y_lognorm(k,:) = PL_logdist_or_norm(fc, distance, d0, Exp(1), sigma);
end
subplot(131)
semilogx(distance, y_Free(1,:), 'k-o', distance, y_Free(2,:), 'b-^', distance, y_Free(3,:), 'r-s')
grid on, axis([1 1000 40 110]), title(['Free path loss model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance [m]'), ylabel('Path loss [dB]')
legend('G_t=1, G_r=1','G_t=1, G_r=0.5','G_t=0.5, G_r=0.5','Location','northwest')
subplot(132)
semilogx(distance, y_logdist(1,:), 'k-o', distance, y_logdist(2,:), 'b-^', distance, y_logdist(3,:), 'r-s')
grid on, axis([1 1000 40 110]),
title(['Log-distance path loss model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance [m]'), ylabel('Path loss [dB]'), legend('n=2','n=3','n=6','Location','northwest')
subplot(133)
semilogx(distance, y_lognorm(1,:), 'k-o', distance, y_lognorm(2,:), 'b-^', distance, y_lognorm(3,:), 'r-s')
grid on, axis([1 1000 40 110]),
title(['Log-normal path loss model, f_c=',num2str(fc/1e6),'MHz, ','\sigma=',num2str(sigma),'dB, ','n=2'])
xlabel('Distance [m]'), ylabel('Path loss [dB]'), legend('Path 1','Path 2','Path 2','Location','northwest')