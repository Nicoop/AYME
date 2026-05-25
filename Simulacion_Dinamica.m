%% EJECUTAR LA SIMULACIÓN DESDE EL SCRIPT
simOut = sim('Simulacion_Temporal.slx', 'SimulationMode', 'normal');

%% EXTRACCIÓN DE LOS DATOS EXPORTADOS
logs = simOut.logsout;

v_qs_ref   = logs.get('v_ref');
T_carga    = logs.get('T_carga');
iqs_LTI    = logs.get('i_qs_LTI');
wm_LTI     = logs.get('w_m_LTI');
thetam_LTI = logs.get('theta_m_LTI');
Ts_LTI     = logs.get('T_s_LTI');
Tm_LTI     = logs.get('T_m_LTI');
iqs_NL     = logs.get('i_qs_NL');
wm_NL      = logs.get('w_m_NL');
thetam_NL  = logs.get('theta_m_NL');
Ts_NL      = logs.get('T_s_NL');

% Extracción de vectores de tiempo y datos usando .Values
t_sim           = iqs_LTI.Values.Time;
v_ref_data      = v_qs_ref.Values.Data;
T_carga_data    = T_carga.Values.Data;
iqs_LTI_data    = iqs_LTI.Values.Data;     
wm_LTI_data     = wm_LTI.Values.Data;      
thetam_LTI_data = thetam_LTI.Values.Data; 
Ts_LTI_data     = Ts_LTI.Values.Data; 
Tm_LTI_data     = Tm_LTI.Values.Data; 
iqs_NL_data     = iqs_NL.Values.Data;     
wm_NL_data      = wm_NL.Values.Data;      
thetam_NL_data  = thetam_NL.Values.Data; 
Ts_NL_data      = Ts_NL.Values.Data; 

%% Graficos referencias
figure('Units', 'inches', 'Position', [1, 1, 6, 4]);

% Subplot 1: Tension de referencia
subplot(2,1,1);
plot(t_sim, v_ref_data, 'LineWidth', 1.5, 'Color', [0.9 0.4470 0.90]);
grid on;
hold on;
% --- ANOTACIONES PARA LA TENSION DE REFERENCIA ---
% Punto 1: Salto positivo en t = 0.1 s
plot(0.1, 19.569, 'o', 'MarkerSize', 6, 'LineWidth', 1, 'Color', [0.9 0.4470 0.90]);
text(0.11, 17, '19,569 V', 'FontSize', 10, 'FontWeight', 'normal'); 
% Punto 2: Salto negativo en t = 0.7 s
plot(1.1, -19.569, 'o', 'MarkerSize', 6, 'LineWidth', 1, 'Color', [0.9 0.4470 0.90]);
text(1.12, -17, '-19,569', 'FontSize', 10, 'FontWeight', 'normal');
hold off;

ylabel('Tension [V]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$v_{qs}^*(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');


