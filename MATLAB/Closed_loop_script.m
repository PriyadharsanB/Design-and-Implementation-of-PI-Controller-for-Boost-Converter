clc;
clear;
close all;

num = [-46152 3.56356e8 1.0256e11];

den = [1 -3816.13224 4.204359146e7 1.0256e10];

T = tf(num,den);

figure;
margin(T);
grid on;

[GM,PM,Wcg,Wcp] = margin(T);

fprintf('Gain Margin = %.2f dB\n',20*log10(GM));
fprintf('Phase Margin = %.2f deg\n',PM);
fprintf('Gain Crossover Frequency = %.2f rad/s\n',Wcp);
fprintf('Phase Crossover Frequency = %.2f rad/s\n',Wcg);