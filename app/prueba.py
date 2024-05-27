import matlab.engine
import os

separador = os.path.sep
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir = separador.join(dir_actual.split(separador)[:-1])+'\matlab'

def biseccion(f, xi, xs, tol, niter, tipe):
    eng = matlab.engine.start_matlab()
    eng.addpath(dir)
    r, N, xn, fm, E = eng.biseccion(f, xi, xs, tol, niter, tipe, nargout=5)
    eng.quit()
    return r, N, xn, fm, E

if __name__ == "__main__":
    func = '-7*log(x)+x-13'
    xi = -5
    xs = 40
    Tol = 0.5e-5
    niter = 100
    tipe= 'Decimales Correctos'

    r, N, xn, fm, E = biseccion(func, xi, xs, Tol, niter, tipe)

    print("r:", r)
    print("N:", N)
    print("xn:", xn)
    print("fm:", fm)
    print("E:", E)