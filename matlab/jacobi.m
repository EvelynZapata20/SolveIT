function [r, N, xi, E, Re] = jacobi(x0, A, b, Tol, niter, error_type)
    x0 = eval(x0);
    A = eval(A);
    b = eval(b);
    c = 0;
    error = Tol + 1;
    D = diag(diag(A));
    L = -tril(A, -1);
    U = -triu(A, +1);
    Tr = inv(D) * (L + U);
    C = inv(D) * b;

    autovalores = eig(Tr);
    calculo_re = max(abs(autovalores));
    Re = sprintf('Radio espectral: %f', calculo_re);

    xi = []; % Inicializar xi como una matriz vacía
    E = [];  % Inicializar E como una lista vacía
    N = [];  % Inicializar N como una lista vacía

    while error > Tol && c < niter
        x1 = Tr * x0 + C;

        if strcmp(error_type, 'Error Absoluto')
            E(c + 1) = norm(x1 - x0, 'inf');
        else
            E(c + 1) = norm((x1 - x0) ./ x1, 'inf');
        end

        error = E(c + 1);
        xi = [xi; x1']; % Agregar x1 como una nueva fila en la matriz xi
        N(c + 1) = c + 1;   % Agregar n a la lista N
        x0 = x1;
        c = c + 1;
    end

    if error < Tol
        r = sprintf('%s Es una aproximación de la solución del sistema con una tolerancia= %f\n', mat2str(x1), Tol);
    else 
        r = sprintf('Fracasó en %f iteraciones\n', niter); 
    end

    % Guardar los resultados en un archivo CSV
    xi_table = array2table(xi, 'VariableNames', arrayfun(@(i) sprintf('x%d', i), 1:size(xi, 2), 'UniformOutput', false));
    T = table(N', E', 'VariableNames', {'Iteration', 'E'});
    T = [T, xi_table];
    
    currentDir = fileparts(mfilename('fullpath'));
    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    if ~exist(tablesDir, 'dir')
        mkdir(tablesDir);
    end
    csvFilePath = fullfile(tablesDir, 'tabla_jacobi.csv');
    writetable(T, csvFilePath);

    % Crear la figura para visualizar la matriz A, el vector solución x, y el vector b
    [sizee, const]= calculate(length(b));
    fig = figure('Visible','off');
    set(fig, 'Color', 'white', 'Units', 'inches', 'Position', [0, 0, sizee, sizee/2]);
    axis off;

    % Crear una posición inicial
    posY = 1;
    posX = 0.01;
    % Mostrar la matriz A
    text(posX, posY, 'A', 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'black');
    posY = posY - 0.12;
    for i = 1:size(A, 1)
        formattedRow = arrayfun(@(num) sprintf('%.2f', num), A(i, :), 'UniformOutput', false);
        rowText = strjoin(formattedRow, '    ');
        text(posX, posY, rowText, 'FontSize', 8, 'Color', 'blue');
        posY = posY - 0.12;
    end

    posX= posX+(const*length(b));
    text(posX, 0.8, '*', 'FontSize', 15, 'FontWeight', 'bold', 'Color', 'black');

    % Mostrar el vector solución x
    posY = 1;
    posX = posX+0.06;  % Ajustar la posición en X después de la matriz A
    text(posX, posY, 'xn', 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'black');
    posY = posY - 0.12;
    for i = 1:size(x1, 1)
        xText = formatNumber(x1(i));
        text(posX, posY, xText, 'FontSize', 8, 'Color', 'green');
        posY = posY - 0.12;
    end

    posX= posX+(2.2*const);
    text(posX, 0.8, '=', 'FontSize', 15, 'FontWeight', 'bold', 'Color', 'black');
    % Mostrar el vector b
    posY = 1;
    posX = posX+(const/2);  % Ajustar la posición en X después del vector solución x
    text(posX, posY, 'b', 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'black');
    posY = posY - 0.12;
    for i = 1:size(b, 1)
        bText = sprintf('%.2f', b(i));
        text(posX, posY, bText, 'FontSize', 8, 'Color', 'red');
        posY = posY - 0.12;
    end


    % Guardar la figura como PNG
    staticDir = fullfile(currentDir, '..', 'app', 'static');
    if ~exist(staticDir, 'dir')
        mkdir(staticDir);  % Crea el directorio si no existe
    end
    imgPath = fullfile(staticDir, 'grafica_jacobi.png');
    img = getframe(gcf);
    imwrite(img.cdata, imgPath);
    hold off;
    close(fig);
end


% Función para formatear números
function str = formatNumber(num)
    if abs(num) >= 1e6
        str = sprintf('%.4e', num);
    else
        str = sprintf('%.8f', num);
    end
end

function [sizee, const] = calculate(b)
    switch b
        case {1, 2, 3}
            sizee = 3;
            const = 0.15;  
        case 4
            sizee= 3.4;
            const = 0.135;   
        case 5
            sizee = 4.2; 
            const = 0.11;   
        case {6, 7, 8}
            sizee = 4.6; 
            const = 0.105;  
    end
end