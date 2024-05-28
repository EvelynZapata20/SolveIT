function [respuesta, N, XN, fm, E] = secante(func, x0, x1, Tol, niter, Terror)

    f = str2func(['@(x)' func]);
    c = 0;
    fm = zeros(1, niter + 1);  % Inicialización de fm
    E = zeros(1, niter + 1);    % Inicialización de E
    N = zeros(1, niter + 1);    % Inicialización de N
    XN = zeros(1, niter + 1);   % Inicialización de XN
    
    fm(c+1) = eval(subs(f, x0));
    f0 = fm(c+1);
    fm(c+2) = eval(subs(f, x1));
    fe = fm(c+2);
    E(c+1) = Tol + 1;
    E(c+2) = Tol + 1;
    error = E(c+2);
    xn = x1;
    N(c+1) = c;
    N(c+2) = c;
    XN(c+1) = x0;
    XN(c+2) = xn;

    while error > Tol && fe ~= 0 && c < niter
        xm = xn - ((fe * (xn - x0)) / (fe - f0));
        XN(c+3) = xm;

        f0 = fe;
        fm(c+3) = eval(subs(f, xm));
        fe = fm(c+3);

        if strcmp(Terror, 'Decimales Correctos')
            E(c+3) = abs(xm - xn);
        else
            E(c+3) = abs((xm - xn) / xm);
        end

        error = E(c+3);

        x0 = xn;
        xn = xm;

        N(c+3) = c+1;
        c = c+1;
    end

    if fe == 0
        respuesta = sprintf('%f es raiz de f(x) \n', xn);
        E(c+3) = 0;
    elseif error < Tol
        respuesta = sprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f \n', xn, Tol);
    else
        respuesta = sprintf('Fracasó en %f iteraciones \n', niter);
    end

    % Eliminar elementos no utilizados
    N = N(1:c+2);
    XN = XN(1:c+2);
    fm = fm(1:c+2);
    E = E(1:c+2);

    % Crear tabla
    T = table(N', XN', fm', E', 'VariableNames', {'Iteration', 'xn', 'fxn', 'E'});

    % Guardar tabla en un archivo CSV
    currentDir = fileparts(mfilename('fullpath'));
    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    mkdir(tablesDir);
    csv_file_path = fullfile(tablesDir, 'tabla_secante.csv');
    writetable(T, csv_file_path);

    % Generar la gráfica y guardarla como una imagen PNG
    fig = figure('Visible', 'off');
    xplot = ((xn - 2):0.1:(xn + 2));
    hold on;
    yline(0);
    plot(xplot, eval(subs(f, xplot)));
    img = getframe(gcf);
    staticDir = fullfile(currentDir, '..', 'app', 'static');
    mkdir(staticDir);
    imgPath = fullfile(staticDir, 'grafica_secante.png');
    imwrite(img.cdata, imgPath);
    hold off;
    close(fig);

end
