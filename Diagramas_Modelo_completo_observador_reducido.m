%% =========================================================================
%% SCRIPT DE SIMULACION, GUARDADO DE DATOS Y GRAFICOS
%% Modelo completo con observador reducido
%% =========================================================================

clc; close all;

%% =========================================================================
%% 0. CONFIGURACION GENERAL
%% =========================================================================

nombreModelo = 'Diagramas_Modelo_completo_ML_observador_reducido.slx';
archivoDatos = 'datos_Modelo_completo_ML_observador_reducido.mat';

% Si queres forzar una nueva simulacion aunque exista el .mat, poner true
forzarSimulacion = true;

% Intervalo de zoom
t_zoom_ini = 4.995;
t_zoom_fin = 5.015;

% Colores vivos
color_consigna = [0.0000 0.4470 0.7410];   % azul
color_real     = [0.8500 0.3250 0.0980];   % naranja
color_obs      = [0.4940 0.1840 0.5560];   % violeta
color_error    = [0.6350 0.0780 0.1840];   % rojo oscuro
color_carga    = [0.4660 0.6740 0.1880];   % verde

%% =========================================================================
%% 1. EJECUTAR O CARGAR SIMULACION
%% =========================================================================

if exist(archivoDatos, 'file') && ~forzarSimulacion

    disp('Cargando datos guardados previamente...');
    load(archivoDatos, 'data');

else

    disp('Simulando Modelo Completo con Observador Reducido...');
    simOut = sim(nombreModelo, 'SimulationMode', 'normal');

    logs = simOut.logsout;

    %% ---------------------------------------------------------------------
    %% Extraccion de variables desde logsout
    %% ---------------------------------------------------------------------

    theta_l_consigna_raw = logs.get('theta_l*');
    theta_m_consigna_raw = logs.get('theta_m*');
    w_l_consigna_raw     = logs.get('w_l*');
    w_m_consigna_raw     = logs.get('w_m*');

    theta_m_real_raw = logs.get('theta_m');
    w_m_real_raw     = logs.get('w_m');

    % ATENCION:
    % Cambiar estos nombres si tus señales observadas tienen otro nombre
    theta_m_obs_raw = logs.get('theta_m_obs');
    w_m_obs_raw     = logs.get('w_m_obs');

    %% ---------------------------------------------------------------------
    %% Conversion a estructura simple con tiempo y valores
    %% ---------------------------------------------------------------------

    data.theta_l_consigna = getSignalData(theta_l_consigna_raw);
    data.theta_m_consigna = getSignalData(theta_m_consigna_raw);
    data.w_l_consigna     = getSignalData(w_l_consigna_raw);
    data.w_m_consigna     = getSignalData(w_m_consigna_raw);

    data.theta_m_real = getSignalData(theta_m_real_raw);
    data.w_m_real     = getSignalData(w_m_real_raw);

    data.theta_m_obs = getSignalData(theta_m_obs_raw);
    data.w_m_obs     = getSignalData(w_m_obs_raw);

    %% ---------------------------------------------------------------------
    %% Guardado de datos
    %% ---------------------------------------------------------------------

    save(archivoDatos, 'data');

    disp(['Datos guardados en: ', archivoDatos]);

end

%% =========================================================================
%% 2. CALCULO DE ERRORES
%% =========================================================================

% Para calcular errores, interpolo las señales reales/observadas al tiempo
% de la consigna correspondiente.

t_theta = data.theta_m_consigna.t;
theta_m_consigna = data.theta_m_consigna.y;
theta_m_real_interp = interp1(data.theta_m_real.t, data.theta_m_real.y, ...
                              t_theta, 'linear', 'extrap');
theta_m_obs_interp = interp1(data.theta_m_obs.t, data.theta_m_obs.y, ...
                             data.theta_m_real.t, 'linear', 'extrap');

error_theta_m = theta_m_consigna - theta_m_real_interp;

t_w = data.w_m_consigna.t;
w_m_consigna = data.w_m_consigna.y;
w_m_real_interp = interp1(data.w_m_real.t, data.w_m_real.y, ...
                          t_w, 'linear', 'extrap');
w_m_obs_interp = interp1(data.w_m_obs.t, data.w_m_obs.y, ...
                         data.w_m_real.t, 'linear', 'extrap');

error_w_m = w_m_consigna - w_m_real_interp;

error_theta_obs = data.theta_m_real.y - theta_m_obs_interp;
error_w_obs     = data.w_m_real.y - w_m_obs_interp;

%% =========================================================================
%% 3. FIGURAS
%% =========================================================================

%% Figura 1: theta_l_consigna y theta_m_consigna
figure('Color', 'w', 'Name', 'Figura 1 - Consignas de posicion');

subplot(2,1,1)
plot(data.theta_l_consigna.t, data.theta_l_consigna.y, ...
    'LineWidth', 1.5, 'Color', color_consigna);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\theta_l^* [rad]', 'FontWeight', 'bold');
