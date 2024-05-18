import os
import matlab.engine
from flask import Flask, render_template, request, send_file,jsonify
import pandas as pd
import json
import csv

eng = matlab.engine.start_matlab()
app = Flask(__name__)

# Obtener la ruta absoluta del directorio 'matlab'
separador = os.path.sep 
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir_matlab = separador.join(dir_actual.split(separador)[:-1])+'\matlab'
dir_tables = os.path.join(dir_actual, 'tables')

eng.addpath(dir_matlab)

# HOME
@app.route('/')
def home():
    return render_template('home.html')

# SECCIÓN 1

# Método del punto fijo
@app.route('/punto_fijo', methods=['GET', 'POST'])
def punto_fijo():
    if request.method == 'POST':
        f = str(request.form['f']) 
        g = str(request.form['g'])
        x = float(request.form['x'])  
        tol = float(request.form['tol'])
        niter = int(request.form['niter'])
        
        [r, N, xn, fm, E] = eng.pf(f, g, x, tol, niter, nargout=5)
        N, xn, fm, E = list(N[0]), list(xn[0]), list(fm[0]), list(E[0])
        length = len(N)

        df = pd.read_csv(os.path.join(dir_tables, 'tabla_pf.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'tabla_pf.xlsx'), index=False) 

        imagen_path = os.path.join('static', 'grafica_pf.png')

        return render_template('resultado_pf.html', r=r, N=N, xn=xn, fm=fm, E=E, length=length, data=data, imagen_path=imagen_path)

    return render_template('formulario_pf.html')

@app.route('/pf/descargar', methods=['POST'])
def descargar_archivo_pf():
    archivo_path = os.path.join(dir_tables, 'tabla_pf.xlsx')
    return send_file(archivo_path, as_attachment=True)


# Método de Bisección
@app.route('/biseccion', methods=['GET', 'POST'])
def biseccion():
    if request.method == 'POST':
        f = str(request.form['f']) 
        xi = float(request.form['xi'])
        xs = float(request.form['xs'])  
        tol = float(request.form['tol'])
        niter = int(request.form['niter'])
        
        [r, N, xn, fm, E] = eng.biseccion(f, xi, xs, tol, niter, nargout=5)
        N, xn, fm, E = list(N[0]), list(xn[0]), list(fm[0]), list(E[0])
        length = len(N)

        df = pd.read_csv(os.path.join(dir_tables, 'tabla_biseccion.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'tabla_biseccion.xlsx'), index=False) 

        imagen_path = os.path.join('static', 'grafica_biseccion.png')

        return render_template('resultado_biseccion.html', r=r, N=N, xn=xn, fm=fm, E=E, length=length, data=data, imagen_path=imagen_path)

    return render_template('formulario_biseccion.html')

@app.route('/biseccion/descargar', methods=['POST'])
def descargar_archivo_biseccion():
    archivo_path = os.path.join(dir_tables, 'tabla_biseccion.xlsx')
    return send_file(archivo_path, as_attachment=True)


#Método de raíces múltiples
@app.route('/multiple_roots', methods=['GET', 'POST'])
def multiple_roots():
    if request.method == 'POST':
        fn = str(request.form['fn'])
        xi = float(request.form['xi'])
        tol = float(request.form['tol'])
        k = int(request.form['k'])
        et = str(request.form['et'])

        eng.addpath(dir_matlab)
        # Asume que multiple_roots retorna los valores necesarios o guarda los resultados en un archivo CSV
        eng.raices_multiples(fn, xi, tol, k, et, nargout=0)  # Ejecuta el cálculo en MATLAB
        
        # Lee los resultados de un archivo CSV (asegúrate de que tu función MATLAB los guarde correctamente)
        df = pd.read_csv(os.path.join(dir_tables, 'multiple_roots_results.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'multiple_roots_results.xlsx'), index=False)

        imagen_path = os.path.join('static', 'grafica_multiple_roots.png')

        return render_template('resultado_raicesm.html', data=data, imagen_path=imagen_path)
    
    return render_template('formulario_raicesm.html')

@app.route('/rm/descargar', methods=['POST'])
def descargar_archivo_raicesm():
    archivo_path = os.path.join(dir_tables, 'multiple_roots_results.xlsx')
    return send_file(archivo_path, as_attachment=True)


#Método de la secante
@app.route('/secante', methods=['GET', 'POST'])
def secante():
    if request.method == 'POST':
        f= str(request.form['f']) 
        x0 = float(request.form['x0'])
        x1 = float(request.form['x1'])  
        tol = float(request.form['tol'])
        Terror = int(request.form['Terror'])
        niter = int(request.form['niter'])
        
        eng.addpath(dir_matlab)

        respuesta = eng.secante(f, x0, x1, tol, niter, Terror)
        df = pd.read_csv('tables/tabla_secante.csv')
        df = df.astype(str)
        data = df.to_dict(orient='records')

        # Lee el archivo CSV
        df = pd.read_csv('tables/tabla_secante.csv')
        # Escribe los datos en un nuevo archivo Excel
        df.to_excel('tables/tabla_secante.xlsx', index=False) 

        #Gráfica
        imagen_path = '../static/grafica_secante.png'  # Ruta de la imagen
        return render_template('resultado_secante.html',respuesta=respuesta, data=data,imagen_path=imagen_path)
        
    return render_template('formulario_secante.html')

@app.route('/secante/descargar', methods=['POST'])
def descargar_archivo():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_secante.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)


#Método de regla falsa
@app.route('/rf', methods=['GET', 'POST'])
def reglaFalsa():
    if request.method == 'POST':
        f= str(request.form['f']) 
        x0 = float(request.form['x0'])
        x1 = float(request.form['x1'])  
        tol = float(request.form['tol'])
        Terror = int(request.form['Terror'])
        niter = int(request.form['niter'])
        
        eng.addpath(dir_matlab)

        respuesta = eng.rf(f, x0, x1, tol, niter, Terror)
        print(respuesta[0])
        df = pd.read_csv('tables/tabla_reglaFalsa.csv')
        df = df.astype(str)
        data = df.to_dict(orient='records')

        # Lee el archivo CSV
        df = pd.read_csv('tables/tabla_reglaFalsa.csv')
        # Escribe los datos en un nuevo archivo Excel
        df.to_excel('tables/tabla_reglaFalsa.xlsx', index=False) 

        #Gráfica
        imagen_path = '../static/grafica_reglaFalsa.png'  # Ruta de la imagen
        return render_template('resultado_reglaFalsa.html',respuesta=respuesta, data=data,imagen_path=imagen_path)
        
    return render_template('formulario_reglaFalsa.html')

@app.route('/rf/descargar', methods=['POST'])
def descargar_archivorf():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_reglaFalsa.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

@app.route('/lagrange', methods=['POST', 'GET'])
def lagrange():
    if request.method == 'POST':
    
        x = json.loads(request.form['vectorx'])
        y = json.loads(request.form['vectory'])
        
        eng.addpath(dir_matlab)
        
        matx = matlab.double(x)
        maty = matlab.double(y)
        
        respuesta = eng.lagrange(matx, maty)
        print("respuesta",respuesta)

        df = pd.read_csv('tables/tabla_lagrange.csv')
        polinomio = df['Polinomio'][0]
          
        data = df.to_dict(orient='records')
        #print("data",data)

        df.to_excel('tables/tabla_lagrange.xlsx', index=False)

        # Gráfica
        imagen_path = '../static/grafica_lagrange.png'  # Ruta de la imagen
        return render_template('resultado_lagrange.html',respuesta=polinomio, data=data, imagen_path=imagen_path)
        
    return render_template('lagrange.html')

@app.route('/lagrange/descargar', methods=['POST'])
def descargar_archivoLagrange():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_lagrange.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

@app.route('/newtonint', methods=['POST', 'GET'])
def newtonint():
    if request.method == 'POST':
    
        x = json.loads(request.form['vectorx'])
        y = json.loads(request.form['vectory'])
        print(x)
        print(y)
        
        eng.addpath(dir_matlab)
        
        matx = matlab.double(x)
        maty = matlab.double(y)
        
        respuesta = eng.Newtonint(matx, maty)
        print("respuesta",respuesta)

        df = pd.read_csv('tables/tabla_polnewton.csv')
        polinomio = df['Polinomio'][0]
          
        data = pd.read_csv('tables/tabla_newtonint.csv')

        # Escribe los datos en un nuevo archivo Excel
        data.to_excel('tables/tabla_newtonint.xlsx', index=False) 

        with open('tables/tabla_newtonint.csv', 'r') as file:
            csv_reader = csv.reader(file)
            data = list(csv_reader)

        # Gráfica
        imagen_path = '../static/grafica_newtonint.png'  # Ruta de la imagen
        return render_template('resultado_newtonint.html',respuesta=polinomio, data=data, imagen_path=imagen_path)
        
    return render_template('newtonint.html')

@app.route('/newtonint/descargar', methods=['POST'])
def descargar_archivoNewtonInt():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_newtonInt.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)


#Método de newton
@app.route('/newton', methods=['GET', 'POST'])
def newton():
    if request.method == 'POST':
        f= str(request.form['f']) 
        x = float(request.form['x'])  
        tol = float(request.form['tol'])
        niter = int(request.form['niter'])

        eng.addpath(dir_matlab)
        [r, N, xn, fm, dfm, E] = eng.newton(f, x, tol, niter, nargout=6)
        N, xn, fm, dfm, E = list(N[0]), list(xn[0]), list(fm[0]), list(dfm[0]), list(E[0])
        length = len(N)


        df = pd.read_csv(os.path.join(dir_tables, 'tabla_newton.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'tabla_newton.xlsx'), index=False) 

        # Lee el archivo CSV

        # Escribe los datos en un nuevo archivo Excel

        #Gráfica
        imagen_path = '../static/grafica_newton.png'  # Ruta de la imagen
        return render_template('resultado_newton.html', r=r, N=N, xn=xn, fm=fm, dfm=dfm, E=E, length=length, data=data, imagen_path=imagen_path)
    
    return render_template('formulario_newton.html')

@app.route('/newton/descargar', methods=['POST'])
def descargar_archivo_newton():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_newton.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)


#Método de Gauss-Seidel
@app.route('/gaussSeidel', methods=['GET', 'POST'])
def gaussSeidel():
    if request.method == 'POST':
        A = request.form['A']
        b = str(request.form['b'])  
        x = str(request.form['x']) 
        et = str(request.form['et']) 
        tol = float(request.form['tol'])
        niter = int(request.form['niter'])
        

        eng.addpath(dir_matlab)
        [r, N, xn, E] = eng.gaussSeidel(x ,A ,b ,et ,tol ,niter , nargout=4)
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
        return render_template('resultado_gaussSeidel.html', r=r, N=N, xn=xn, E=E, length=length, data=data, imagen_path=imagen_path)
    
    return render_template('formulario_gaussSeidel.html')

@app.route('/gaussSeidel/descargar', methods=['POST'])
def descargar_archivo_gaussSeidel():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_gaussSeidel.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

# EJECUCIÓN
if __name__ == '__main__':
    app.run(debug=True)
