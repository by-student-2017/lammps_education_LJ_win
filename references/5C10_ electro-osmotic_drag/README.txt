Supporting Information for:

Electro-osmotic Drag and Thermodynamic Properties of Water in Hydrated Nafion Membranes from Molecular Dynamics

by

Ahmadreza Rahbari, Remco Hartkamp, Othonas A. Moultos, Albert Bos, Leo J. P. van den Broeke, Mahinder Ramdin, David Dubbeldam, Alexey V. Lyulin,
Thijs J. H. Vlugt

email: t.j.h.vlugt@tudelft.nl


Example input files for LAMMPS. 

The Nafion system includes 800 water molecules, 200 hydronium ions, and 20 Nafion chains, with an average box size of 57 Angstrom. The system is equilibrated at 330 K and 1 bar. After equilibration, simulations are continued in the NVT ensemble.

The files include:

1 Simulation input file:
simulation.in: includes typical LAMMPS commands for performing simulations for the Nafion system. The LAMMPS commands are limited to the example. For additional commands, the user is referred to the LAMMPS manual.

3 starting configurations are provided:
-data.no.efield: LAMMPS data file equilibrated in the NPT and NVT ensemble without imposing an electric field.
-data.efield_25_ns: LAMMPS data file after performing simulation from the pervious configuration (data.no.efield) for 25 nanoseconds with an electric field of 0.02 V/Angstrom along the x-axis.
-data.efield_75_ns: LAMMPS data file after performing simulation from the pervious configuration (data.no.efield) for 75 nanoseconds with an electric field of 0.02 V/Angstrom along the x-axis.

Note that simulations in which the electric field are imposed are only performed in the NVT ensemble. 
