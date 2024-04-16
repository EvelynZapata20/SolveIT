function [N, xn, fm, E] = pf(f_str, g_str, x0, Tol, niter)
    f = str2func(['@(x)' f_str]);
    g = str2func(['@(x)' g_str]);
    
    c = 0;
    fm(c+1) = f(x0);
    fe = fm(c+1);
    E(c+1) = Tol + 1;
    error = E(c+1);
    xn(c+1) = x0;
    N(c+1) = c;
    
    while error > Tol && fe ~= 0 && c < niter
        xn(c+2) = g(x0);
        fm(c+2) = f(xn(c+2));
        fe = fm(c+2);
        E(c+2) = abs(xn(c+2) - x0);
        error = E(c+2);
        x0 = xn(c+2);
        N(c+2) = c+1;
        c = c+1;
    end
    
    if fe == 0
        fprintf('%f es raíz de f(x)\n', x0)
    elseif error < Tol
        fprintf('%f es una aproximación de una raíz de f(x) con una tolerancia= %f\n', x0, Tol)
    else
        fprintf('Fracasó en %f iteraciones\n', niter)
    end
end
