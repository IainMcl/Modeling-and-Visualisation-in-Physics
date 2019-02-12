import numpy as np
# cimport numpy as np
import cython
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import sys
from libc.stdlib cimport abs, rand
from libc.math cimport exp

<<<<<<< HEAD
# cdef class Grid:
class Grid:
    # cdef int N, M, steps_per_sweep
    # cdef float J, Kb, T
    # # cdef object anim , fig
    # cpdef object fig
    # cdef np.int64_t[:, :] grid
    # cpdef object __cpinit__(self, int N, int M, float T, float J=1, float Kb=1, all_up=True, anim=True):
    def __init__(self, int N, int M, float T, float J=1, float Kb=1, all_up=True, anim=True):
=======
class Grid:
    def __init__(self, int N, int M, float T, sv_ext, ds=0, float J=1, float Kb=1, all_up=True, anim=True):
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        self.N = N
        self.M = M
        self.J = J
        self.Kb = Kb
        self.T = T
<<<<<<< HEAD
=======
        self.ds = ds
        self.sv_ext = sv_ext
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        self.steps_per_sweep = N * M
        self.anim = anim
        if anim:
            self.fig = plt.figure()
        if all_up:
            self.grid = np.ones((N, M))
        else:
            self.grid = np.random.choice([-1, 1], size=(N, M))

<<<<<<< HEAD
=======
    def init_kaw_grid(self):
        ones = np.ones((int(self.N / 2), self.M))
        neg_ones = ones * -1
        self.grid = np.concatenate((ones, neg_ones))
        # print(self.grid)
        # print(len(self.grid), len(self.grid[0]))
        return self.grid

>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
    def print_grid(self):
        print(self.grid)

    def imshow_grid(self):
<<<<<<< HEAD
        plt.imshow(self.grid, interpolation='None', cmap='Blues', vmin=-1, vmax=1)
=======
        # axcolor = 'lightgoldenrodyellow'
        # axfreq = plt.axes([0.25, 0.1, 0.65, 0.03], facecolor=axcolor)
        plt.imshow(self.grid, interpolation='None', cmap='Blues', vmin=-1, vmax=1)
        # self.T = Slider(axfreq, 'Temperature', 0, 4, valinit=0.8)
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24

    def update_sweep(self, int k):
        cdef int N, M, i, n, m
        N = self.N
        M = self.M
        for i in range(self.steps_per_sweep):
<<<<<<< HEAD
            # self.glauber_dynamics()
            self.kawasaki_dynamics()
=======
            if self.ds == 0:
                self.glauber_dynamics()
            elif self.ds == 1:
                self.kawasaki_dynamics()
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        if self.anim:
            self.fig.clear()
            self.imshow_grid()

<<<<<<< HEAD
    def nn_check(self, n, m, x, y):
=======
    def nn_check(self, int n, int m, int x, int y):

>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        if n == x and (m == y or m == y+1 or m == y-1):
            return True
        elif m == y and (n == x+1 or n == x-1):
            return True
        else:
            return False

    def kawasaki_dynamics(self):
        cdef int total, total2, N, M, x, y
        cdef float dE
        # n = np.random.randint(N)
        # m = np.random.randint(M)
        N = self.N
        M = self.M
        n = rand() % N
        m = rand() % M
        x = rand() % N
        y = rand() % M
        if self.grid[n][m] == self.grid[x][y]:
            return 0
        total = self.sum_spin(n, m, N, M)
        total2 = self.sum_spin(x, y, N, M)
        # cdef float ei = -self.J * self.grid[n][m] * total - self.J * self.grid[x][y] * total2
        # cdef float ef = self.J * self.grid[n][m] * total + self.J * self.grid[x][y] * total2
        if self.nn_check(n, m, x, y):
            # TODO Need to work out what goes on with nn
<<<<<<< HEAD
            dE = 0 # ###############
=======
            total += 2
            total2 += 2
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        else:
            dE = 2 * self.J * (self.grid[n][m]*total + self.grid[x][y]*total2)
        # print(dE)
        if dE <= 0:
            self.grid[n][m] *= -1
            self.grid[x][y] *= -1
        elif np.random.rand() <= self.P(dE):
            self.grid[n][m] *= -1
            self.grid[x][y] *= -1
        return 1


    def glauber_dynamics(self):
        cdef int total, N, M
        # n = np.random.randint(N)
        # m = np.random.randint(M)
        N = self.N
        M = self.M
        n = rand() % N
        m = rand() % M
        total = self.sum_spin(n, m, N, M)
        cdef float dE = 2 * self.J * self.grid[n][m] * total  # Check energy signs
        if dE <= 0:
            self.grid[n][m] *= -1
        elif np.random.rand() <= self.P(dE):
            self.grid[n][m] *= -1

    def sum_spin(self, int n, int m, int N, int M):
        cdef int total = 0
        total += self.grid[(n - 1) % N][m]
        total += self.grid[(n + 1) % N][m]
        total += self.grid[n][(m-1) % M]
        total += self.grid[n][(m+1) % M]
        return total

    @cython.cdivision(True)
    def P(self, float dE):
        cdef float expo
        if self.T == 0:
            return 0
        else:
            expo = exp(-dE / (self.Kb * self.T))
            return expo

<<<<<<< HEAD
    def temperature_tests(self, float t_min=1, float t_max=3, int data_points=20, int sweeps=100, int tests=50, eng=True, mag=True, save=True):
