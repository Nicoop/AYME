%% =========================================================================
%% SCRIPT DE SIMULACION, GUARDADO DE DATOS Y GRAFICOS
%% Corrientes, tensiones, torque y temperatura
%% Modelo completo con observador reducido
%% =========================================================================

clc; close all;

%% =========================================================================
%% 0. CONFIGURACION GENERAL
%% =========================================================================

nombreModelo = 'Diagramas_Modelo_completo_ML_observador_reducido.slx';
archivoDatos = 'corrientes_tensiones_Modelo_completo_ML_observador_reducido.mat';

% Si queres forzar una nueva simulacion aunque exista el .mat, poner true
forzarSimulacion = true;

% Colores vivos y legibles
color_1 = [0.0000 0.4470 0.7410];   % azul
color_2 = [0.8500 0.3250 0.0980];   % naranja
color_3 = [0.4660 0.6740 0.1880];   % verde
color_4 = [0.4940 0.1840 0.5560];   % violeta
color_5 = [0.6350 0.0780 0.1840];   % rojo oscuro
color_6 = [0.3010 0.7450 0.9330];   % celeste

fontSizeEjes = 11;
fontSizeTitulo = 12;
lineWidth = 1.5;

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

    % Corrientes en coordenadas virtuales
    i_qs_raw = logs.get('i_qs');
    i_ds_raw = logs.get('i_ds');
    i_0s_raw = logs.get('i_0s');

    % Corrientes en coordenadas reales
    i_as_raw = logs.get('i_as');
    i_bs_raw = logs.get('i_bs');
    i_cs_raw = logs.get('i_cs');

    % Tensiones en coordenadas virtuales
    v_qs_raw = logs.get('v_qs');
    v_ds_raw = logs.get('v_ds');
    v_0s_raw = logs.get('v_0s');

    % Tensiones en coordenadas reales
    v_as_raw = logs.get('v_as');
    v_bs_raw = logs.get('v_bs');
    v_cs_raw = logs.get('v_cs');

    % Torque electromagnetico y temperatura
    T_m_raw = logs.get('T_m');
    T_s_raw = logs.get('T_s');

    %% ---------------------------------------------------------------------
    %% Conversion a estructura simple con tiempo y valores
    %% ---------------------------------------------------------------------

    % Corrientes virtuales
    data.i_qs = getSignalData(i_qs_raw);
    data.i_ds = getSignalData(i_ds_raw);
    data.i_0s = getSignalData(i_0s_raw);

    % Corrientes reales
    data.i_as = getSignalData(i_as_raw);
    data.i_bs = getSignalData(i_bs_raw);
    data.i_cs = getSignalData(i_cs_raw);

    % Tensiones virtuales
    data.v_qs = getSignalData(v_qs_raw);
    data.v_ds = getSignalData(v_ds_raw);
    data.v_0s = getSignalData(v_0s_raw);

    % Tensiones reales
    data.v_as = getSignalData(v_as_raw);
    data.v_bs = getSignalData(v_bs_raw);
    data.v_cs = getSignalData(v_cs_raw);

    % Torque y temperatura
    data.T_m = getSignalData(T_m_raw);
    data.T_s = getSignalData(T_s_raw);

    %% ---------------------------------------------------------------------
    %% Guardado de datos
    %% ---------------------------------------------------------------------

    save(archivoDatos, 'data');

    disp(['Datos guardados en: ', archivoDatos]);

end

%% =========================================================================
%% 2. FIGURAS
%% =========================================================================

%% Figura 1: Corrientes en coordenadas virtuales
figure('Color', 'w', 'Name', 'Figura 1 - Corrientes en coordenadas virtuales');

