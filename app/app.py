from flask import Flask, render_template

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

# EJECUCIÓN
if __name__ == '__main__':
    app.run(debug=True)
