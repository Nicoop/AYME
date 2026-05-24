%% 2. EJECUTAR LA SIMULACIÓN DESDE EL SCRIPT
simOut = sim('Simulacion_Temporal.slx', 'SimulationMode', 'normal');

%% 3. EXTRACCIÓN DE LOS DATOS EXPORTADOS
logs = simOut.logsout;

iqs_LTI    = logs.get('i_qs_LTI').Values;
wm_LTI     = logs.get('w_m_LTI').Values;
thetam_LTI = logs.get('theta_m_LTI').Values;
Ts_LTI     = logs.get('T_s_LTI').Values;

iqs_NL    = logs.get('i_qs_NL').Values;
wm_NL     = logs.get('w_m_NL').Values;
thetam_NL = logs.get('theta_m_NL').Values;
Ts_NL     = logs.get('T_s_NL').Values;

% Extracción de vectores de tiempo y datos 
t_sim           = iqs_LTI.Time;       
iqs_LTI_data    = iqs_LTI.Data;     
wm_LTI_data     = wm_LTI.Data;      
thetam_LTI_data = thetam_LTI.Data; 
Ts_LTI_data     = Ts_LTI.Data; 

iqs_NL_data    = iqs_NL.Data;     
wm_NL_data     = wm_NL.Data;      
thetam_NL_data = thetam_NL.Data; 
Ts_NL_data     = Ts_NL.Data; 

%% 4. Gráficos LTI
figure('Units', 'inches', 'Position', [1, 1, 6, 7]); 

% Subplot 1: Corriente
subplot(4,1,1);
plot(t_sim, iqs_LTI_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo[t]','Interpreter', 'latex', 'FontSize', 10);
title('$i_qs(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 2: Velocidad
subplot(4,1,2);
plot(t_sim, wm_LTI_data, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
grid on;
ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo[t]','Interpreter', 'latex', 'FontSize', 10);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 3: Posición Angular (Corregido nombre de variable)
subplot(4,1,3);
plot(t_sim, thetam_LTI_data, 'LineWidth', 1.5, 'Color', [0.4660 0.6740 0.1880]);
grid on;
ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 10); 
xlabel('Tiempo[t]','Interpreter', 'latex', 'FontSize', 10);
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 4: Torque
subplot(4,1,4);
plot(t_sim, Ts_LTI_data, 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840]);
grid on;
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
ylabel('Torque [N$\cdot$m]', 'Interpreter', 'latex', 'FontSize', 10);
title('$T_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

print('resultado_control_LTI', '-dpng', '-r300');


%% Graficos NL
figure('Units', 'inches', 'Position', [1, 1, 6, 7]); 

% Subplot 1: Corriente
subplot(4,1,1);
plot(t_sim, iqs_NL_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo[t]','Interpreter', 'latex', 'FontSize', 10);
title('$i_qs(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 2: Velocidad
subplot(4,1,2);
plot(t_sim, wm_NL_data, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
grid on;
ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo[t]','Interpreter', 'latex', 'FontSize', 10);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 3: Posición Angular (Corregido nombre de variable)
subplot(4,1,3);
plot(t_sim, thetam_NL_data, 'LineWidth', 1.5, 'Color', [0.4660 0.6740 0.1880]);
grid on;
ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 10); 
xlabel('Tiempo[t]','Interpreter', 'latex', 'FontSize', 10);
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 4: Torque
subplot(4,1,4);
plot(t_sim, Ts_NL_data, 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840]);
grid on;
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
ylabel('Torque [N$\cdot$m]', 'Interpreter', 'latex', 'FontSize', 10);
title('$T_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

print('resultado_control_NL', '-dpng', '-r300');