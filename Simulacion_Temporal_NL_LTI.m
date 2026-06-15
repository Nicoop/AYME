%% =========================================================================
%% 1. EJECUTAR LAS SIMULACIONES DESDE EL SCRIPT
%% =========================================================================
disp('Simulando Modelo No Lineal (NL)...');
simOut_NL = sim('Diagramas_pruebas_modelo_definitivo.slx', 'SimulationMode', 'normal');

disp('Simulando Modelo Linealizado (LTI)...');
simOut_LTI = sim('Simulacion_Temporal_LTI.slx', 'SimulationMode', 'normal');

%% =========================================================================
%% 2. EXTRACCIÓN DE LOS DATOS EXPORTADOS (Independizados por modelo)
%% =========================================================================
logs_NL  = simOut_NL.logsout;
logs_LTI = simOut_LTI.logsout;

% --- Extracción de variables del Modelo No Lineal (NL) ---
v_qs_ref_raw   = logs_NL.get('v_ref');       
T_carga_raw    = logs_NL.get('T_carga');
iqs_NL_raw     = logs_NL.get('i_qs_NL');      
wm_NL_raw      = logs_NL.get('w_m_NL');      
thetam_NL_raw  = logs_NL.get('theta_m_NL');  
Ts_NL_raw      = logs_NL.get('T_s_NL');      
Tm_NL_raw      = logs_NL.get('T_m_NL');      

% --- Extracción de variables del Modelo Lineal (LTI) ---
iqs_LTI_raw    = logs_LTI.get('i_qs_LTI');    
wm_LTI_raw     = logs_LTI.get('w_m_LTI');
thetam_LTI_raw = logs_LTI.get('theta_m_LTI'); 
Ts_LTI_raw     = logs_LTI.get('T_s_LTI');
Tm_LTI_raw     = logs_LTI.get('T_m_LTI');     

% --- Función anónima para desempaquetar dinámicamente según el objeto ---
unpack = @(obj) ifthen(isa(obj, 'Simulink.SimulationData.Dataset'), @() obj.getElement(1), @() obj);

v_qs_ref   = unpack(v_qs_ref_raw);   
T_carga    = unpack(T_carga_raw);
iqs_NL     = unpack(iqs_NL_raw);     
wm_NL      = unpack(wm_NL_raw);      
thetam_NL  = unpack(thetam_NL_raw);  
Ts_NL      = unpack(Ts_NL_raw);      
Tm_NL      = unpack(Tm_NL_raw);      

iqs_LTI    = unpack(iqs_LTI_raw);    
wm_LTI     = unpack(wm_LTI_raw);
thetam_LTI = unpack(thetam_LTI_raw); 
Ts_LTI     = unpack(Ts_LTI_raw);     
Tm_LTI     = unpack(Tm_LTI_raw);     

%% =========================================================================
%% FIGURA 1: GRÁFICOS DE REFERENCIAS (Eje Y aplastado)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 4]);
t_ref = tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

% Subplot 1: Tension de referencia (Trazo fino 1.0)
nexttile;
plot(v_qs_ref.Values.Time, v_qs_ref.Values.Data, 'LineWidth', 1.0, 'Color', [0.9 0.4470 0.90]);
grid on; hold on;
plot(0.1, 19.569, 'o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', [0.9 0.4470 0.90]);
text(0.11, 17, '19,569 V', 'FontSize', 9); 
plot(1.1, -19.569, 'o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', [0.9 0.4470 0.90]);
text(1.12, -17, '-19,569 V', 'FontSize', 9);
hold off;
ylabel('Tension [V]', 'Interpreter', 'latex', 'FontSize', 10);
title('$v_{qs}^*(t)$', 'Interpreter', 'latex', 'FontSize', 12);
set(gca, 'XTickLabel', []); 

