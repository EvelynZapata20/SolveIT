import os
import matlab.engine
from flask import Flask, render_template, request, jsonify

eng = matlab.engine.start_matlab()

app = Flask(__name__)

import numpy as np

@app.route('/', methods=['GET', 'POST'])
def punto_fijo():
    if request.method == 'POST':
            f= str(request.form['f']) 
            g= str(request.form['g'])
            x = float(request.form['x'])  
            tol = float(request.form['tol'])
            niter = int(request.form['niter'])
            
            eng.addpath(r'C:\Users\Eve\Desktop\Proyecto_Análisis\matlab')
            [N, xn, fm, E]= eng.pf(f, g, x, tol, niter, nargout=4)
            N, xn, fm, E = list(N[0]), list(xn[0]), list(fm[0]), list(E[0])
            length = len(N)
            return render_template('resultado.html', N=N, xn=xn, fm=fm, E=E, length=length)
        
    return render_template('formulario_pf.html')

if __name__ == '__main__':
    app.run(debug=True)
