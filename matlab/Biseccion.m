%Bisección: se ingresa el valor inicial y final del intervalo (xi, xs), la tolerancia del error (Tol) y el màximo nùmero de iteraciones (niter) 

function [r, N, xn, fm, E] = biseccion(f_str, xi, xs, Tol, niter, tipe)
    f = str2func(['@(x)' f_str]);

    fi = eval(subs(f, xi));
    fs = eval(subs(f, xs));
    if fi == 0
        xn = xi;
        E = 0;
        r= sprintf('%f es raiz de f(x)', xi)
    elseif fs == 0
        xn = xs;
        E = 0;
        r= sprintf('%f es raiz de f(x)', xs)
    elseif fs * fi < 0
        N = 0;
        xm = (xi + xs) / 2;
        fm(N + 1) = eval(subs(f, xm));
        fe = fm(N + 1);
        N_list(N + 1) = N; 
        xn_list(N + 1) = xm; 
        E(N + 1) = Tol + 1;
        error = E(N + 1);
        while error > Tol && fe ~= 0 && N < niter
            if fi * fe < 0
                xs = xm;
                fs = eval(subs(f, xs));
            else
                xi = xm;
                fi = eval(subs(f, xi));
            end
            xa = xm;
            xm = (xi + xs) / 2;
            fm(N + 2) = eval(subs(f, xm));
            fe = fm(N + 2);
            N_list(N + 2) = N + 1; 
            xn_list(N + 2) = xm; 
            if strcmp(tipe, 'Cifras Significativas')
                E(N + 2) = abs(xm - xa)/abs(xm);
            else
                E(N + 2) = abs(xm - xa);
            end
            error = E(N + 2);
            N = N + 1;
        end
        if fe == 0
           xn = xm;
           r= sprintf('%f es raiz de f(x)', xm) 
        elseif error < Tol
           xn = xm;
           r= sprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f', xm, Tol)
        else 
           xn = xm;
           r= sprintf('Fracasó en %f iteraciones', niter) 
        end
    else
       r= sprintf('El intervalo es inadecuado')         
    end

    N = N_list; 
    xn = xn_list;

    currentDir = fileparts(mfilename('fullpath'));

    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    mkdir(tablesDir);
    cd(tablesDir);
    csv_file_path = fullfile(tablesDir, 'tabla_biseccion.csv');
    T = table(N', xn', fm', E', 'VariableNames', {'Iteration', 'xn', 'fxn', 'E'}); 
    writetable(T, csv_file_path);


    fig = figure('Visible', 'off');
    xplot = linspace(min(xn) - 5, max(xn) + 5, 1000);
    hold on
    yline(0);
    plot(xplot, eval(subs(f, xplot)));
    scatter(xn(end), f(xn(end)), 'r', 'filled'); 
    img = getframe(gcf);
    staticDir = fullfile(currentDir, '..', 'app', 'static');
    mkdir(staticDir);
    imgPath = fullfile(staticDir, 'grafica_biseccion.png');
    imwrite(img.cdata, imgPath);
    
    hold off
    close(fig);
end