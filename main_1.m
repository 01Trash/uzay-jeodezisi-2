clc, clear
pkg load io


%%% Yerin açısal dönme hızı rad/s
We = 7292115.1467E-11;


%%% Verileri çek
filename = 'pre.ods';
data_source = xlsread(filename);

[m,n] = size(data_source);
for i = 1:m;

    x(i,1) = data_source(i,5);
    y(i,1) = data_source(i,6);
    z(i,1) = data_source(i,7);
    T(i,1) = data_source(i,8);

    i = i + 1;

endfor


time = 0;
time_saniye = 0;
j = 1;
for j = 1:97;

    % 1. sutün
    M(j,1) = j;
    %2. sütun
    M(j,2) = time;
    %3. sütun
    M(j,3) = time_saniye;
    % 4. sütun => alfa değeri
    alfa = -time_saniye * We;
    M(j,4) = alfa;
    % 5. sütun => x
    M(j,5) = cos(alfa)*x(j,1) + sin(alfa)*y(j,1);
    % 6. sütun => y
    M(j,6) = -sin(alfa)*x(j,1) + cos(alfa)*y(j,1);
    % 7. sütun => z
    M(j,7) = z(j,1);

    % Grafikler x y z
    gra_x(j,1) = M(j,5);
    gra_y(j,1) = M(j,6);
    gra_z(j,1) = M(j,7);
    gra_t(j,1) = time;


    j = j + 1;
    time = time + 0.25;
    time_saniye = time_saniye + 900;

endfor


##plot(gra_t, gra_x)
##hold on
##plot(gra_t, gra_y)
##hold on
##plot(gra_t, gra_z)
##legend("x", "y", "z")
##set(gca, 'xtick', 0:2:24);
##grid on


k = 1;
for k = 1:97;

    % sabit x değerleri
    a_x = -10000;
    b_x = 0;
    c_x = 23000;
    d_x = pi/3;
    f_x = pi/6;
    % l_x hesapla
    X = M(k,5);
    Delta_j = M(k,2);
    l_x(k,1) = X - (a_x + b_x*Delta_j + c_x*sin(d_x+f_x*Delta_j));
    % A matrisi
    A(k,1) = 1;
    A(k,2) = M(k,2);
    A(k,3) = sin(d_x+f_x*Delta_j);
    A(k,4) = c_x*cos(d_x+f_x*Delta_j);
    A(k,5) = c_x*cos(d_x+f_x*Delta_j)*Delta_j;


    k = k + 1;

endfor


% A matrisi transpose
A_transpose = transpose(A);
% A_transpose * A
Q_delta = inv(A_transpose * A);
% A_T_l
A_T_l = A_transpose * l_x;
% Delta_sapka
Delta_sapka = Q_delta * A_T_l;
% a_x_sapka
a_x_sapka = a_x + Delta_sapka(1,1);




##s = 1;
##for s = 1:97;
##
##    % A_T_l
##    A_T_l = A_transpose * l_x;
##
##    s = s + 1;
##
##endfor