subplot(3,1,1)
plot(data.i_qs.t, data.i_qs.y, 'LineWidth', lineWidth, 'Color', color_1);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('i_{qs} [A]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Corriente en eje q: i_{qs}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('i_{qs}(t)', 'Location', 'best');

subplot(3,1,2)
plot(data.i_ds.t, data.i_ds.y, 'LineWidth', lineWidth, 'Color', color_2);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('i_{ds} [A]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Corriente en eje d: i_{ds}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('i_{ds}(t)', 'Location', 'best');

subplot(3,1,3)
plot(data.i_0s.t, data.i_0s.y, 'LineWidth', lineWidth, 'Color', color_3);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('i_{0s} [A]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Corriente de secuencia cero: i_{0s}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('i_{0s}(t)', 'Location', 'best');


%% Figura 2: Corrientes en coordenadas reales
figure('Color', 'w', 'Name', 'Figura 2 - Corrientes en coordenadas reales');

subplot(3,1,1)
plot(data.i_as.t, data.i_as.y, 'LineWidth', lineWidth, 'Color', color_1);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('i_{as} [A]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Corriente de fase a: i_{as}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('i_{as}(t)', 'Location', 'best');

subplot(3,1,2)
plot(data.i_bs.t, data.i_bs.y, 'LineWidth', lineWidth, 'Color', color_2);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('i_{bs} [A]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Corriente de fase b: i_{bs}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('i_{bs}(t)', 'Location', 'best');

subplot(3,1,3)
plot(data.i_cs.t, data.i_cs.y, 'LineWidth', lineWidth, 'Color', color_3);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('i_{cs} [A]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Corriente de secuencia cero: i_{cs}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('i_{cs}(t)', 'Location', 'best');


%% Figura 3: Tensiones en coordenadas virtuales
figure('Color', 'w', 'Name', 'Figura 3 - Tensiones en coordenadas virtuales');

subplot(3,1,1)
plot(data.v_qs.t, data.v_qs.y, 'LineWidth', lineWidth, 'Color', color_4);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('v_{qs} [V]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Tension en eje q: v_{qs}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('v_{qs}(t)', 'Location', 'best');

subplot(3,1,2)
plot(data.v_ds.t, data.v_ds.y, 'LineWidth', lineWidth, 'Color', color_5);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('v_{ds} [V]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Tension en eje d: v_{ds}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('v_{ds}(t)', 'Location', 'best');

subplot(3,1,3)
plot(data.v_0s.t, data.v_0s.y, 'LineWidth', lineWidth, 'Color', color_6);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('v_{0s} [V]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Tension de secuencia cero: v_{0s}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('v_{0s}(t)', 'Location', 'best');


%% Figura 4: Tensiones en coordenadas reales
figure('Color', 'w', 'Name', 'Figura 4 - Tensiones en coordenadas reales');

subplot(3,1,1)
plot(data.v_as.t, data.v_as.y, 'LineWidth', lineWidth, 'Color', color_4);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('v_{as} [V]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Tension de fase a: v_{as}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('v_{as}(t)', 'Location', 'best');

subplot(3,1,2)
plot(data.v_bs.t, data.v_bs.y, 'LineWidth', lineWidth, 'Color', color_5);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('v_{bs} [V]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Tension de fase b: v_{bs}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('v_{bs}(t)', 'Location', 'best');

subplot(3,1,3)
plot(data.v_cs.t, data.v_cs.y, 'LineWidth', lineWidth, 'Color', color_6);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('v_{cs} [V]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Tension de secuencia cero: v_{cs}(t)', 'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('v_{cs}(t)', 'Location', 'best');


%% Figura 5: Torque electromagnetico T_m
figure('Color', 'w', 'Name', 'Figura 5 - Torque electromagnetico');

plot(data.T_m.t, data.T_m.y, 'LineWidth', 1.7, 'Color', color_5);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('T_m [N.m]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Evolucion del torque electromagnetico T_m(t)', ...
      'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('T_m(t)', 'Location', 'best');


%% Figura 6: Temperatura T_s
figure('Color', 'w', 'Name', 'Figura 6 - Temperatura');

plot(data.T_s.t, data.T_s.y, 'LineWidth', 1.7, 'Color', color_3);
grid on; box on;
xlabel('Tiempo [s]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
ylabel('T_s [°C]', 'FontWeight', 'bold', 'FontSize', fontSizeEjes);
title('Evolucion de la temperatura T_s(t)', ...
      'FontWeight', 'bold', 'FontSize', fontSizeTitulo);
legend('T_s(t)', 'Location', 'best');


%% =========================================================================
%% 3. FUNCIONES AUXILIARES
%% =========================================================================

function sig = getSignalData(obj)
    % Convierte señales de logsout a una estructura simple:
    % sig.t = vector de tiempo
    % sig.y = vector de valores

    % Verificacion por si no existe la señal en logsout
    if isempty(obj)
        error('Una de las señales no fue encontrada en logsout. Revisar el nombre exacto de la señal exportada.');
    end

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