import matlab.engine

def biseccion(func, xi, xs, Tol, niter):
    eng = matlab.engine.start_matlab()
    eng.addpath(r'C:\Users\Eve\Desktop\Proyecto_Análisis\matlab')
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