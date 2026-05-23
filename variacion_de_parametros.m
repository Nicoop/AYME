clear; clc; close all;
P_p = 3; lambda_m_prima = 0.016; L_q = 5.8e-3; 
alpha_Cu = 3.9e-3; Rs_ref = 1.02; T_ref = 20;

J_eq_min = 1.9785e-5;  b_eq_min = 2.1944e-5;
J_eq_max = 4.5826e-5;  b_eq_max = 2.4028e-5;

temp_vec = -15:10:115;
Rs_vec = Rs_ref * (1 + alpha_Cu * (temp_vec - T_ref));

zeta_min = zeros(size(Rs_vec)); wn_min = zeros(size(Rs_vec));
zeta_max = zeros(size(Rs_vec)); wn_max = zeros(size(Rs_vec));

for i = 1:length(Rs_vec)
    Rs = Rs_vec(i);
    % Caso Carga Mínima
    wn_min(i) = sqrt((Rs*b_eq_min + 1.5*(P_p*lambda_m_prima)^2)/(J_eq_min*L_q));
    zeta_min(i) = (L_q*b_eq_min + Rs*J_eq_min) / (2*J_eq_min*L_q*wn_min(i));
    % Caso Carga Máxima
    wn_max(i) = sqrt((Rs*b_eq_max + 1.5*(P_p*lambda_m_prima)^2)/(J_eq_max*L_q));
    zeta_max(i) = (L_q*b_eq_max + Rs*J_eq_max) / (2*J_eq_max*L_q*wn_max(i));
end

% Graficación
figure('Color', [1 1 1]);
subplot(1,2,1); hold on; grid on;
plot(Rs_vec, zeta_min, 'o-', 'LineWidth', 1.5);
plot(Rs_vec, zeta_max, 's-', 'LineWidth', 1.5);
xlabel('R_s [\Omega]'); ylabel('\zeta [adim]');
legend('Carga mínima', 'Carga máxima');
title('Variación de \zeta con R_s');

subplot(1,2,2); hold on; grid on;
plot(Rs_vec, wn_min, 'o-', 'LineWidth', 1.5);
plot(Rs_vec, wn_max, 's-', 'LineWidth', 1.5);
xlabel('R_s [\Omega]'); ylabel('\omega_n [rad/s]');
legend('Carga mínima', 'Carga máxima');
title('Variación de \omega_n con R_s');