title('Consigna de posicion de carga \theta_l^*(t)', 'FontWeight', 'bold');
legend('\theta_l^*(t)', 'Location', 'best');

subplot(2,1,2)
plot(data.theta_m_consigna.t, data.theta_m_consigna.y, ...
    'LineWidth', 1.5, 'Color', color_real);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\theta_m^* [rad]', 'FontWeight', 'bold');
title('Consigna de posicion del motor \theta_m^*(t)', 'FontWeight', 'bold');
legend('\theta_m^*(t)', 'Location', 'best');


%% Figura 2: w_l_consigna y w_m_consigna
figure('Color', 'w', 'Name', 'Figura 2 - Consignas de velocidad');

subplot(2,1,1)
plot(data.w_l_consigna.t, data.w_l_consigna.y, ...
    'LineWidth', 1.5, 'Color', color_consigna);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\omega_l^* [rad/s]', 'FontWeight', 'bold');
title('Consigna de velocidad articular \omega_l^*(t)', 'FontWeight', 'bold');
legend('\omega_l^*(t)', 'Location', 'best');

subplot(2,1,2)
plot(data.w_m_consigna.t, data.w_m_consigna.y, ...
    'LineWidth', 1.5, 'Color', color_real);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\omega_m^* [rad/s]', 'FontWeight', 'bold');
title('Consigna de velocidad del eje mecanico \omega_m^*(t)', 'FontWeight', 'bold');
legend('\omega_m^*(t)', 'Location', 'best');


%% Figura 3: theta_m_consigna vs theta_m_real + zoom
figure('Color', 'w', 'Name', 'Figura 3 - Seguimiento de posicion del motor');

subplot(2,1,1)
plot(t_theta, theta_m_consigna, ...
    'LineWidth', 1.6, 'Color', color_consigna); hold on;
plot(data.theta_m_real.t, data.theta_m_real.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_real);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\theta_m [rad]', 'FontWeight', 'bold');
title('Seguimiento de consigna de posicion', 'FontWeight', 'bold');
legend('\theta_m^*(t)', '\theta_m(t)', 'Location', 'best');

subplot(2,1,2)
plot(t_theta, theta_m_consigna, ...
    'LineWidth', 1.6, 'Color', color_consigna); hold on;
plot(data.theta_m_real.t, data.theta_m_real.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_real);
grid on; box on;
xlim([t_zoom_ini t_zoom_fin]);
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\theta_m [rad]', 'FontWeight', 'bold');
title('Zoom del seguimiento de posicion del motor', 'FontWeight', 'bold');
legend('\theta_m^*(t)', '\theta_m(t)', 'Location', 'best');


%% Figura 4: Error theta_m_consigna - theta_m_real
figure('Color', 'w', 'Name', 'Figura 4 - Error de posicion del motor');

plot(t_theta, error_theta_m, ...
    'LineWidth', 1.6, 'Color', color_error);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('e_{\theta_m} [rad]', 'FontWeight', 'bold');
title('Error de seguimiento de posicion', 'FontWeight', 'bold');
legend('$e_{\theta_m}(t) = \theta_m^*(t) - \theta_m(t)$', 'Location', 'best','Interpreter', 'latex');


%% Figura 5: w_m_consigna vs w_m_real + zoom
figure('Color', 'w', 'Name', 'Figura 5 - Seguimiento de velocidad del motor');

subplot(2,1,1)
plot(t_w, w_m_consigna, ...
    'LineWidth', 1.6, 'Color', color_consigna); hold on;
plot(data.w_m_real.t, data.w_m_real.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_real);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\omega_m [rad/s]', 'FontWeight', 'bold');
title('Seguimiento de consigna de velocidad', 'FontWeight', 'bold');
legend('\omega_m^*(t)', '\omega_m(t)', 'Location', 'best');

subplot(2,1,2)
plot(t_w, w_m_consigna, ...
    'LineWidth', 1.6, 'Color', color_consigna); hold on;
plot(data.w_m_real.t, data.w_m_real.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_real);
grid on; box on;
xlim([t_zoom_ini t_zoom_fin]);
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\omega_m [rad/s]', 'FontWeight', 'bold');
title('Zoom del seguimiento de velocidad', 'FontWeight', 'bold');
legend('\omega_m^*(t)', '\omega_m(t)', 'Location', 'best');


%% Figura 6: Error w_m_consigna - w_m_real
figure('Color', 'w', 'Name', 'Figura 6 - Error de velocidad del motor');

plot(t_w, error_w_m, ...
    'LineWidth', 1.6, 'Color', color_error);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('e_{\omega_m} [rad/s]', 'FontWeight', 'bold');
title('Error de seguimiento de velocidad', 'FontWeight', 'bold');
legend('e_{\omega_m}(t) = \omega_m^*(t) - \omega_m(t)', 'Location', 'best');


%% Figura 7: theta_m_real vs theta_m_obs + zoom
figure('Color', 'w', 'Name', 'Figura 7 - Estimacion de posicion del motor');

