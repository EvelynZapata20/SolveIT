from flask import Blueprint, render_template, request, send_file
import os, json, csv
import matlab.engine
import pandas as pd
import numpy as np

blueprint = Blueprint('seccion_2', __name__)

eng = matlab.engine.start_matlab()

separador = os.path.sep 
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir_matlab = separador.join(dir_actual.split(separador)[:-1])+'\matlab'
dir_tables = os.path.join(dir_actual, 'tables')

eng.addpath(dir_matlab)

#Método de Gauss-Seidel
@blueprint.route('/gaussSeidel', methods=['GET', 'POST'])
def gaussSeidel():
    if request.method == 'POST':
        A = request.form['A']
        b = str(request.form['b'])  
        x = str(request.form['x']) 
        et = str(request.form['et']) 
        tol = float(request.form['tol'].replace(',', '.'))
        niter = int(request.form['niter'])
        

        eng.addpath(dir_matlab)
        [r, N, xn, E, re] = eng.gaussSeidel(x ,A ,b ,et ,tol ,niter , nargout=5)
        N, E = list(N[0]), list(E[0])
        length = len(N)


        df = pd.read_csv(os.path.join(dir_tables, 'tabla_gaussSeidel.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'tabla_gaussSeidel.xlsx'), index=False) 

        # Lee el archivo CSV

        # Escribe los datos en un nuevo archivo Excel

        #Gráfica
        imagen_path = '../static/grafica_gaussSeidel.png'  # Ruta de la imagen
        return render_template('Seccion_2/resultado_gaussSeidel.html', r=r, N=N, xn=xn, E=E, Re=re, length=length, data=data, imagen_path=imagen_path)
    
    return render_template('Seccion_2/formulario_gaussSeidel.html')

@blueprint.route('/gaussSeidel/descargar', methods=['POST'])
def descargar_archivo_gaussSeidel():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_gaussSeidel.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

#Método de Jacobi
@blueprint.route('/jacobi', methods=['GET', 'POST'])
def jacobi():
    if request.method == 'POST':
        A = request.form['A']
        b = str(request.form['b'])  
        x = str(request.form['x']) 
        error_type = str(request.form['error_type']) 
        tol = float(request.form['tol'].replace(',', '.'))
        niter = int(request.form['niter'])
        

        eng.addpath(dir_matlab)
        [r, N, xn, E, Re] = eng.jacobi(x ,A ,b , tol ,niter , error_type, nargout=5)
        N, E = list(N[0]), list(E[0])
        length = len(N)

        df = pd.read_csv(os.path.join(dir_tables, 'tabla_jacobi.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'tabla_jacobi.xlsx'), index=False) 

        imagen_path = os.path.join('static', 'grafica_jacobi.png')

        return render_template('Seccion_2/resultado_jacobi.html', r=r, N=N, xn=xn, E=E, Re=Re, length=length, data=data, imagen_path=imagen_path)
    
    return render_template('Seccion_2/formulario_jacobi.html')


@blueprint.route('/jacobi/descargar', methods=['POST'])
def descargar_archivo_jacobi():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_jacobi.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)


#Método de sor
@blueprint.route('/sor', methods=['GET', 'POST'])
def sor():
    if request.method == 'POST':
        x0 = str(request.form['x'])
        A = request.form['A']
        b = str(request.form['b'])
        Tol = float(request.form['tol'].replace(',', '.'))
        niter = int(request.form['niter'])
        w = float(request.form['w'].replace(',', '.'))
        tipe = str(request.form['et']) 
        
        eng.addpath(dir_matlab)
        # Llamar a la función SOR
        [r, n, xi, E, radio] = eng.SOR(x0, A, b, Tol, niter, w, tipe, nargout=5)
        n, E = list(n[0]), list(E[0])
        xi = [[xi[j][i] for j in range(len(xi))] for i in range(len(xi[0]))]
        length = len(n)

        df = pd.read_csv(os.path.join(dir_tables, 'tabla_sor.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'tabla_sor.xlsx'), index=False) 

        imagen_path = '../static/grafica_sor.png'  # Ruta de la imagen
        # Renderizar la plantilla HTML con la tabla y el resultado
        return render_template('Seccion_2/resultado_sor.html', r=r, n=n, xi=xi, E=E, radio=radio, length=length, data=data, imagen_path=imagen_path)
    return render_template('Seccion_2/formulario_sor.html')

@blueprint.route('/sor/descargar', methods=['POST'])
def descargar_archivo_sor():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_sor.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