% Subplot 2: Pulso de Torque de Carga (Con marcadores y etiquetas)
subplot(2,1,2);
plot(t_sim, T_carga_data, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
grid on;
hold on; 

% --- ANOTACIONES PARA EL TORQUE DE CARGA ---
% Punto 1: Salto positivo en t = 0.3 s
plot(0.3, 6.28, 'o', 'MarkerSize', 6, 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
text(0.31, 5.0, '6,28 Nm', 'FontSize', 10, 'FontWeight', 'normal'); 

% Punto 2: Salto negativo en t = 0.5 s
plot(0.5, -6.28, 'o', 'MarkerSize', 6, 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
text(0.51, -5.0, '-6,28 Nm', 'FontSize', 10, 'FontWeight', 'normal');
hold off;
ylabel('Torque [N$\cdot$m]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$T_{l}(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

print('Pulso_Tension_y_Pulso_Torque', '-dpng', '-r300');

%% Gráficos LTI
figure('Units', 'inches', 'Position', [1, 1, 6, 8]); 

% Subplot 1: Corriente
subplot(5,1,1);
plot(t_sim, iqs_LTI_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 2: Velocidad
subplot(5,1,2);
plot(t_sim, wm_LTI_data, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
grid on;
ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 3: Posición Angular
subplot(5,1,3);
plot(t_sim, thetam_LTI_data, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
grid on;
ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 10); 
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 4: Torque
subplot(5,1,4);
plot(t_sim, Tm_LTI_data, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
grid on;
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
ylabel('Torque [N$\cdot$m]', 'Interpreter', 'latex', 'FontSize', 10);
title('$T_m(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight','bold');

% Subplot 5: Temperatura
subplot(5,1,5);
plot(t_sim, Ts_LTI_data, 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840]);
grid on;
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
ylabel('Temperatura [$^{\circ}$C]', 'Interpreter', 'latex', 'FontSize', 10);
title('$T_s(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');

% Guardar gráfico completo LTI despues de dibujar todos los subplots
%print('resultado_control_LTI', '-dpng', '-r300');

%% Graficos NL (Optimizado y Corregido)
figure('Units', 'inches', 'Position', [1, 1, 6, 9]); 

% Usamos un contenedor inteligente para manejar el espaciado automáticamente
t_nl = tiledlayout(4, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

% Subplot 1: Corriente
nexttile;
plot(t_sim, iqs_NL_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 9);
title('$i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');
set(gca, 'XTickLabel', []); % Oculta los números del eje X para evitar colisiones

% Subplot 2: Velocidad
nexttile;
plot(t_sim, wm_NL_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 9);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');
set(gca, 'XTickLabel', []);

% Subplot 3: Posición Angular
nexttile;
plot(t_sim, thetam_NL_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 9); 
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');
set(gca, 'XTickLabel', []);

% Subplot 4: Temperatura (Solo este lleva la etiqueta de tiempo)
nexttile;
plot(t_sim, Ts_NL_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10); % Eje X principal al final
ylabel('Temperatura [$^{\circ}$C]', 'Interpreter', 'latex', 'FontSize', 9);
title('$T_s(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');

% Título global del bloque NL (Opcional)
title(t_nl, 'Respuesta Temporal del Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 13);

% Guardar gráfico completo NL con alta definición sin cortes
print('resultado_control_NL', '-dpng', '-r300');

%% GRÁFICOS COMPARATIVOS (LTI vs NL)
figure('Units', 'inches', 'Position', [1, 1, 6, 9]); 

% Contenedor para alinear los 4 gráficos comparativos
t_comp = tiledlayout(4, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

% Definición de Estilos de Línea y Colores (Gamas claras para LTI y oscuras para NL)
% LTI: Línea sólida clara y un poco más gruesa
style_LTI = {'- ', 'LineWidth', 2.0, 'Color', [0.65 0.80 0.95]}; % Azul pastel claro
% NL: Línea discontinua (dashed) oscura y fina que resalta arriba
style_NL  = {'--', 'LineWidth', 1.5, 'Color', [0.15 0.25 0.45]}; % Azul marino oscuro

% --- Subplot 1: Comparación de Corriente ---
nexttile;
plot(t_sim, iqs_LTI_data, style_LTI{:}); hold on;
plot(t_sim, iqs_NL_data,  style_NL{:});  hold off;
grid on;
ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 9);
title('$i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');
legend({'Modelo LTI', 'Modelo NL'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

% --- Subplot 2: Comparación de Velocidad ---
nexttile;
plot(t_sim, wm_LTI_data, style_LTI{:}); hold on;
plot(t_sim, wm_NL_data,  style_NL{:});  hold off;
grid on;
ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 9);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');
set(gca, 'XTickLabel', []);

% --- Subplot 3: Comparación de Posición Angular ---
nexttile;
plot(t_sim, thetam_LTI_data, style_LTI{:}); hold on;
plot(t_sim, thetam_NL_data,  style_NL{:});  hold off;
grid on;
ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 9); 
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');
set(gca, 'XTickLabel', []);

% --- Subplot 4: Comparación de Temperatura ---
nexttile;
plot(t_sim, Ts_LTI_data, style_LTI{:}); hold on;
plot(t_sim, Ts_NL_data,  style_NL{:});  hold off;
grid on;
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
ylabel('Temperatura [$^{\circ}$C]', 'Interpreter', 'latex', 'FontSize', 9);
title('$T_s(t)$', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight','bold');

% Título global de la comparación
title(t_comp, 'Comparativa de Respuesta Temporal: Modelo LTI vs. NL', 'Interpreter', 'latex', 'FontSize', 13);

% Guardar el gráfico comparativo en alta resolución
print('resultado_comparativa_LTI_NL', '-dpng', '-r300');