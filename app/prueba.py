import matlab.engine
import os

separador = os.path.sep
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir = separador.join(dir_actual.split(separador)[:-1])+'\matlab'

def biseccion(f, xi, xs, tol, niter):
    eng = matlab.engine.start_matlab()
    eng.addpath(dir)
    r, N, xn, fm, E = eng.biseccion(f, xi, xs, tol, niter, nargout=5)
    eng.quit()
    return r, N, xn, fm, E

if __name__ == "__main__":
    func = 'x^2 - 4^x - 10'
    xi = -5
    xs = 5
    Tol = 1e-6
    niter = 100

    r, N, xn, fm, E = biseccion(func, xi, xs, Tol, niter)

    print("r:", r)
    print("N:", N)
    print("xn:", xn)
    print("fm:", fm)
    print("E:", E)