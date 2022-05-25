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
##a_x = 44;
##b_x = 0;
##c_x = 20000;
##d_x = pi/3;
##f_x = -pi/6;
% sallama y değerleri
a_y = 0;
b_y = 0;
c_y = 12000;
d_y = pi/4;
f_y = pi/6;
% sallama z değerleri
##a_z = -10000;
##b_z = 0;
##c_z = 22000;
##d_z = pi/3;
##f_z = pi/6;

##i: 219
##a_y_sapka: -21.187 [km]
##b_y_sapka:  -0.008 [km/h]
##c_y_sapka: 12628.308 [km]
##d_y_sapka: 177.218 [°]
##f_y_sapka: 328.037 [°/h]
##m0:   5.728 [km]

a_y_son = a_y;
b_y_son = b_y;
c_y_son = c_y;
d_y_son = d_y;
f_y_son = f_y;

i = 0;

a_y_sapka = 1;
while (abs(a_y_sapka - a_y) > 1.0E-9)

    a_y = a_y_son;
    b_y = b_y_son;
    c_y = c_y_son;
    d_y = d_y_son;
    f_y = f_y_son;
    k = 1;
    for k = 1:97;
        % l_x hesapla
        Y = M(k,6);
        Delta_j = M(k,2);
        l_y(k,1) = Y - (a_y + b_y*Delta_j + c_y*sin(d_y+f_y*Delta_j));
        % A matrisi
        A(k,1) = 1;
        A(k,2) = M(k,2);
        A(k,3) = sin(d_y+f_y*Delta_j);
        A(k,4) = c_y*cos(d_y+f_y*Delta_j);
        A(k,5) = c_y*cos(d_y+f_y*Delta_j)*Delta_j;

        k = k + 1;
    endfor

    % A matrisi transpose
    A_transpose = transpose(A);
    % A_transpose * A
    Q_delta = inv(A_transpose * A);
    % A_T_l
    A_T_l = A_transpose * l_y;
    % Delta_sapka
    Delta_sapka = Q_delta * A_T_l;
    % a_x_sapka
    a_y_sapka = a_y + Delta_sapka(1,1);
    b_y_sapka = b_y + Delta_sapka(2,1);
    c_y_sapka = c_y + Delta_sapka(3,1);
    d_y_sapka = d_y + Delta_sapka(4,1);
    f_y_sapka = f_y + Delta_sapka(5,1);

    a_y_son = a_y_sapka;
    b_y_son = b_y_sapka;
    c_y_son = c_y_sapka;
    d_y_son = d_y_sapka;
    f_y_son = f_y_sapka;


    fprintf("a_y_sapka - a_y: %7.20f\n", a_y_sapka - a_y);
    fprintf("b_y_sapka - b_y: %7.20f\n", b_y_sapka - b_y);
    fprintf("c_y_sapka - c_y: %7.20f\n", c_y_sapka - c_y);
    fprintf("d_y_sapka - d_y: %7.20f\n", d_y_sapka - d_y);
    fprintf("f_y_sapka - f_y: %7.20f\n\n", f_y_sapka - f_y);


##    fprintf("Delta_sapka: %7.20f\n", Delta_sapka(1,1));
##    fprintf("Delta_sapka: %7.20f\n", Delta_sapka(2,1));
##    fprintf("Delta_sapka: %7.20f\n", Delta_sapka(3,1));
##    fprintf("Delta_sapka: %7.20f\n", Delta_sapka(4,1));
##    fprintf("Delta_sapka: %7.20f\n\n", Delta_sapka(5,1));

i = i + 1;
endwhile

fprintf("i: %d\n", i);

fprintf("a_y_sapka: %7.3f [km]\n", a_y_sapka);
fprintf("b_y_sapka: %7.3f [km/h]\n", b_y_sapka);
fprintf("c_y_sapka: %7.3f [km]\n", c_y_sapka);
fprintf("d_y_sapka: %7.13f [radyan]\n", d_y_sapka);
fprintf("f_y_sapka: %7.13f [radyan/h]\n", f_y_sapka);
fprintf("d_y_sapka: %7.13f [°]\n", d_y_sapka*180/pi);
fprintf("f_y_sapka: %7.13f [°/h]\n\n", f_y_sapka*180/pi);

##m0 değer hesabı
v = A * Delta_sapka - l_y;
v_transpose = transpose(v);
m0 = sqrt((v_transpose * v)/92);
fprintf("m0: %7.3f [km]\n", m0);