=======
    def temperature_tests(self, float t_min=1, float t_max=2.9, int data_points=20,
                        int sweeps=100, int tests=10000, int sweeps_per_test=10,
                        eng=True, mag=True, save=True):
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        cdef double [:] temperature = np.linspace(t_min, t_max, data_points)
        cdef double [:,:] magnetisation = np.zeros((data_points, tests))
        cdef double [:, :] energy = np.zeros((data_points, tests))
        cdef int i, j
        for i in range(data_points):
            sys.stdout.write("Simulation progress: %.1f%%\r" % (100 * i / data_points))
            sys.stdout.flush()

            self.T = temperature[i]  # Set the temperature of the system.
            self.update_sweep(sweeps)
            for j in range(tests):
<<<<<<< HEAD
                self.update_sweep(10)
=======
                self.update_sweep(sweeps_per_test)
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
                if mag:
                    magnetisation[i][j] = self.sys_magnetisation()
                if eng:
                    energy[i][j] = self.sys_energy()
        if save:
<<<<<<< HEAD
            np.savetxt('temperature.txt', temperature)
            if mag:
                np.savetxt('magnetisation.txt', magnetisation)
            if eng:
                np.savetxt('energy.txt', energy)
=======
            np.savetxt(('temperature'+ self.sv_ext +'.txt'), temperature)
            if mag:
                np.savetxt(('magnetisation'+ self.sv_ext +'.txt'), magnetisation)
            if eng:
                np.savetxt(('energy'+ self.sv_ext +'.txt'), energy)
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24

    def sys_magnetisation(self):
        """
        Magnetisation per data point in the simulation
        :return: <|m|> = |m_i/n|
        """
        cdef int M, mag
        M = np.sum(self.grid)
        # mag = np.abs(M)
        mag = abs(M)
        return mag

    def sys_energy(self):
        # TODO needs to be tested
        cdef int N, M, n, m
        cdef float energy
        # N, M = self.grid.shape
        N = self.N
        M = self.M
        energy = 0
        for n in range(N):
            for m in range(M):
                ne_sum = self.grid[(n + 1) % N][m] + self.grid[n][(m + 1) % M]
                energy += -self.J * self.grid[n][m] * ne_sum  # Check if -J * ... or J * ... same with above in glauber
        return energy

    def susceptibility(self, save=True):
        cdef double [:,:] data
        cdef double [:] temp
<<<<<<< HEAD
        data = np.genfromtxt('magnetisation.txt')
        temp = np.genfromtxt('temperature.txt')
=======
        data = np.genfromtxt(('magnetisation'+ self.sv_ext +'.txt'))
        temp = np.genfromtxt(('temperature'+ self.sv_ext +'.txt'))
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        # cdef double [:] magnetisation, chi
        cdef int x, i
        magnetisation = [np.average(data[x]) for x in range(len(data))]
        chi = np.zeros(len(temp))
        for i in range(len(temp)):
            norm_fact = 1 / (self.N * self.M * self.Kb * temp[i])
            chi[i] = norm_fact * (np.average(np.square(data[i])) - np.square(np.average(data[i])))
        if save:
<<<<<<< HEAD
            np.savetxt('susceptibility.txt', chi)
=======
            np.savetxt(('susceptibility'+ self.sv_ext +'.txt'), chi)
        return chi
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24

    def heat_cap(self, save=True):
        cdef double [:, :] energy
        cdef double [:] C, temp
        cdef int i
        cdef double norm_fact
<<<<<<< HEAD
        data = np.genfromtxt('energy.txt')
        temp = np.genfromtxt('temperature.txt')
=======
        data = np.genfromtxt(('energy'+ self.sv_ext +'.txt'))
        temp = np.genfromtxt(('temperature'+ self.sv_ext +'.txt'))
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24
        magnetisation = [np.average(data[x]) for x in range(len(data))]
        C = np.zeros(len(temp))
        for i in range(len(temp)):
            norm_fact = 1 / (self.N**2 * self.Kb * temp[i]**2)
            C[i] = norm_fact * (np.average(np.square(data[i])) - np.square(np.average(data[i])))
        if save:
<<<<<<< HEAD
            np.savetxt('heat_cap.txt', C)
=======
            np.savetxt(('heat_cap'+ self.sv_ext +'.txt'), C)
        return C

    def bootstarap_errors(self, int k=100, save=True):
        cdef int i, dlen
        cdef double avg, norm_fact
        cdef double [:, :] data
        cdef double [:] heat_cap, temp ,sel_data, h_caps, sigma
        data = np.genfromtxt(('energy'+ self.sv_ext +'.txt'))
        temp = np.genfromtxt(('temperature'+ self.sv_ext +'.txt'))
        dlen = len(data)
        row_len = len(data[0])
        heat_cap = np.zeros(k)
        sigma = np.zeros(dlen)
        for i in range(dlen):
            norm_fact = 1 / (self.N**2 * self.Kb * temp[i]**2)
            for j in range(k):
                sel_data = np.random.choice(data[i], row_len)
                heat_cap[j] = norm_fact * (np.average(np.square(sel_data)) - np.square(np.average(sel_data)))
            sigma[i] = np.sqrt(np.average(np.square(heat_cap)) - np.square(np.average(heat_cap)))
        if save:
            np.savetxt(('sigma_bs' + self.sv_ext + '.txt'), sigma)
        return sigma

    def jacknife_errors(self):
        pass
>>>>>>> 3c9f81b144df78d9439b670211603618f2ae8e24

    def animate(self):
        anim = FuncAnimation(self.fig, self.update_sweep)
        plt.show()
