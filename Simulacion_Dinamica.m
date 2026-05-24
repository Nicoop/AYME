%% 2. EJECUTAR LA SIMULACIÓN DESDE EL SCRIPT
% Reemplaza 'tu_modelo' por el nombre exacto de tu archivo .slx
simOut = sim('Simulacion_Temporal.slx', 'SimulationMode', 'normal');

%% 3. EXTRACCIÓN DE LOS DATOS EXPORTADOS
% Extraemos el contenedor de datos y luego cada señal por su nombre en Simulink
logs = simOut.logsout;

% Suponiendo que tus cables en Simulink se llaman 'i_qs' y 'w_m'
sig_iqs = logs.get('i_qs').Values;
sig_wm  = logs.get('w_m').Values;

% MATLAB los guarda como objetos 'Timeseries'. Extraemos tiempo y datos:
t_sim  = sig_iqs.Time;       % Vector de tiempo común
iqs_data = sig_iqs.Data;     % Vector de datos de corriente
wm_data  = sig_wm.Data;      % Vector de datos de velocidad

%% 4. Gráficos Profesionales para el Informe
figure('Units', 'inches', 'Position', [1, 1, 6, 4]); % Tamaño fijo para que no se deforme en el PDF

subplot(2,1,1);
plot(t_sim, iqs_data, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid on;
ylabel('$i_{qs}^r$ [A]', 'Interpreter', 'latex', 'FontSize', 11);
title('Respuesta Dinámica de la Ley de Control', 'Interpreter', 'latex', 'FontSize', 12);

subplot(2,1,2);
plot(t_sim, wm_data, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
grid on;
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 11);
ylabel('$\omega_m$ [rad/s]', 'Interpreter', 'latex', 'FontSize', 11);

% Guardar la imagen directamente en alta definición
print('resultado_control_nolineal', '-dpng', '-r300');