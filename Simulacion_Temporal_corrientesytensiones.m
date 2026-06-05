%% =========================================================================
%% 1. EJECUTAR LAS SIMULACIONES DESDE EL SCRIPT
%% =========================================================================
disp('Simulando Modelo No Lineal (NL)...');
simOut_NL = sim('pruebas_modelo_definitivo.slx', 'SimulationMode', 'normal');

disp('Simulando Modelo Linealizado (LTI)...');
simOut_LTI = sim('Simulacion_Temporal_LTI.slx', 'SimulationMode', 'normal');

%% =========================================================================
%% 2. EXTRACCIÓN DE LOS DATOS EXPORTADOS (Separados por modelo)
%% =========================================================================
logs_NL  = simOut_NL.logsout;
logs_LTI = simOut_LTI.logsout;

% --- Lista de variables LTI ---
iqs_LTI_raw = logs_LTI.get('i_qs_LTI'); ids_LTI_raw = logs_LTI.get('i_ds_LTI'); i0s_LTI_raw = logs_LTI.get('i_0s_LTI');
ias_LTI_raw = logs_LTI.get('i_as_LTI'); ibs_LTI_raw = logs_LTI.get('i_bs_LTI'); ics_LTI_raw = logs_LTI.get('i_cs_LTI');
vqs_LTI_raw = logs_LTI.get('v_ref'); vds_LTI_raw = logs_LTI.get('v_ds_LTI'); v0s_LTI_raw = logs_LTI.get('v_0s_LTI');
vas_LTI_raw = logs_LTI.get('v_as_LTI'); vbs_LTI_raw = logs_LTI.get('v_bs_LTI'); vcs_LTI_raw = logs_LTI.get('v_cs_LTI');

% --- Lista de variables NL ---
iqs_NL_raw  = logs_NL.get('i_qs_NL');  ids_NL_raw  = logs_NL.get('i_ds_NL');  i0s_NL_raw  = logs_NL.get('i_0s_NL');
ias_NL_raw  = logs_NL.get('i_as_NL');  ibs_NL_raw  = logs_NL.get('i_bs_NL');  ics_NL_raw  = logs_NL.get('i_cs_NL');
vqs_NL_raw  = logs_NL.get('v_ref');  vds_NL_raw  = logs_NL.get('v_ds_NL');  v0s_NL_raw  = logs_NL.get('v_0s_NL');
vas_NL_raw  = logs_NL.get('v_as_NL');  vbs_NL_raw  = logs_NL.get('v_bs_NL');  vcs_NL_raw  = logs_NL.get('v_cs_NL');

% --- Función anónima para desempaquetar dinámicamente según el objeto ---
unpack = @(obj) ifthen(isa(obj, 'Simulink.SimulationData.Dataset'), @() obj.getElement(1), @() obj);

iqs_LTI = unpack(iqs_LTI_raw); ids_LTI = unpack(ids_LTI_raw); i0s_LTI = unpack(i0s_LTI_raw);
ias_LTI = unpack(ias_LTI_raw); ibs_LTI = unpack(ibs_LTI_raw); ics_LTI = unpack(ics_LTI_raw);
vqs_LTI = unpack(vqs_LTI_raw); vds_LTI = unpack(vds_LTI_raw); v0s_LTI = unpack(v0s_LTI_raw);
vas_LTI = unpack(vas_LTI_raw); vbs_LTI = unpack(vbs_LTI_raw); vcs_LTI = unpack(vcs_LTI_raw);

iqs_NL  = unpack(iqs_NL_raw);  ids_NL  = unpack(ids_NL_raw);  i0s_NL  = unpack(i0s_NL_raw);
ias_NL  = unpack(ias_NL_raw);  ibs_NL  = unpack(ibs_NL_raw);  ics_NL  = unpack(ics_NL_raw);
vqs_NL  = unpack(vqs_NL_raw);  vds_NL  = unpack(vds_NL_raw);  v0s_NL  = unpack(v0s_NL_raw);
vas_NL  = unpack(vas_NL_raw);  vbs_NL  = unpack(vbs_NL_raw);  vcs_NL  = unpack(vcs_NL_raw);

%% =========================================================================
%% 3. PALETA DE COLORES REQUERIDA
%% =========================================================================
% Grupo dq0: Azul, Violeta, Verde
c_d = [0.0000 0.4470 0.7410]; % Azul
c_0 = [0.4940 0.1840 0.5560]; % Violeta
c_q = [0.1000 0.7450 0.2000]; % Verde

% Grupo abc: Rojo, Naranja, Fucsia
c_a = [0.8500 0.3250 0.0980]; % Rojo
c_b = [0.9290 0.6940 0.1250]; % Naranja
c_c = [0.8500 0.0000 0.5500]; % Fucsia

