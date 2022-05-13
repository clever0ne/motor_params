clc; close all; clear;

%% Параметры для расчётов

% Число гармоник разложения в ряд Фурье
MAX_ORDER = 15;
% Число пар полюсов
POLE_PAIRS = 3;
% Коэффициент заполнения паза фазными обмотками
FILL_FACTOR = 1/3;
% Плотность тока в [А/м^2] без учёта коэффициента
CURRENT_DENSITY = 25000000;
% Длина активного пакета статора в [м]
STATOR_CORE_DEPTH = 50 * 10^-3;
% Диаметр расточки статора в [м]
STATOR_BORE_DIAMETER = 90 * 10^-3;
% Площадь поперечного сечения паза в [м^2]
GROOVE_CROSS_SECTION_AREA = 557 * 10^-6;

% Удельное сопротивление меди в [Ом*м]
CUPRUM_RESISTIVITY = 1.68 * 10^-8;
% Плотность тока в фазных обмотках [А/м^2]
WINDING_CURRENT_DENSITY = CURRENT_DENSITY * FILL_FACTOR;
% Суммарная площадь фазных обмоток в [м]
WINDING_SUM_CROSS_SECTION_AREA = 4 * GROOVE_CROSS_SECTION_AREA * FILL_FACTOR;

%% Результаты расчётов электромагитного момента в CAE
[angle, torque] = load_data('../../torque.csv');
len = (min(length(angle), length(torque)) + 1) / 2;

%% Построение графиков
print_torque_plot(angle(1 : len), torque(1 : len), 'torque');
[magn, phase] = fourier_transform(torque);

torques = zeros(MAX_ORDER + 1, 2 * len - 1);
for order = 0 : MAX_ORDER
    torques(order + 1, :) = magn(order + 1)*cos(order*angle*(pi/180) + phase(order + 1));
end

print_torque_spectrum_plot(magn(1 : MAX_ORDER + 1));
print_torque_fourier_decomposition_plots(angle(1 : len), torques(:, 1 : len), 'torque');

sumtorque = sum(torques);
print_torque_plot(angle(1 : len), [torque(1 : len); sumtorque(1 : len)], 'sum_torque');
print_phase_switching_torque_plot(angle(1 : len), torque(1 : len), POLE_PAIRS, 'phase_torque');

%% Расчёт параметров эффективности

% Псевдонимы для краткости
j = WINDING_CURRENT_DENSITY;
ro = CUPRUM_RESISTIVITY;
la = STATOR_CORE_DEPTH;
di = STATOR_BORE_DIAMETER;
k = FILL_FACTOR;
sgr = GROOVE_CROSS_SECTION_AREA;
sw = WINDING_SUM_CROSS_SECTION_AREA;
p = POLE_PAIRS;

% Вспомогательные значения
m3 = magn(1 + 3);
msum = sum(magn(1 : MAX_ORDER + 1));
phi = 0 : 1 : 180;
dphi = (phi(end) - phi(1)) / p;
m = spline(angle(1 : len), torque(1 : len), phi);
m = max([m; m(1 + phi(end) + 1 - dphi : 1 + phi(end)), ...
            m(1 + dphi : phi(end) + 1 - dphi), ...
            m(1 + phi(1) : dphi)]);
mmin = min(m);
mmax = max(m);
mmean = mean(m(1 + (phi(1) + dphi / 2 : 1 : phi(end) - dphi / 2)));
p = j^2 * ro * la * sw;

% Расчёт коэффициентов
kgamma = m3 / sqrt(msum - m3);
dm = (mmax - mmin) / (2 * mmean);
kf = sgr * k / (2 * ro * 2 * la);
kt = mmax / p;
sigma = 2 * mmean / (pi * di^2 * la);

print_efficiency_coefficients(kgamma, dm, kf, kt, sigma, 'result');

