clear, clf

N=2e5;  level=30;  K_dB=[-40, 15];
gss=['k-s'; 'b-o'; 'r-^'];
% Rayleigh model
Rayleigh_ch = Ray_model(N); 
[temp,x] = hist(abs(Rayleigh_ch(1,:)),level);   
plot(x,temp,gss(1,:)), hold on
% Rician model
for i = 1:length(K_dB)
    Rician_ch(i,:) = Ric_model(K_dB(i),N);
    [temp,x] = hist(abs(Rician_ch(i,:)),level);   
    plot(x,temp,gss(i+1,:))
end
xlabel('x'), ylabel('Occurance')
legend('Rayleigh','Rician, K=-40dB','Rician, K=15dB')