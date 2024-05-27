%Spline: Calcula los coeficienetes de los polinomios de interpolación de
% grado d (1, 2, 3) para el conjunto de n datos (x,y), 
% mediante el método spline.
function [Tabla] = spline(x,y,d)
    x = eval(x);
    y = eval(y);
    n=length(x);
    A=zeros((d+1)*(n-1));
    b=zeros((d+1)*(n-1),1);
    cua=x.^2;
    cub=x.^3;
    
    %% lineal
    if d==1
        c=1;
        h=1;
        for i=1:n-1
            A(i,c)=x(i);
            A(i,c+1)=1;
            b(i)=y(i);
            c=c+2;
            h=h+1;
        end
        
        c=1;
        for i=2:n
            A(h,c)=x(i);
            A(h,c+1)=1;
            b(h)=y(i);
            c=c+2;
            h=h+1;
        end
    %% Cuadratic
    elseif d==2
        c=1;
        h=1;
        for i=1:n-1
            A(i,c)=cua(i);
            A(i,c+1)=x(i);
            A(i,c+2)=1;
            b(i)=y(i);
            c=c+3;
            h=h+1;
        end
        
        c=1;
        for i=2:n
            A(h,c)=cua(i);
            A(h,c+1)=x(i);
            A(h,c+2)=1;
            b(h)=y(i);
            c=c+3;
            h=h+1;
        end
        
        c=1;
        for i=2:n-1
            A(h,c)=2*x(i);
            A(h,c+1)=1;
            A(h,c+3)=-2*x(i);
            A(h,c+4)=-1;
            b(h)=0;
            c=c+4;
            h=h+1;
        end
        
        A(h,1)=2;
        b(h)=0;
        
  %% Cubic
    elseif d==3
        c=1;
        h=1;
        for i=1:n-1
            A(i,c)=cub(i);
            A(i,c+1)=cua(i);
            A(i,c+2)=x(i);
            A(i,c+3)=1;
            b(i)=y(i);
            c=c+4;
            h=h+1;
        end
        
        c=1;
        for i=2:n
            A(h,c)=cub(i);
            A(h,c+1)=cua(i);
            A(h,c+2)=x(i);
            A(h,c+3)=1;
            b(h)=y(i);
            c=c+4;
            h=h+1;
        end
        
        c=1;
        for i=2:n-1
            A(h,c)=3*cua(i);
            A(h,c+1)=2*x(i);
            A(h,c+2)=1;
            A(h,c+4)=-3*cua(i);
            A(h,c+5)=-2*x(i);
            A(h,c+6)=-1;
            b(h)=0;
            c=c+4;
            h=h+1;
        end
        
        c=1;
        for i=2:n-1
            A(h,c)=6*x(i);
            A(h,c+1)=2;
            A(h,c+4)=-6*x(i);
            A(h,c+5)=-2;
            b(h)=0;
            c=c+4;
            h=h+1;
        end
        
        A(h,1)=6*x(1);
        A(h,2)=2;
        b(h)=0;
        h=h+1;
        A(h,c)=6*x(end);
        A(h,c+1)=2;
        b(h)=0;
    end

    val = A\b; % Cambiado a `\` para mayor estabilidad numérica
    Tabla = reshape(val, d+1, n-1)';

    % Exportar la tabla a un archivo CSV
    csv_file_path = "app/tables/tabla_spline.csv";
    writematrix(Tabla, csv_file_path);

    % Graficar los resultados
    fig = figure('Visible', 'off');
    hold on;
    plot(x, y, 'ro', 'MarkerFaceColor', 'r'); % Puntos originales
    
    for i = 1:n-1
        xx = linspace(x(i), x(i+1), 100);
        if d == 1
            yy = Tabla(i,1)*xx + Tabla(i,2);
        elseif d == 2
            yy = Tabla(i,1)*xx.^2 + Tabla(i,2)*xx + Tabla(i,3);
        elseif d == 3
            yy = Tabla(i,1)*xx.^3 + Tabla(i,2)*xx.^2 + Tabla(i,3)*xx + Tabla(i,4);
        end
        plot(xx, yy, 'b-');
    end
    title('Interpolación Spline');
    xlabel('x');
    ylabel('y');
    img = getframe(gcf);
    imwrite(img.cdata, 'app/static/grafica_spline.png');
    hold off
    close(fig);
end
    
    
