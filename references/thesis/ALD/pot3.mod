pair_style buck/coul/long 1.0 25.0

pair_coeff 1 1     0.0 1.0     0.0     # Al-Al
pair_coeff 1 2 36820.0 0.78520 0.03400 # Al-O
pair_coeff 1 3 36820.0 0.78520 0.03400 # Al-H
pair_coeff 2 2     0.0 1.0     0.0     #  O-O
pair_coeff 2 3 90610.0 1.82150 0.13800 #  O-H
pair_coeff 3 3     0.0 1.0     0.0     #  H-H

pair_modify table 0

# MD parameters
kspace_style ewald 1.0e-7
neighbor 2.0 bin
neigh_modify delay 0 every 1 check yes page 500000 one 50000
timestep 0.01