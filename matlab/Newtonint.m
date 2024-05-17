function [Tabla] = Newtonint(x, y)
    format long
    
    % Convertir x e y a matrices numéricas
    x = double(x);
    y = double(y);
    
    %number of points
    n = length(x);
    
    Tabla = zeros(n, n + 1);
    Tabla(:, 1) = x;
    Tabla(:, 2) = y;
    for j = 3:n + 1
        for i = j-1:n
            Tabla(i, j) = (Tabla(i, j-1) - Tabla(i-1, j-1)) / (Tabla(i, 1) - Tabla(i-j+2, 1)); %n-esima diferencia dividida
        end
    end
    
    %la convertimos en los coeficientes
    coef = diag(Tabla, +1);
    
    pol = 1;
    acum = pol;
    pol = coef(1) * acum;
    for i = 1:n - 1
        pol = [0 pol];
        acum = conv(acum, [1 -x(i)]);
        pol = pol + coef(i+1) * acum; %subtermino de polinomio de newton: pn(x) = b0 + b1(x-x0)+...+bn(x-x0)(x-x1)...(x-xn-1)
    end
    
    % Mostrar la tabla de diferencias divididas
    disp('Tabla de diferencias divididas de Newton:');
    disp(Tabla);
    csv_file_path = "tables/tabla_newtonint.csv";
    
    % Guardar la tabla con decimales
    writetable(array2table(Tabla), csv_file_path, 'Delimiter', ',', 'WriteVariableNames', false);
    
    % Mostrar el polinomio de interpolación
    disp('Polinomio de interpolacion:');
    disp(pol);

    % Generar valores de x para graficar
    xpol = min(x):0.001:max(x);
    p = zeros(size(xpol));
    
    % Calcular el polinomio para cada grado
    for i = 1:length(pol)
        p = p + pol(i) * xpol.^(length(pol)-i);
    end

    figure
    hold on
    plot(x, y, 'r*', xpol, p, 'b')
    legend('Datos', 'Polinomio de Interpolacion')
    xlabel('x')
    ylabel('y')
    title('Interpolacion de Newton con Diferencias Divididas')
    grid on
    
    % Guardar la gráfica en un archivo PNG
    img = getframe(gcf);
    imwrite(img.cdata, './static/grafica_newtonInt.png');
    hold off;
end
