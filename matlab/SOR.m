%SOR: Calcula la solución del sistema
%Ax=b con base en una condición inicial x0,mediante el método Gauss Seidel (relajado), depende del valor de w 
%entre (0,2)

function [r, n, xi, E] = SOR(x0, A, b, Tol, niter, w, tipe)
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
        r = sprintf('Es una aproximación de la solución del sistema con una tolerancia= %f\n', Tol);
    else
        r = sprintf('Fracasó en %d iteraciones\n', niter);
    end
end