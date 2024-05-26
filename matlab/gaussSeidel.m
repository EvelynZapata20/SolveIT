function [r, N, xn, E, re] = gaussSeidel(x0, A, b, et, Tol, niter)
    disp(x0)
    disp(A)
    disp(b)
    x0 = eval(x0);
    A = eval(A);
    b = eval(b);
    c = 0;
    error = Tol + 1;
    D = diag(diag(A));
    L = -tril(A, -1);
    U = -triu(A, 1);
    N(c+1) = c;

    while error > Tol && c < niter
        T = inv(D-L) * U;
        C = inv(D-L) * b;
        x1 = T * x0 + C;

        if strcmp(et, 'Error Absoluto')
            E(c+1)=norm(x1-x0,'inf');
        else
            E(c+1) = norm((x1 - x0) ./ x1, 'inf');
        end
        error = E(c+1);
        x0 = x1;
        N(c+1) = c + 1;
        c = c + 1;
        xn{c} = mat2str(x1);
    end
    Re=max(abs(eig(T)));
    
    if error < Tol
        re = sprintf('Radio espectral de T= %f\n',Re)
        r = sprintf('%s Es una aproximación de la solución del sistema con una tolerancia= %f\n',xn{c}, Tol)
    else 
        r = sprintf('Fracasó en %f iteraciones\n', niter) 
    end


    T = table(N', xn', E', 'VariableNames', {'Iteration', 'xn', 'E'});
    csv_file_path = "app/tables/tabla_gaussSeidel.csv";
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
    saveas(fig, 'app/static/grafica_gaussSeidel.png');
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