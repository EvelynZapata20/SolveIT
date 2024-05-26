@echo off
rem Ruta al intérprete de Python 3.9
set PYTHON_EXE=C:\Users\admin\AppData\Local\Programs\Python\Python38\python.exe

rem Ruta al script de Flask
set FLASK_APP=C:\Users\smcardonav\Documents\Metodos_Numericos_Final\Metodos_Numericos\app.py

rem Cambiar al directorio de tu proyecto
cd C:\Users\smcardonav\Documents\Metodos_Numericos_Final\Metodos_Numericos\

rem Ejecutar Flask con el intérprete de Python 3.9
%PYTHON_EXE% -m flask --app app.app --debug run