% Subplot 2: Pulso de Torque de Carga
nexttile;
plot(T_carga.Values.Time, T_carga.Values.Data, 'LineWidth', 1.0, 'Color', [0.8500 0.3250 0.0980]);
grid on; hold on; 
plot(0.3, 6.28, 'o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
text(0.31, 5.0, '6,28 Nm', 'FontSize', 9); 
plot(0.5, -6.28, 'o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
text(0.51, -5.0, '-6,28 Nm', 'FontSize', 9);
hold off;
ylabel('Torque [N$\cdot$m]', 'Interpreter', 'latex', 'FontSize', 10);
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$T_{l}(t)$', 'Interpreter', 'latex', 'FontSize', 12);
%print('Pulso_Tension_y_Pulso_Torque', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 2: GRÁFICOS VARIABLES LTI (Eje Y aplastado, 5 subplots)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 6.5]); 
t_lti = tiledlayout(5, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(iqs_LTI.Values.Time, iqs_LTI.Values.Data, 'LineWidth', 1.0, 'Color', [0.8500 0.3250 0.0980]); 
grid on; ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 9);
title('$i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(wm_LTI.Values.Time, wm_LTI.Values.Data, 'LineWidth', 1.0, 'Color', [0.8500 0.3250 0.0980]);
grid on; ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 9);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(thetam_LTI.Values.Time, thetam_LTI.Values.Data, 'LineWidth', 1.0, 'Color', [0.8500 0.3250 0.0980]);
grid on; ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 9); 
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(Tm_LTI.Values.Time, Tm_LTI.Values.Data, 'LineWidth', 1.0, 'Color', [0.8500 0.3250 0.0980]);
grid on; ylabel('Torque [N$\cdot$m]', 'Interpreter', 'latex', 'FontSize', 9);
title('$T_m(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(Ts_LTI.Values.Time, Ts_LTI.Values.Data, 'LineWidth', 1.0, 'Color', [0.85 0.00 0.55]);
grid on; ylabel('Temperatura [$^{\circ}$C]', 'Interpreter', 'latex', 'FontSize', 9);
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$T_s(t)$', 'Interpreter', 'latex', 'FontSize', 11);

title(t_lti, 'Respuesta Temporal del Modelo Lineal (LTI)', 'Interpreter', 'latex', 'FontSize', 13);
%print('resultado_control_LTI', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 3: GRAFICOS VARIABLES NL (Ajustado a 4 subplots sin temperatura)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5.5]); 
t_nl = tiledlayout(4, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(iqs_NL.Values.Time, iqs_NL.Values.Data, 'LineWidth', 1.0, 'Color', [0 0.4470 0.7410]);
grid on; ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 9);
title('$i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []); 

nexttile;
plot(wm_NL.Values.Time, wm_NL.Values.Data, 'LineWidth', 1.0, 'Color', [0 0.4470 0.7410]);
grid on; ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 9);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(thetam_NL.Values.Time, thetam_NL.Values.Data, 'LineWidth', 1.0, 'Color', [0 0.4470 0.7410]);
grid on; ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 9); 
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(Tm_NL.Values.Time, Tm_NL.Values.Data, 'LineWidth', 1.0, 'Color', [0 0.4470 0.7410]);
grid on; ylabel('Torque [N$\cdot$m]','Interpreter', 'latex', 'FontSize', 9); 
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10); 
title('$T_m(t)$', 'Interpreter', 'latex', 'FontSize', 11);

