% Script para graficar los polos en el plano complejo (Plano s)

% --- Definición de los datos de la tabla ---

% Caso PID Mínimo (Nominal)
polos_min = [
    -800 + 0i;
    -600 + 529.15i;
    -600 - 529.15i
];

% Caso PID Máximo
polos_max = [
    -438.18 + 0i;
    -212.55 + 677.64i;
    -212.55 - 677.64i
];

% Polo del Lazo de Corriente
polo_corriente = -5000 + 0i;

% Polos de Lazo Abierto Completos (Aumentado con dinámica d y térmica)
polos_la = [
    -100 - 150i;
    -100 + 150i;
    0 + 0i;
];

% --- Creación de la gráfica ---
figure;
hold on;
grid on;

% Graficar polos del caso PID Mínimo (Cruz Azul 'bx')
h1 = plot(real(polos_min), imag(polos_min), 'bx', 'MarkerSize', 10, 'LineWidth', 2);

% Graficar polos del caso PID Máximo (Cruz Roja 'rx')
h2 = plot(real(polos_max), imag(polos_max), 'rx', 'MarkerSize', 10, 'LineWidth', 2);

% Graficar polo del Lazo de Corriente (Cruz Verde 'gx')
h3 = plot(real(polo_corriente), imag(polo_corriente), 'gx', 'MarkerSize', 12, 'LineWidth', 2);

% Graficar polos del Lazo Abierto (Cruz Negra 'kx')
h4 = plot(real(polos_la), imag(polos_la), 'kx', 'MarkerSize', 10, 'LineWidth', 2);

% --- Configuración de los ejes, diseño e IGUALDAD DE UNIDADES ---

% Forzar igualdad de escala en las unidades de ambos ejes (1:1)
axis equal; 

% Dibujar los ejes real e imaginario centrados en cero
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

% Etiquetas y título
xlabel('Eje Real [\sigma] (rad/s)', 'FontSize', 11, 'VerticalAlignment', 'top');
ylabel('Eje Imaginario [j\omega] (rad/s)', 'FontSize', 11, 'HorizontalAlignment', 'right');
title('Mapa de polos (comparación)', 'Interpreter', 'latex', 'FontSize', 14);

% Ajustar límites manteniendo la simetría y la relación de aspecto 1:1
xlim([-5500, 500]);
ylim([-3000, 3000]); % Expandido proporcionalmente para albergar la escala simétrica

% Añadir la leyenda con todas las categorías correspondientes
legend([h1(1), h2(1), h3, h4(1)], ...
    {'PID Mínimo (Nominal)', 'PID Máximo', 'Lazo de Corriente', 'Lazo Abierto'}, ...
    'Location', 'best');

hold off;