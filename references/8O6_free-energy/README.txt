GROMACS files 
***************************************************************
We have grouped all input files needed to perform the
Einstein molecule (EM) calculations into four ascii files:
  - iceIh_files.txt --> contains the input files to compute the free energy of ice Ih
                        for the Einstein molecule method.
  - iceII_files.txt --> contains the input files to compute the free energy of ice II
                        for the Einstein molecule method.
  - methanol_files.txt --> contains the input files to compute the free energy of methanol
                           for the Einstein molecule method.
  - A0.txt    --> contains the fortran code to evaluate the free energy
                   of the reference system, A0 (the code is prepared for methanol)

!!!WARNING!!!!
In order to perform the Einstein molecule (EM)
calculations you should SPLIT the input files from these ascii files
into the corresponding individual files.
############################################################################################
-------------------
General questions |
-------------------
General information about GROMACS input files.

#To execute GROMACS you need to provide three files
grompp.mdp   Contains the parameters controlling the MD simulation
conf.g96     Provides an initial configuration
topol.top    Contains the Hamiltonian of the system


#Where is defined the strength of the springs ?
The strength of the springs is defined in the topol.top file.
Notice that GROMACS requires k' rather than \Lambda_E'
(remember that k'=2*Lambda_E'). Notice also
that in GROMACS k' should be  given in kJ nm**{-2}.

#Where is defined the location of the origin of the springs?
In the initial configuration !
GROMACS assumes that the origins of the springs are located on the
initial positions of the atoms defined in the conf.g96 file.
For this reason it is absolutely required that the initial configuration is a perfect lattice.
############################################################################################
Example for the Einstein molecule method (EM):
----------------------------------------------

----------------------
Obtaining \Delta A_1 |
----------------------
Create deltaa1/ folder.
You are going to need the following input files:
topol.ideal
topol.real
grompp.mdp
conf.g96
these can be found in the XXXXX_files.txt file (XXXXX = system: iceIh, iceII or methanol).

Do the following :

1) Using topol_ideal.top and grompp.mdp, perform an MD simulation
   of an ideal system of springs.

2) Extract energies from the GROMACS trajectory file (i.e. traj.xtc) --> u_sol_{i}
   where {i} corresponds to each configuration.
   This can be done by extracting one-by-one the configurations stored
   into the trajectory file, and then carrying out a "false" simulation
   (in which you set up just one MD step and a 0.0 time step) using the
   real Hamiltonian (topol.real).

3) Evaluate the U_lattice energy --> u_latt.
   Using again this "false" simulation; in which the initial configuration
   corresponds to a perfect lattice.  

4) Compute \Delta A_1

	- Convert u_sol_{i} and u_latt energies from GROMACS units to kT units:
	  [i.e. u_sol_{i}*1000/(R*T)]

	- Compute u_sol_{i} - u_latt.
	  \sum_{0}^{N_confs} u_sol_{i} - u_latt

	- Compute the exponential of minus u_sol_{i} - u_latt --> exp[-(u_sol_{i} - u_latt)] 

	- Compute the average --> <P> = \sum_{0}^{N_confs} exp[-(u_sol_{i} - u_latt)]

	- Compute the neperian logarithm of the average and divide by the number of molecules:
	  \DA_1 / NkT = 1/N ln[<P>]

----------------------
Obtaining \Delta A_2 |
----------------------

Create deltaa2/ folder.
You are going to need the following input files:
topol.real
grompp.mdp
landas.dat
conf.g96
these can be found in the XXXXX_files.txt file (XXXXX = system: iceIh, iceII or methanol)

- landas.dat --> contains the 16 k' values (kJ nm**{-2}) with which evaluate the integral of \Delta A_2.
                 We have used Gaussian quadrature method to evaluate the integral of Eq.(39)
                 of [C.Vega et al., J. Phys. Cond. Matt., 20, 153101 (2008)] with c=exp(3.5)
                 (see also Ref. [Understanding Molecular Simulation of D. Frenkel and B. Smit,
                 second Edition, page 260]).

- topol.real --> contains the definition of the system's Hamiltonian: i.e
                 the TIP4P/2005 water potential with harmonic springs of strength k'.

1) Perform as many MD simulations as k' values you are going to use to evaluate \Delta A_2.
   For each simulation, use the corresponding k' values.
   Remember that k' must be included in GROMACS units (kJ nm**{-2}).

2) From each simulation extract the harmonic energy average --> <U_pos-res> (GROMACS units)

3) Convert <U_pos-res> from GROMACS units to NkT unit --> 

4) Compute the mean square displacement (in amstrongs**2) --> <(r -r_0)^2> = <U_pos-res> / \LAMBDA'_E

5) Integrate Eq.(39) of [C.Vega et al., J. Phys. Cond. Matt., 20, 153101 (2008)].
   It can be numerically integrated using the Gaussian quadrature method.




--------------------------
Calculation of A0        |
--------------------------

The fortran code (A0.f) supplied in file A0.txt allows the calculation of
the term A0:

A0/(NkT) = (1/N) * log (rho *Lambda^3) - (1/N) log(I1) - ((N-1)/N) * log (I2)

This code is prepared to evaluate the term A0 for OPLS methanol with \Lambda=6666.67,
\rho=0.01878 Angstrom^{-3} and N=300. The resulting free energy is
given in NkT units (i.e. it outputs A0/(NkT)).

The code can be easily modified to calculate A0 for any other molecule by
changing the following parameters:

- the array X (lines 21-29) that stores the cartesian coordinates of the three non-collinear
  points in the molecule which are bound to their lattice positions with springs

- the variable xlambda (line 31) that stores the maximum value of Lambda_E in KT/L^2 units,
L being the distance units

- the variable rho (line 33) is the density of the system  in L^{-3} units

- the variable N (line 35) is the number of molecules in the simulation

The number of MC steps to evaluate the integrals I1 and I2 is specified by the
variables nsteps and nsteps2 (lines 40-41). 

The code prints at the end: log(I1), log(I2) and A0/NkT.
In this way, once that A0/NkT is evaluated for a set of Lambda_E, rho and N,
it can be quickly evaluated for the same value of Lambda_E but different values
of rho and/or N without the need to evaluate again the terms I1 and I2.

IMPORTANT: For any new system check that the variables
box and delta_ctheta (lines 49-50) are assigned a proper value. These two variables 
define the range of positions and theta angles that are going to be
sampled to evaluate the integral. It must be checked that the integrand
vanishes beyond those limits. If not, the values of box and/or delta_ctheta
must be increased.




