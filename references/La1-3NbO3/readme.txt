for a comprehensive description of all configurations refer to the main manuscript

folders X20, X50 and X90 represent a concentration of La in Sr1-xLa2x/3TiO3 

for each concentration of La, 3 arrangements of La were studied, lasr, lav and rand

in each of these folders, there are 2 files needed to run LAMMPS:

1) input.lmp
2) data.lmp

all simulations were run on ARCHER (UK), on 96 processors

for each arrangement, the system was simulated at 500, 700, 900, 1100 and 1300K

in input.lmp, change "variable T equal" to the corresponding temperature

once this simulation has finished, you will need to restart it by setting the variables "Ep" and "Ev" to 0 in input.lmp, then rename new_data.lmp to data.lmp, also move flux.txt to a different location
this will restart the calculation which is continuous as velocities will not be reset, a new flux.txt will be generated which can be appended to the previous flux.txt and analysed