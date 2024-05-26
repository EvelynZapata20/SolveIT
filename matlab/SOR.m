%SOR: Calcula la solución del sistema
%Ax=b con base en una condición inicial x0,mediante el método Gauss Seidel (relajado), depende del valor de w 
%entre (0,2)

function [r, n, xi, E, radio] = SOR(x0, A, b, Tol, niter, w, tipe)
    format long;
    A = eval(A);
    b = eval(b);
    x0 = eval(x0);

    c = 0;
    error = Tol + 1;
    D = diag(diag(A));
    L = -tril(A, -1);
    U = -triu(A, 1);
    xi = []; % Lista de listas para almacenar xi
    E = [];  % Lista para almacenar errores
    n = [];  % Lista para almacenar n

    while error > Tol && c < niter
        T = inv(D - w * L) * ((1 - w) * D + w * U);
        radio_value= max(abs(eig(T))); 
        radio = sprintf('El radio espectral es de %f', radio_value);
        C = w * inv(D - w * L) * b;
        x1 = T * x0 + C;
        if strcmp(tipe, 'Cifras Significativas')
            error = norm((x1 - x0) ./ x1, 'inf');
        else
            error = norm(x1 - x0, 'inf'); 
        end
        E(end + 1) = error;
        xi(:, end + 1) = x1; % Agregar x1 a la lista de listas xi
        n(end + 1) = c + 1;   % Agregar n a la lista n
        x0 = x1;
        
        c = c + 1;
    end
    
    if error < Tol
        r = sprintf('es una aproximación de la solución del sistema con una tolerancia= %f\n', Tol);
    else
        r = sprintf('Fracasó en %d iteraciones\n', niter);
    end

    T = table(n', xi', E', 'VariableNames', {'N', 'xi', 'E'});
    csv_file_path = "app/tables/tabla_sor.csv";
    writetable(T, csv_file_path)
    
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
    saveas(fig, 'app/static/grafica_sor.png');
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
        case 6
            sizee = 4.6; 
            const = 0.105;  
    end
end