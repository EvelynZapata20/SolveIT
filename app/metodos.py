import os
import matlab.engine
from flask import Flask, render_template, request, send_file
import pandas as pd

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


# EJECUCIÓN
if __name__ == '__main__':
    app.run(debug=True)
