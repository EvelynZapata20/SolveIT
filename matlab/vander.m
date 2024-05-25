function [pol] = vandermonde(vectorx, vectory)
    % Asignar los vectores de entrada
    xv = vectorx;
    yv = vectory;

    % Verificar que los vectores tienen la misma longitud
    if length(xv) ~= length(yv)
        error('Los vectores x e y deben tener la misma longitud.');
    end

    % Establecer la variable "degree"
    degree = length(xv);

    % Crear la matriz de Vandermonde
    A = zeros(degree);
    for i = 1:degree
        for j = 1:degree
            A(i, j) = xv(i)^(degree-j);
        end
    end

    % Resolver el sistema de ecuaciones para encontrar los coeficientes del polinomio
    coeficientes = A \ yv';

    % Construir el polinomio de salida
    pol = coeficientes';

    % Mostrar los resultados
    disp('Matriz de Vandermonde (A):');
    disp(A);
    disp('Vector de términos independientes (yv):');
    disp(yv);
    disp('Coeficientes del polinomio:');
    disp(pol);

    % Guardar el polinomio en un archivo CSV
    syms x;  % Define x como una variable simbólica
    polinomio_sym = poly2sym(pol, x);
    polinomio_str = char(polinomio_sym);
    tabla = table({polinomio_str}, 'VariableNames', {'Polinomio'});
    currentDir = fileparts(mfilename('fullpath'));
    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    if ~exist(tablesDir, 'dir')
        mkdir(tablesDir);
    end
    csv_file_path = fullfile(tablesDir, 'pol_vandermonde.csv');
    writetable(tabla, csv_file_path);

    % Crear un conjunto de puntos para graficar el polinomio
    x_vals = linspace(min(xv), max(xv), 1000);
    y_vals = polyval(pol, x_vals);

    % Graficar el polinomio resultante
    figure;
    plot(x_vals, y_vals, 'r', xv, yv, 'bo'); % Polinomio en rojo, puntos en azul
    title('Polinomio usando matriz de Vandermonde');
    xlabel('x');
    ylabel('y');
    legend('Polinomio', 'Puntos de entrada');
    grid on;
    img = getframe(gcf);
    currentDir = fileparts(mfilename('fullpath'));
    staticDir = fullfile(currentDir, '..', 'app', 'static');
    if ~exist(staticDir, 'dir')
        mkdir(staticDir);  % Crea el directorio si no existe
    end
    imgPath = fullfile(staticDir, 'grafica_vander.png');

    imwrite(img.cdata, imgPath);

end
