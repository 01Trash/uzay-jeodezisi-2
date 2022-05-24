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

## ŞİMDİ SALLAMA ZAMANI!!!
% sallama x değerleri
a_x = -10000;
b_x = 0;
c_x = 23000;
d_x = pi/3;
f_x = pi/6;
% sallama y değerleri
a_y = -6000;
b_y = 0;
c_y = 12000;
d_y = pi/4;
f_y = pi/6;
% sallama z değerleri
a_z = -10000;
b_z = 0;
c_z = 22000;
d_z = pi/3;
f_z = pi/6;


a_x_son = -10000;
a_x_sapka = 1;
while (a_x_sapka - a_x > 5.0E-12)

    a_x = a_x_son;
    k = 1;
    for k = 1:97;
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
    a_x_son = a_x_sapka;
##    fprintf("a_x_sapka - a_x: %7.20f\n", a_x_sapka - a_x);

endwhile
fprintf("a_x_son: %7.20f\n", a_x_son);

a_x = a_x_son;

b_x_son = 0;
b_x_sapka = 1;
while (b_x_sapka - b_x > 5.0E-12)

    b_x = b_x_son;
    k = 1;
    for k = 1:97;
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
    b_x_sapka = b_x + Delta_sapka(2,1);
    b_x_son = b_x_sapka;
##    fprintf("b_x_son - b_x: %7.20f\n", b_x_son - b_x);

endwhile
fprintf("b_x_son: %7.20f\n", b_x_son);

b_x = b_x_son;

c_x_son = 23000;
c_x_sapka = 24000;
while (c_x_sapka - c_x > 5.0E-12)

    c_x = c_x_son;
    k = 1;
    for k = 1:97;
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
    c_x_sapka = c_x + Delta_sapka(3,1);
    c_x_son = c_x_sapka;
##    fprintf("c_x_son - c_x: %7.20f\n", c_x_son - c_x);

endwhile
fprintf("c_x_son: %7.20f\n", c_x_son);

c_x = c_x_son;

d_x_son = pi/3;
d_x_sapka = pi;
while (d_x_sapka - d_x > 5.0E-12)

    d_x = d_x_son;
    k = 1;
    for k = 1:97;
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
    d_x_sapka = d_x + Delta_sapka(4,1);
    d_x_son = d_x_sapka;
##    fprintf("d_x_son - d_x: %7.20f\n", d_x_son - d_x);

endwhile
fprintf("d_x_son: %7.20f\n", d_x_son);

d_x = d_x_son;

f_x_son = pi/6;
f_x_sapka = pi;
while (f_x_sapka - f_x > 5.0E-12)

    f_x = f_x_son;
    k = 1;
    for k = 1:97;
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
    f_x_sapka = f_x + Delta_sapka(5,1);
    f_x_son = f_x_sapka;
##    fprintf("f_x_son - f_x: %7.20f\n", f_x_son - f_x);

endwhile
fprintf("f_x_son: %7.20f\n", f_x_son);

f_x = f_x_son;

###########################################





