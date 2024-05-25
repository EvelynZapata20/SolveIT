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
    fig = figure('Visible','off');
    set(fig, 'Color', 'white', 'Units', 'inches', 'Position', [0, 0, 4.5, 4]);
    axis off;
    title('Solución Sistema de Ecuaciones Ax = b', 'FontSize', 14, 'FontWeight', 'bold');
    
    % Crear una posición inicial
    posY = 0.8;
    posX = 0.1;
    tamano = 0.0;
    
    % Mostrar la matriz A
    text(posX, posY, 'A', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black');
    posY = posY - 0.05;
    for i = 1:size(A, 1)
        text(posX, posY, mat2str(A(i, :)), 'FontSize', 12, 'Color', 'blue');
        posY = posY - 0.05;
        tamano = tamano + 0.1;
    end
    
    % Mostrar el vector solución x
    posY = 0.8;
    posX = posX + tamano;   
    text(posX, posY, 'xn', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black');
    posY = posY - 0.05;
    for i = 1:size(x1, 1)
        text(posX, posY, sprintf('%.4f', x1(i, :)), 'FontSize', 12, 'Color', 'green');
        posY = posY - 0.05;
    end
    
    %Mostrar el vector b
    posY = 0.8;
    posX = posX + tamano;
    text(posX, posY, 'b', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black');
    posY = posY - 0.05;
    for i = 1:size(b, 1)
        text(posX, posY, mat2str(b(i, :)), 'FontSize', 12, 'Color', 'red');
        posY = posY - 0.05;
    end
    
    % Guardar la figura como PNG
    saveas(fig, 'app/static/grafica_gaussSeidel.png');
    close(fig);
   
end

 