title(t_nl, 'Respuesta Temporal del Modelo No Lineal (NL)', 'Interpreter', 'latex', 'FontSize', 13);
%print('resultado_control_NL', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 4: GRÁFICOS COMPARATIVOS ELÉCTRICOS Y MECÁNICOS (Eje Y aplastado)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 5.5]); 
t_comp = tiledlayout(4, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
style_LTI = {'-', 'LineWidth', 1.7, 'Color', [0.65 0.80 0.95]}; 
style_NL  = {'--', 'LineWidth', 1.4, 'Color', [0.15 0.25 0.45]}; 

nexttile;
plot(iqs_LTI.Values.Time, iqs_LTI.Values.Data, style_LTI{:}); hold on;
plot(iqs_NL.Values.Time,  iqs_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('Corriente [A]', 'Interpreter', 'latex', 'FontSize', 9);
title('$i_{qs}(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(wm_LTI.Values.Time, wm_LTI.Values.Data, style_LTI{:}); hold on;
plot(wm_NL.Values.Time,  wm_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('Velocidad [rad/s]','Interpreter', 'latex', 'FontSize', 9);
title('$\omega_m(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);
legend({'Modelo LTI', 'Modelo NL'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 8);

nexttile;
plot(thetam_LTI.Values.Time, thetam_LTI.Values.Data, style_LTI{:}); hold on;
plot(thetam_NL.Values.Time,  thetam_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('Posicion [rad]','Interpreter', 'latex', 'FontSize', 9); 
title('$\theta_m(t)$', 'Interpreter', 'latex', 'FontSize', 11); set(gca, 'XTickLabel', []);

nexttile;
plot(Tm_LTI.Values.Time, Tm_LTI.Values.Data, style_LTI{:}); hold on;
plot(Tm_NL.Values.Time,  Tm_NL.Values.Data,  style_NL{:});  hold off;
grid on; ylabel('Torque [N$\cdot$m]','Interpreter', 'latex', 'FontSize', 9); 
xlabel('Tiempo [s]','Interpreter', 'latex', 'FontSize', 10);
title('$T_m(t)$', 'Interpreter', 'latex', 'FontSize', 11);

title(t_comp, 'Comparativa de Respuesta Temporal: Modelo LTI vs. NL', 'Interpreter', 'latex', 'FontSize', 13);
%print('resultado_comparativa_LTI_NL', '-dpng', '-r300');

%% =========================================================================
%% FIGURA 5: COMPARATIVA TÉRMICA (Aislada y optimizada)
%% =========================================================================
figure('Units', 'inches', 'Position', [1, 1, 6, 3]);
color_rosado_LTI = [0.95 0.60 0.75]; 
color_fucsia_NL  = [0.85 0.00 0.55]; 

plot(Ts_LTI.Values.Time, Ts_LTI.Values.Data, '-', 'LineWidth', 2, 'Color', color_rosado_LTI); hold on;
plot(Ts_NL.Values.Time,  Ts_NL.Values.Data,  '--', 'LineWidth', 1.7, 'Color', color_fucsia_NL); hold off;
grid on;
xlabel('Tiempo [s]', 'Interpreter', 'latex', 'FontSize', 10);
ylabel('Temperatura [$^{\circ}$C]', 'Interpreter', 'latex', 'FontSize', 10);
title('Comparativa de Dinamica Termica $T_s(t)$: LTI vs. NL', 'Interpreter', 'latex','FontSize', 12)

ax = gca;
ax.YLim = [20, max([max(Ts_LTI.Values.Data), max(Ts_NL.Values.Data)]) * 1.05];
legend({'Modelo LTI (Linealizado)', 'Modelo NL (No Lineal)'}, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', 9);
%print('resultado_comparativa_termica', '-dpng', '-r300');

%% =========================================================================
%% CURVA PARAMÉTRICA: Torque electromagnético vs velocidad angular
%% =========================================================================
t = thetam_NL.Values.Time;
omega = wm_NL.Values.Data;
Tm = Tm_NL.Values.Data;

% Asegurar que sean vectores columna
t = t(:);
omega = omega(:);
Tm = Tm(:);

figure('Units','inches','Position',[1 1 8 5.5]);
hold on; grid on; box on;

% Límites automáticos con margen
xmax = max(abs(omega))*1.15;
ymax = max(abs(Tm))*1.15;
xlim([-xmax xmax]);
ylim([-ymax ymax]);

% Colores suaves para cuadrantes
c1 = [1.00 0.90 0.90];   % cuadrante I
c2 = [0.90 1.00 0.90];   % cuadrante II
c3 = [0.90 0.90 1.00];   % cuadrante III
c4 = [1.00 1.00 0.88];   % cuadrante IV

% Fondos de cuadrantes
patch([0 xmax xmax 0], [0 0 ymax ymax], c1, 'EdgeColor','none','FaceAlpha',0.35);
patch([-xmax 0 0 -xmax], [0 0 ymax ymax], c2, 'EdgeColor','none','FaceAlpha',0.35);
patch([-xmax 0 0 -xmax], [-ymax -ymax 0 0], c3, 'EdgeColor','none','FaceAlpha',0.35);
patch([0 xmax xmax 0], [-ymax -ymax 0 0], c4, 'EdgeColor','none','FaceAlpha',0.35);

% Ejes en cero
xline(0,'--k','LineWidth',1);
yline(0,'--k','LineWidth',1);

% Curva paramétrica
plot(omega, Tm, 'b', 'LineWidth', 1.4);

% Puntos inicial y final
plot(omega(1), Tm(1), 'ro', 'MarkerFaceColor','none', 'LineWidth',1.5);
plot(omega(end), Tm(end), 'ro', 'MarkerFaceColor','none', 'LineWidth',1.5);

% Tiempos específicos a marcar
t_mark = [0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5 1.7 1.9];

% Buscar el índice más cercano a cada tiempo
idx = zeros(size(t_mark));

for i = 1:length(t_mark)
    [~, idx(i)] = min(abs(t - t_mark(i)));
end

% Dibujar puntos y etiquetas
for i = 1:length(idx)
    k = idx(i);

    plot(omega(k), Tm(k), 'ro', ...
        'MarkerSize', 5, ...
        'MarkerFaceColor', 'w', ...
        'LineWidth', 1.2);

    text(omega(k), Tm(k), sprintf(' t=%.1f', t(k)), ...
        'FontSize', 8, ...
        'FontWeight', 'bold');
end

% Títulos y etiquetas
title('Curva paramétrica torque electromagnético vs. velocidad angular', 'FontWeight','bold');
xlabel('$\omega_m(t)$ [rad/s]', 'Interpreter','latex');
ylabel('$T_m(t)$ [N.m]', 'Interpreter','latex');

% Textos de cuadrantes
text(0.75*xmax, 0.82*ymax, {'Cuadrante I','Motorización Directa'}, ...
    'HorizontalAlignment','center', 'FontWeight','bold', 'BackgroundColor','w', 'EdgeColor',[0.5 0.5 0.5]);
text(-0.75*xmax, 0.82*ymax, {'Cuadrante II','Frenado Regenerativo Inverso'}, ...
    'HorizontalAlignment','center', 'FontWeight','bold', 'BackgroundColor','w', 'EdgeColor',[0.5 0.5 0.5]);
text(-0.75*xmax, -0.82*ymax, {'Cuadrante III','Motorización Inversa'}, ...
    ...
    'HorizontalAlignment','center', 'FontWeight','bold', 'BackgroundColor','w', 'EdgeColor',[0.5 0.5 0.5]);
text(0.75*xmax, -0.82*ymax, {'Cuadrante IV','Frenado Regenerativo Directo'}, ...
    'HorizontalAlignment','center', 'FontWeight','bold', 'BackgroundColor','w', 'EdgeColor',[0.5 0.5 0.5]);
hold off;
print('curva_paramétrica', '-dpng', '-r300');

% --- Función auxiliar interna para el desempaquetado condicional ---
function res = ifthen(cond, trueFunc, falseFunc)
    if cond, res = trueFunc(); else, res = falseFunc(); end
end