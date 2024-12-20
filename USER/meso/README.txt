This directory contains input scripts for performing 
simulations with these models:

eDPD - energy-conserving dissipative particle dynamics
mDPD - many-body dissipative particle dynamics
tDPD - transport dissipative particle dynamics

1) eDPD: The input script in.mdpd is an example simulation of
measuring the thermal conductivity by heat conduction analog of
periodic Poiseuille flow. The initial eDPD system is randomly filled
by many eDPD particles, and a set command "edpd/temp" gives the
initial temperature and a set command "edpd/cv" gives the heat
capacity of eDPD particles. A non-contact heat source/sink term is
applied by a fix command "edpd/source". A compute command
"edpd/temp/atom" obtain the temperature on each eDPD particle.  The
simulation will generate a file named "temp.profile" showing the
temperature profile. For details please see online LAMMPS
documentation and Fig.12 in the paper Z. Li, et al. J Comput Phys,
2014, 265: 113-127. DOI: 10.1016/j.jcp.2014.02.003

2) mDPD: The input script "in.mdpd" is an example simulation of
oscillations of a free liquid droplet. The initial configuration is a
liquid film whose particles are in a fcc lattice created by the
command "create atoms". Then the liquid film has a tendency to form a
spherical droplet under the effect of surface tension.  For details
please see online LAMMPS documentation and the paper Z. Li, et
al. Phys Fluids, 2013, 25: 072103. DOI: 10.1063/1.4812366

3) tDPD: The input script in.tdpd is an example simulation of
computing the effective diffusion coefficient of a tDPD system using a
method analogous to the periodic Poiseuille flow. Command "atom_style
tdpd 2" specifies the tDPD system with two chemical species. The
initial tDPD system is randomly filled by many tDPD particles, and a
set "cc" command gives initial concentration for each chemical
species. Fix commands "tdpd/source" add source terms and compute
commands "tdpd/cc/atom" obtain the chemical concentration on each tDPD
particle. The simulation will generate a file named "cc.profile"
showing the concentration profiles of the two chemical species. For
details please see online LAMMPS documentation and Fig.1 in the paper
Z. Li, et al. J Chem Phys, 2015, 143: 014101. DOI: 10.1063/1.4923254
