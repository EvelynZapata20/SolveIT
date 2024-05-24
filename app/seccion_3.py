from flask import Blueprint, render_template, request, send_file
import os, json, csv
import matlab.engine
import pandas as pd
import numpy as np

blueprint = Blueprint('seccion_3', __name__)

eng = matlab.engine.start_matlab()

separador = os.path.sep 
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir_matlab = separador.join(dir_actual.split(separador)[:-1])+'\matlab'
dir_tables = os.path.join(dir_actual, 'tables')

eng.addpath(dir_matlab)

@blueprint.route('/lagrange', methods=['POST', 'GET'])
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
        return render_template('Seccion_3/resultado_lagrange.html',respuesta=polinomio, data=data, imagen_path=imagen_path)
        
    return render_template('Seccion_3/lagrange.html')

@blueprint.route('/lagrange/descargar', methods=['POST'])
def descargar_archivoLagrange():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_lagrange.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

@blueprint.route('/newtonint', methods=['POST', 'GET'])
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
        return render_template('Seccion_3/resultado_newtonint.html',respuesta=polinomio, data=data, imagen_path=imagen_path)
        
    return render_template('Seccion_3/newtonint.html')

@blueprint.route('/newtonint/descargar', methods=['POST'])
def descargar_archivoNewtonInt():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_newtonInt.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)