% Estilos de trazo para comparativas ejecutivas
style_LTI = {'-', 'LineWidth', 1.3, 'Color', [0.65 0.80 0.95]}; % Claro
style_NL  = {'--', 'LineWidth', 1.0, 'Color', [0.15 0.25 0.45]}; % Oscuro

%% =========================================================================
%% FIGURA 1: CORRIENTES qd0 - MODELO LINEAL (LTI)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_qd0_lti = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(iqs_LTI.Values.Time, iqs_LTI.Values.Data, 'LineWidth', 1, 'Color', c_q);
grid on; ylabel('$i_{qs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Eje Cuadratura: $i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(ids_LTI.Values.Time, ids_LTI.Values.Data, 'LineWidth', 1, 'Color', c_d);
grid on; ylabel('$i_{ds}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Eje Directo: $i_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(i0s_LTI.Values.Time, i0s_LTI.Values.Data, 'LineWidth', 1, 'Color', c_0);
grid on; ylabel('$i_{0s}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente Homopolar: $i_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
title(t_qd0_lti, 'Respuestas Temporales de Corriente $qd0$ - Modelo LTI', 'Interpreter', 'latex', 'FontSize', 12);
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
set(gca, 'XTickLabel', []);
nexttile;
plot(ibs_LTI.Values.Time, ibs_LTI.Values.Data, 'LineWidth', 1, 'Color', c_b);
grid on; ylabel('$i_{bs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase B: $i_{bs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(ics_LTI.Values.Time, ics_LTI.Values.Data, 'LineWidth', 1, 'Color', c_c);
grid on; ylabel('$i_{cs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase C: $i_{cs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
title(t_abc_lti, 'Respuestas Temporales de Corriente $abc$ - Modelo LTI', 'Interpreter', 'latex', 'FontSize', 12);
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
set(gca, 'XTickLabel', []);
nexttile;
plot(ids_NL.Values.Time, ids_NL.Values.Data, 'LineWidth', 1, 'Color', c_d);
grid on; ylabel('$i_{ds}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Eje Directo: $i_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(i0s_NL.Values.Time, i0s_NL.Values.Data, 'LineWidth', 1, 'Color', c_0);
grid on; ylabel('$i_{0s}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente Homopolar: $i_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
title(t_qd0_nl, 'Respuestas Temporales de Corriente $qd0$ - Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 12);
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
set(gca, 'XTickLabel', []);
nexttile;
plot(ibs_NL.Values.Time, ibs_NL.Values.Data, 'LineWidth', 1, 'Color', c_b);
grid on; ylabel('$i_{bs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase B: $i_{bs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(ics_NL.Values.Time, ics_NL.Values.Data, 'LineWidth', 1, 'Color', c_c);
grid on; ylabel('$i_{cs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Corriente de Fase C: $i_{cs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
title(t_abc_nl, 'Respuestas Temporales de Corriente $abc$ - Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 12);
print('Figura4_abc_NL', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 5: TENSIONES qd0 - MODELO LINEAL (LTI) - CORREGIDA
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_vqd0_lti = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(vqs_LTI.Values.Time, vqs_LTI.Values.Data, 'LineWidth', 1, 'Color', c_q);
grid on; ylabel('$v_{qs}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Eje Cuadratura: $v_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(vds_LTI.Values.Time, vds_LTI.Values.Data, 'LineWidth', 1, 'Color', c_d);
grid on; ylabel('$v_{ds}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Eje Directo: $v_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(v0s_LTI.Values.Time, v0s_LTI.Values.Data, 'LineWidth', 1, 'Color', c_0);
grid on; ylabel('$v_{0s}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on Homopolar: $v_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);

% Corrección del título general del layout: se remueven los $ $ inestables
title(t_vqd0_lti, 'Respuestas Temporales de Tensi\''on qd0 - Modelo LTI', 'Interpreter', 'latex', 'FontSize', 12);
print('Figura5_vqd0_LTI', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 6: TENSIONES abc - MODELO LINEAL (LTI) - CORREGIDA
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_vabc_lti = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(vas_LTI.Values.Time, vas_LTI.Values.Data, 'LineWidth', 1, 'Color', c_a);
grid on; ylabel('$v_{as}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Fase A: $v_{as}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(vbs_LTI.Values.Time, vbs_LTI.Values.Data, 'LineWidth', 1, 'Color', c_b);
grid on; ylabel('$v_{bs}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Fase B: $v_{bs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(vcs_LTI.Values.Time, vcs_LTI.Values.Data, 'LineWidth', 1, 'Color', c_c);
grid on; ylabel('$v_{cs}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Fase C: $v_{cs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);

% Corrección del título general del layout
title(t_vabc_lti, 'Respuestas Temporales de Tensi\''on abc - Modelo LTI', 'Interpreter', 'latex', 'FontSize', 12);
print('Figura6_vabc_LTI', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 7: TENSIONES qd0 - MODELO NO LINEAL (NL) - CORREGIDA
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_vqd0_nl = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(vqs_NL.Values.Time, vqs_NL.Values.Data, 'LineWidth', 1, 'Color', c_q);
grid on; ylabel('$v_{qs}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Eje Cuadratura: $v_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(vds_NL.Values.Time, vds_NL.Values.Data, 'LineWidth', 1, 'Color', c_d);
grid on; ylabel('$v_{ds}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Eje Directo: $v_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(v0s_NL.Values.Time, v0s_NL.Values.Data, 'LineWidth', 1, 'Color', c_0);
grid on; ylabel('$v_{0s}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on Homopolar: $v_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);

% Corrección del título general del layout
title(t_vqd0_nl, 'Respuestas Temporales de Tensi\''on qd0 - Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 12);
print('Figura7_vqd0_NL', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 8: TENSIONES abc - MODELO NO LINEAL (NL) - CORREGIDA
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]); 
t_vabc_nl = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(vas_NL.Values.Time, vas_NL.Values.Data, 'LineWidth', 1, 'Color', c_a);
grid on; ylabel('$v_{as}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Fase A: $v_{as}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(vbs_NL.Values.Time, vbs_NL.Values.Data, 'LineWidth', 1, 'Color', c_b);
grid on; ylabel('$v_{bs}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Fase B: $v_{bs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
set(gca, 'XTickLabel', []);
nexttile;
plot(vcs_NL.Values.Time, vcs_NL.Values.Data, 'LineWidth', 1, 'Color', c_c);
grid on; ylabel('$v_{cs}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Tensi\''on de Fase C: $v_{cs}(t)$', 'Interpreter', 'latex', 'FontSize', 11);

% Corrección del título general del layout
title(t_vabc_nl, 'Respuestas Temporales de Tensi\''on abc - Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 12);
print('Figura8_vabc_NL', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 9: GRÁFICO COMPARATIVO DE CORRIENTES - CORREGIDA
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]);
t_comp_i = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(iqs_LTI.Values.Time, iqs_LTI.Values.Data, style_LTI{:}); hold on;
plot(iqs_NL.Values.Time,  iqs_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('$i_{qs}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Comparativa $i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);
nexttile;
plot(ids_LTI.Values.Time, ids_LTI.Values.Data, style_LTI{:}); hold on;
plot(ids_NL.Values.Time,  ids_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('$i_{ds}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
title('Comparativa $i_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);
legend({'Modelo LTI', 'Modelo NL'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
nexttile;
plot(i0s_LTI.Values.Time, i0s_LTI.Values.Data, style_LTI{:}); hold on;
plot(i0s_NL.Values.Time,  i0s_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('$i_{0s}$ [A]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Comparativa $i_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);

% Corrección del título del layout comparativo (Se remueve la tipografía matemática inestable)
title(t_comp_i, 'Comparativa de Corrientes Estat\''oricas: LTI vs. NL', 'Interpreter', 'latex', 'FontSize', 12);
print('Figura9_Comparativa_Corrientes', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 10: GRÁFICO COMPARATIVO DE TENSIONES - LTI VS. NL
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5]);
t_comp_v = tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(vqs_LTI.Values.Time, vqs_LTI.Values.Data, style_LTI{:}); hold on;
plot(vqs_NL.Values.Time,  vqs_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('$v_{qs}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Comparativa $v_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);
nexttile;
plot(vds_LTI.Values.Time, vds_LTI.Values.Data, style_LTI{:}); hold on;
plot(vds_NL.Values.Time,  vds_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('$v_{ds}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('Comparativa $v_{ds}(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);
legend({'Modelo LTI', 'Modelo NL'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);
nexttile;
plot(v0s_LTI.Values.Time, v0s_LTI.Values.Data, style_LTI{:}); hold on;
plot(v0s_NL.Values.Time,  v0s_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('$v_{0s}$ [V]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
title('Comparativa $v_{0s}(t)$', 'Interpreter', 'latex', 'FontSize', 11);
title(t_comp_v, 'Comparativa de Tensiones de Fase: LTI vs. NL', 'Interpreter', 'latex', 'FontSize', 12);
print('Figura10_Comparativa_Tensiones', '-dpng', '-r300');

% --- Función auxiliar interna para el desempaquetado condicional ---
function res = ifthen(cond, trueFunc, falseFunc)
    if cond, res = trueFunc(); else, res = falseFunc(); end
end