s = tf('s');

Gpi = 1.2 + (333.3334/s);

Gvd = (-3.846e4*(s-8000))/...
      (s^2 + 2*(0.158)*(2531.86)*s + (2531.86)^2);

Gol = Gpi*Gvd;

figure;
bode(Gol)
grid on

[GM,PM,Wcg,Wcp] = margin(Gol)

figure;
margin(Gol)