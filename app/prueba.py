import matlab.engine
import os

separador = os.path.sep
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir = separador.join(dir_actual.split(separador)[:-1])+'\matlab'

def biseccion(func, xi, xs, Tol, niter):
    eng = matlab.engine.start_matlab()
    eng.addpath(dir)
    T, s, E, fm = eng.Biseccion(func, xi, xs, Tol, niter, nargout=4)
    eng.quit()
    return T, s, E, fm

if __name__ == "__main__":
    func = 'log(sin(x)^2 + 1)-(1/2)'
    xi = 0
    xs = 1
    Tol = 1e-6
    niter = 100

    T, s, E, fm = biseccion(func, xi, xs, Tol, niter)

    print("T:", T)
    print("s:", s)
    print("E:", E)
    print("fm:", fm)