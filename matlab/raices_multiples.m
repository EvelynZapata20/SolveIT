function [xi, errores] = multiple_roots(fn_str, xi, tol, k, et)
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
    xis = [];
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
        xi = xi_1;
        errores = [errores, error];
        fnx = [fnx,fxi];
        xis = [xis,xi];
        n = n + 1;
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
    
    

    % Agregar registro final de la iteración si se necesita para CSV
    resultados = [(1:n)', xis', fnx', errores'];

    % Guardar los resultados en una tabla y en un archivo CSV
    T = table(resultados(:,1), resultados(:,2), resultados(:,3), resultados(:,4), ...
              'VariableNames', {'Iteración', 'xi', 'f(xi)', 'Error'});
    currentDir = fileparts(mfilename('fullpath'));
    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    if ~exist(tablesDir, 'dir')
        mkdir(tablesDir);
    end
    csvFilePath = fullfile(tablesDir, 'multiple_roots_results.csv');
    writetable(T, csvFilePath);
end
