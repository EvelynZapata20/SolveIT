function [r, N, xn, fm, dfm, E] = newton(f_str, x0, Tol, niter)
    syms x
    f = str2sym(['@(x)' f_str]);
    df = diff(f);
    c = 0;
    fm(c+1) = eval(subs(f, x0));
    fe = fm(c+1);
    dfm(c+1) = eval(subs(df, x0));
    dfe = dfm(c+1);
    E(c+1) = Tol + 1;
    error = E(c+1);
    xn(c+1) = x0;
    N(c+1) = c;
    while error > Tol && c < niter
        xn(c+2) = x0 - fe / dfe;
        fm(c+2) = eval(subs(f, xn(c+2)));
        fe = fm(c+2);
        dfm(c+2) = eval(subs(df, xn(c+2)));
        dfe = dfm(c+2);
        E(c+2) = abs(xn(c+2) - x0);
        error = E(c+2);
        x0 = xn(c+2);
        N(c+2) = c+1;
        c = c + 1;
    end
    if fe == 0
       r = sprintf('%f es raiz de f(x) \n', x0)
    elseif error < Tol
       r = sprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f \n', x0, Tol)
    elseif dfe == 0
       r = sprintf('%f es una posible raiz múltiple de f(x) \n', x0)
    else 
       r = sprintf('Fracasó en %f iteraciones \n', niter) 
    end

    T = table(N', xn', fm', E', 'VariableNames', {'Iteration', 'xn', 'fxn', 'E'});
      csv_file_path = "app/tables/tabla_newton.csv";
      writetable(T, csv_file_path)

      fig = figure('Visible', 'off');
      xplot=((xn-2):0.1:(xn+2));
      hold on
      yline(0);
      plot(xplot,eval(subs(f,xplot)));
      img = getframe(gcf);
      imwrite(img.cdata, 'app/static/grafica_newton.png');

      hold off
      close(fig);
end