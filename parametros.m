%% Parámetros del brazo robot

%momento de inercia
J_l = 0.0833; %[kg.m^2] % Jl = 0.0833 + [0 ... 0.375]

%coef friccion viscosa articulacion
b_l = 0.1; % [Nm/(rad/s)] % b_l = (0.1 +/- 0.03)

%coeficiente en torque de carga
k_l = 0.25; % K_l = 0.25 + [0 ... 0.75]

%torque de perturbacion por contacto 
% T_l_d = 0 +/- 5.0 Nm

%% Tren de transmision

r = 120;

%% Parametros del motor

%Momento de Inercia
J_m = 14.0 *10^(-6);

%coef friccion viscosa
b_m = 15.0 *10^(-6);

%pares de polos
P_p = 3;

%flujo magnetico concatenado
lambda_m = 0.016; 

%Inductancia de eje directo
L_d = 6.6 * 10^(-3);

%Inductancia de eje en cuadratura
L_q = 5.8 * 10^(-3);

%Inductancia de dispersion
L_Is = 0.8 *10^(-3);
L_ls = L_Is;

%Resistencia estator por fase (REF)
R_sref = 1.02; %[Ohm]
R_s = R_sref;

%Temperatura de referencia
T_sref = 20; %[*C]

%Coef. aumento Rs con Ts
alpha_cu = 3.9 * 10^(-3);  %[1/*C]

%Capacitancia termica estator
C_ts = 0.818; %[W/*C/s]

%Resistencia termica estator-ambiente
R_tsamb = 146.7; %[C/W]

%% Parametros mecanicos combinados

J_eq = J_m + (1/r^2)*J_l;

b_eq = b_m + (1/r^2)*b_l;

%% Parametros para ubicacion de polos

R_q=29;
R_d=33;
R_0=4;

b_a=0.0396;
k_sa=31.656;
k_sia=10130;
