## Title:   Optimizing Non-bonded Interactions of the OPLS Force Field for Aqueous Solutions of Carbohydrates
## Authors: Jamali, S. H., van Westen, T., Moultos, O. A., and Vlugt, T. J. H.
## Journal: Journal of Chemical Theory and Computation
## Date:    26-10-2018 
## Purpose: Computing the density of aqueous carbohydrate solutions with a mass fraction of 50%

The current directory contains two subdirectories, consisting the
LAMMPS input files for aqueous solutions of glucose ("w_glucose_50")
and sucrose ("w_sucrose_50"). The mass fractions of carbohydrates for
both systems are 50%. The temperature and pressure are 298 K and 1
atm, respectively.

In each directory, there are three files: "data.system",
"forcefield.data", and "simulation.in". The file "data.system"
contains the information on the positions and bonds of all atoms in a
simulation box. This initial configuration is made using Packmol and
the final LAMMPS input file is made by using VMD.

The file "forcefield.data" includes all the force field parameters to
define the bonded and nonbonded interactions between the atoms. The
optimized OPLS force field with a scaled LJ energy parameters of 0.8
and a scaled partial atomic charges of 0.95 is used in the force field
files.

The file "simulation.in" is the file that should be input to
LAMMPS. In this file, all simulation details are implemented and MD
simulations are performed accordingly. These simulation files define
the calculation of the density of the aqueous carbohydrate systems
mentioned above in the NPT ensemble.
