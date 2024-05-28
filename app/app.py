from flask import Flask, render_template, request
import matlab.engine

import app.seccion_1 as seccion_1
import app.seccion_2 as seccion_2
import app.seccion_3 as seccion_3

# Crear la instancia de Flask
app = Flask(__name__)

# Agregar las rutas de cada sección
app.register_blueprint(seccion_1.blueprint)
app.register_blueprint(seccion_2.blueprint)
app.register_blueprint(seccion_3.blueprint)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/ayuda')
def ayuda():
    return render_template('ayuda.html')


@app.route('/derivar', methods=['POST'])
def derivar():
    function_str = request.form['function']
    try:
        function_str = function_str.replace("'", "''")
        eng = matlab.engine.start_matlab()
        cmd = f"syms x; fn = str2sym('{function_str}'); df = diff(fn, x); df_str = char(df);"
        eng.eval(cmd, nargout=0)

        derivative = eng.workspace['df_str']
        
        eng.quit()
        
        result = str(derivative)
    except Exception as e:
        result = f"Error: {e}"
    return render_template('ayuda.html', result=result)


# EJECUCIÓN
if __name__ == '__main__':
    app.run(debug=True)
