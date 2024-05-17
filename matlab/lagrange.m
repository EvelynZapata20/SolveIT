function [pol] = lagrange(vectorx, vectory)
    xv = vectorx;
    yv = vectory;
    n = length(xv);
    Tabla = zeros(n, n);
    for i = 1:n
        Li = 1;
        den = 1;
        for j = 1:n
            if j ~= i
                paux = [1, -xv(j)];
                Li = conv(Li, paux);
                den = den * (xv(i) - xv(j));
            end
        end
        Tabla(i, :) = yv(i) * Li / den;
    end
    pol = sum(Tabla);

    % Guardar el polinomio en un archivo CSV
    syms x;  % Define x como una variable simbólica
    polinomio_sym = poly2sym(pol, x);
    polinomio_str = char(polinomio_sym);
    tabla = table({polinomio_str}, 'VariableNames', {'Polinomio'});
    csv_file_path = 'tables/tabla_lagrange.csv';
    writetable(tabla, csv_file_path);

    % Crear un conjunto de puntos para graficar el polinomio
    x_vals = linspace(min(xv), max(xv), 1000);
    y_vals = polyval(pol, x_vals);

    % Graficar el polinomio resultante
    figure;
    plot(x_vals, y_vals, 'r', xv, yv, 'bo'); % Polinomio en rojo, puntos en azul
    title('Polinomio de Lagrange');
    xlabel('x');
    ylabel('y');
    legend('Polinomio de Lagrange', 'Puntos de entrada');
    grid on;
    img = getframe(gcf);
    imwrite(img.cdata, './static/grafica_lagrange.png');
end
