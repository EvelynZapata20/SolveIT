function [xi, errores, resultado] = multiple_roots(fn_str, xi, tol, k, et)
    % Validar el tipo de error
    if ~ismember(et, {'Decimales Correctos', 'Cifras Significativas'})
        error('El tipo de error no es valido');
    end

    % Convertir la función de entrada a una expresión simbólica y derivar
    syms x;
    fn = str2sym(fn_str);
    fn_num = matlabFunction(fn);
    fn_1 = diff(fn, x);
    fn_2 = diff(fn_1, x);

    % Inicializar variables
    errores = [];
    fnx = [];
    xis = [xi];  % Inicializar con el valor inicial
    error = tol + 1;
    n = 0;

    % Iteración principal del método
    while error > tol && n < k
        fxi = double(subs(fn, x, xi));
        fxi_1 = double(subs(fn_1, x, xi));
        fxi_2 = double(subs(fn_2, x, xi));

        if fxi == 0
            errores = [errores, 0];
            fnx = [fnx, fxi];
            break;
        end

        xi_1 = xi - (fxi * fxi_1) / (fxi_1^2 - fxi * fxi_2);

        if strcmp(et, 'Decimales Correctos')
            error = abs(xi_1 - xi);
        else
            error = abs(xi_1 - xi) / abs(xi_1);
        end

        % Actualizar xi para la próxima iteración
        errores = [errores, error];
        fnx = [fnx, fxi];
        xis = [xis, xi_1];
        
        xi = xi_1;
        n = n + 1;

        % Información de depuración en cada iteración
        disp(['Iteración: ', num2str(n)]);
        disp(['xi: ', num2str(xi)]);
        disp(['xi_1: ', num2str(xi_1)]);
        disp(['fxi: ', num2str(fxi)]);
        disp(['error: ', num2str(error)]);
        disp(['Longitud de xis: ', num2str(length(xis))]);
        disp(['Longitud de fnx: ', num2str(length(fnx))]);
        disp(['Longitud de errores: ', num2str(length(errores))]);
    end

    % Ajustar las longitudes de las listas al final del bucle si es necesario
    if length(xis) > length(fnx)
        xis(end) = [];
    end

    % Determinar el resultado final
    if fxi == 0
        resultado = sprintf('%f es raíz de f(x)\n', xi);
    elseif error < tol
        resultado = sprintf('%f es una aproximación de una raíz de f(x) con una tolerancia= %f\n', xi, tol);
    else
        resultado = sprintf('Fracasó en %d iteraciones\n', k);
    end

    % Depuración adicional
    disp('Debug Info Final:');
    disp(['Longitud de xis: ', num2str(length(xis))]);
    disp(['Longitud de fnx: ', num2str(length(fnx))]);
    disp(['Longitud de errores: ', num2str(length(errores))]);

    % Verificar longitud de los vectores antes de graficar
    if length(xis) ~= length(fnx) || length(fnx) ~= length(errores)
        error('xis, fnx y errores deben tener la misma longitud antes de graficar.');
    end

    % Graficar resultados
    fig = figure;
    xplot = linspace(min(xis) - 1, max(xis) + 1, 1000);  % Ajustar según sea necesario
    plot(xplot, fn_num(xplot), 'b');  % Dibuja la función
    hold on;
    scatter(xis, fnx, 'ro');  % Dibuja los puntos de aproximación
    title('Visualización de la Convergencia del Método de Raíces Múltiples');
    xlabel('x');
    ylabel('f(x)');
    grid on;

    currentDir = fileparts(mfilename('fullpath'));
    staticDir = fullfile(currentDir, '..', 'app', 'static');
    if ~exist(staticDir, 'dir')
        mkdir(staticDir);  % Crea el directorio si no existe
    end
    imgPath = fullfile(staticDir, 'grafica_multiple_roots.png');
    img = getframe(gcf);
    imwrite(img.cdata, imgPath);
    hold off;
    close(fig);

    % Verificación de consistencia de dimensiones
    if length(xis) == length(fnx) && length(fnx) == length(errores)
        % Agregar registro final de la iteración si se necesita para CSV
        resultados = [(1:length(xis))', xis', fnx', errores'];  % Ajustar (1:length(xis)) para incluir todas las iteraciones
    else
        disp('Debug Info Final:');  % Información de depuración
        disp(['Longitud de xis: ', num2str(length(xis))]);
        disp(['Longitud de fnx: ', num2str(length(fnx))]);
        disp(['Longitud de errores: ', num2str(length(errores))]);
        error('Las dimensiones de los arrays no son consistentes.');
    end

    % Guardar los resultados en una tabla y en un archivo CSV
    T = table(resultados(:,1), resultados(:,2), resultados(:,3), resultados(:,4), ...
              'VariableNames', {'Iteración', 'xi', 'f(xi)', 'Error'});
    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    if ~exist(tablesDir, 'dir')
        mkdir(tablesDir);
    end
    csvFilePath = fullfile(tablesDir, 'multiple_roots_results.csv');
    writetable(T, csvFilePath);
end