subplot(2,1,1)
plot(data.theta_m_real.t, data.theta_m_real.y, ...
    'LineWidth', 1.6, 'Color', color_real); hold on;
plot(data.theta_m_obs.t, data.theta_m_obs.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_obs);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\theta_m [rad]', 'FontWeight', 'bold');
title('Estimacion de posicion', 'FontWeight', 'bold');
legend('$\theta_m(t)$', '$\hat{\theta}_m(t)$', ...
       'Location', 'best', 'Interpreter', 'latex');

subplot(2,1,2)
plot(data.theta_m_real.t, data.theta_m_real.y, ...
    'LineWidth', 1.6, 'Color', color_real); hold on;
plot(data.theta_m_obs.t, data.theta_m_obs.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_obs);
grid on; box on;
xlim([t_zoom_ini t_zoom_fin]);
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\theta_m [rad]', 'FontWeight', 'bold');
title('Zoom de la estimacion de posicion', 'FontWeight', 'bold');
legend('$\theta_m(t)$', '$\hat{\theta}_m(t)$',...
       'Location', 'best', 'Interpreter', 'latex');


%% Figura 8: Error theta_m_real - theta_m_obs
figure('Color', 'w', 'Name', 'Figura 8 - Error de observacion de posicion');

plot(data.theta_m_real.t, error_theta_obs, ...
    'LineWidth', 1.6, 'Color', color_error);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('$e_{\hat{\theta}_m}$ [rad]','FontWeight', 'bold', 'Interpreter', 'latex');
title('Error de estimacion de posicion', 'FontWeight', 'bold');
legend('$e_{\hat{\theta}_m}(t) = \theta_m(t) - \hat{\theta}_m(t)$', ...
       'Location', 'best', 'Interpreter', 'latex');

%% Figura 9: w_m_real vs w_m_obs + zoom
figure('Color', 'w', 'Name', 'Figura 9 - Estimacion de velocidad del motor');

subplot(2,1,1)
plot(data.w_m_real.t, data.w_m_real.y, ...
    'LineWidth', 1.6, 'Color', color_real); hold on;
plot(data.w_m_obs.t, data.w_m_obs.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_obs);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\omega_m [rad/s]', 'FontWeight', 'bold');
title('Estimacion de velocidad', 'FontWeight', 'bold');
legend('$\omega_m(t)$', '$\hat{\omega}_m(t)$', 'Location', 'best', ...
       'Location', 'best', 'Interpreter', 'latex');

subplot(2,1,2)
plot(data.w_m_real.t, data.w_m_real.y, ...
    'LineWidth', 1.6, 'Color', color_real); hold on;
plot(data.w_m_obs.t, data.w_m_obs.y, ...
    '--', 'LineWidth', 1.6, 'Color', color_obs);
grid on; box on;
xlim([t_zoom_ini t_zoom_fin]);
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('\omega_m [rad/s]', 'FontWeight', 'bold');
title('Zoom de la estimación de velocidad', 'FontWeight', 'bold');
legend('$\omega_m(t)$', '$\hat{\omega}_m(t)$', ...
       'Location', 'best', 'Interpreter', 'latex');


%% Figura 10: Error w_m_real - w_m_obs
figure('Color', 'w', 'Name', 'Figura 10 - Error de observacion de velocidad');

plot(data.w_m_real.t, error_w_obs, ...
    'LineWidth', 1.6, 'Color', color_error);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold');
ylabel('$e_{\hat{\omega}_m}$ [rad/s]', ...
       'FontWeight', 'bold', 'Interpreter', 'latex');
title('Error de estimacion de velocidad del motor', 'FontWeight', 'bold');
legend('$e_{\hat{\omega}_m}(t) = \omega_m(t) - \hat{\omega}_m(t)$', ...
       'Location', 'best', 'Interpreter', 'latex');


%% =========================================================================
%% 4. FUNCIONES AUXILIARES
%% =========================================================================

function sig = getSignalData(obj)
    % Convierte señales de logsout a una estructura simple:
    % sig.t = vector de tiempo
    % sig.y = vector de valores

    % Si viene como Dataset, tomar el primer elemento
    if isa(obj, 'Simulink.SimulationData.Dataset')
        obj = obj.getElement(1);
    end

    % Si viene como Signal, tomar Values
    if isa(obj, 'Simulink.SimulationData.Signal')
        val = obj.Values;
    else
        val = obj;
    end

    % Caso timeseries
    if isa(val, 'timeseries')
        sig.t = val.Time(:);
        sig.y = squeeze(val.Data);
        sig.y = sig.y(:);

    % Caso timetable
    elseif istimetable(val)
        sig.t = seconds(val.Time - val.Time(1));
        sig.y = val{:,1};
        sig.y = sig.y(:);

    % Caso estructura con Time y Data
    elseif isstruct(val) && isfield(val, 'Time') && isfield(val, 'Data')
        sig.t = val.Time(:);
        sig.y = squeeze(val.Data);
        sig.y = sig.y(:);

    else
        error('No se pudo interpretar el formato de una señal exportada.');
    end
end
