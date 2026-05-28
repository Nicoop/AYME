%% EJECUTAR LA SIMULACIÓN DESDE EL SCRIPT
simOut = sim('Simulacion_Temporal.slx', 'SimulationMode', 'normal');

%% EXTRACCIÓN DE LOS DATOS EXPORTADOS (A prueba de errores de tipo de objeto)
logs = simOut.logsout;

% --- Lista de variables LTI ---
iqs_LTI_raw = logs.get('i_qs_LTI'); ids_LTI_raw = logs.get('i_ds_LTI'); i0s_LTI_raw = logs.get('i_0s_LTI');
ias_LTI_raw = logs.get('i_as_LTI'); ibs_LTI_raw = logs.get('i_bs_LTI'); ics_LTI_raw = logs.get('i_cs_LTI');

% --- Lista de variables NL ---
iqs_NL_raw  = logs.get('i_qs_NL');  ids_NL_raw  = logs.get('i_ds_NL');  i0s_NL_raw  = logs.get('i_0s_NL');
ias_NL_raw  = logs.get('i_as_NL');  ibs_NL_raw  = logs.get('i_bs_NL');  ics_NL_raw  = logs.get('i_cs_NL');

% --- Función anónima para desempaquetar dinámicamente según el objeto ---
% Si es un Dataset, extrae su primer elemento. Si no, lo deja pasar directo.
unpack = @(obj) ifthen(isa(obj, 'Simulink.SimulationData.Dataset'), @() obj.getElement(1), @() obj);

iqs_LTI = unpack(iqs_LTI_raw); ids_LTI = unpack(ids_LTI_raw); i0s_LTI = unpack(i0s_LTI_raw);
ias_LTI = unpack(ias_LTI_raw); ibs_LTI = unpack(ibs_LTI_raw); ics_LTI = unpack(ics_LTI_raw);

iqs_NL  = unpack(iqs_NL_raw);  ids_NL  = unpack(ids_NL_raw);  i0s_NL  = unpack(i0s_NL_raw);
ias_NL  = unpack(ias_NL_raw);  ibs_NL  = unpack(ibs_NL_raw);  ics_NL  = unpack(ics_NL_raw);

%% PALETA DE COLORES REQUERIDA
% Grupo dq0: Azul, Violeta, Celeste
c_d = [0.0000 0.4470 0.7410]; % Azul
c_0 = [0.4940 0.1840 0.5560]; % Violeta
c_q = [0.10 0.7450 0.20]; % Verde

% Grupo abc: Rojo, Naranja, Fucsia
c_a = [0.8500 0.3250 0.0980]; % Rojo
c_b = [0.9290 0.6940 0.1250]; % Naranja
c_c = [0.8500 0.0000 0.5500]; % Fucsia

%% =========================================================================
%% FIGURA 1: CORRIENTES qd0 - MODELO LINEAL (LTI)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_qd0_lti = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(iqs_LTI.Values.Time, iqs_LTI.Values.Data, 'LineWidth', 1, 'Color', c_q);
grid on; ylabel('$i_{qs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Eje Cuadratura: $i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{qs}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(ids_LTI.Values.Time, ids_LTI.Values.Data, 'LineWidth', 1, 'Color', c_d);
grid on; ylabel('$i_{ds}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Eje Directo: $i_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{ds}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(i0s_LTI.Values.Time, i0s_LTI.Values.Data, 'LineWidth', 1, 'Color', c_0);
grid on; ylabel('$i_{0s}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente Homopolar: $i_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{0s}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);

title(t_qd0_lti, 'Respuestas Temporales $qd0$ - Modelo LTI', 'Interpreter', 'latex', 'FontSize', 13);
print('Figura1_qd0_LTI', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 2: CORRIENTES abc - MODELO LINEAL (LTI)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_abc_lti = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(ias_LTI.Values.Time, ias_LTI.Values.Data, 'LineWidth', 1, 'Color', c_a);
grid on; ylabel('$i_{as}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase A: $i_{as}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{as}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(ibs_LTI.Values.Time, ibs_LTI.Values.Data, 'LineWidth', 1, 'Color', c_b);
grid on; ylabel('$i_{bs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase B: $i_{bs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{bs}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(ics_LTI.Values.Time, ics_LTI.Values.Data, 'LineWidth', 1, 'Color', c_c);
grid on; ylabel('$i_{cs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase C: $i_{cs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{cs}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);

title(t_abc_lti, 'Respuestas Temporales $abc$ - Modelo LTI', 'Interpreter', 'latex', 'FontSize', 13);
print('Figura2_abc_LTI', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 3: CORRIENTES qd0 - MODELO NO LINEAL (NL)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_qd0_nl = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(iqs_NL.Values.Time, iqs_NL.Values.Data, 'LineWidth', 1, 'Color', c_q);
grid on; ylabel('$i_{qs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Eje Cuadratura: $i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{qs}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(ids_NL.Values.Time, ids_NL.Values.Data, 'LineWidth', 1, 'Color', c_d);
grid on; ylabel('$i_{ds}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Eje Directo: $i_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{ds}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(i0s_NL.Values.Time, i0s_NL.Values.Data, 'LineWidth', 1, 'Color', c_0);
grid on; ylabel('$i_{0s}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente Homopolar: $i_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{0s}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);

title(t_qd0_nl, 'Respuestas Temporales $qd0$ - Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 13);
print('Figura3_qd0_NL', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 4: CORRIENTES abc - MODELO NO LINEAL (NL)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_abc_nl = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(ias_NL.Values.Time, ias_NL.Values.Data, 'LineWidth', 1, 'Color', c_a);
grid on; ylabel('$i_{as}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase A: $i_{as}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{as}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(ibs_NL.Values.Time, ibs_NL.Values.Data, 'LineWidth', 1, 'Color', c_b);
grid on; ylabel('$i_{bs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase B: $i_{bs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{bs}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
set(gca, 'XTickLabel', []);

nexttile;
plot(ics_NL.Values.Time, ics_NL.Values.Data, 'LineWidth', 1, 'Color', c_c);
grid on; ylabel('$i_{cs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase C: $i_{cs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
legend({'$i_{cs}$'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);

title(t_abc_nl, 'Respuestas Temporales $abc$ - Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 13);
print('Figura4_abc_NL', '-dpng', '-r300');

% Auxiliar interna para simplificar el desempaquetado condicional
function res = ifthen(cond, trueFunc, falseFunc)
    if cond, res = trueFunc(); else, res = falseFunc(); end
end