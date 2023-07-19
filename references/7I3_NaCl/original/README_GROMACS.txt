GROMACS files (GROMACS_LJ_STS_EC.txt and GROMACS_LJ_STS_EM.txt)
***************************************************************
We have paste all together the input files needed to perform the
Einstein crystal (EC) and Einstein molecule (EM) calculations
into five ascii files:
  - GROMACS_LJ_STS_EC_deltaa1.txt --> contains the input files to compute the Delta A_1 term
                              for the Einstein crystal method.
  - GROMACS_LJ_STS_EC_deltaa2.txt --> contains the input files to compute the Delta A_2 term
                              for the Einstein crystal method.
  - GROMACS_LJ_STS_EM_deltaa1.txt --> contains the input files to compute the Delta A_1 term
                              for the Einstein molecule approach.
  - GROMACS_LJ_STS_EM_deltaa2.txt --> contains the input files to compute the Delta A_2 term
                              for the Einstein molecule approach.
  - A_0_EM_EC.txt --> contains the fortran codes to compute the A_0 term for
                             for the Einstein crystal and Einstein molecule methods.

These input files corresponds to the test case corresponding
to the LJ/STS 256 particles system truncated at 2.7 $\sigma$ at $\rho^*=1.28$ and $T^*=2$.
The  value  of \Lambda_E used in the calculations was 2500 k_BT/A**2.
!!!WARNING!!!!
In order to perform the Einstein crystal (EC) and Einstein molecule (EM)
calculations you should SPLIT the input files from these ascii files 
into the corresponding individual files.
############################################################################################
-------------------
General questions |
-------------------
General information about GROMACS input files.

#To execute GROMACS you need to provide three files
grompp.mdp   Contain the parameters controlling the MD simulation
conf.g96     Provides an initial configuration 
topol.top    Contains the Hamiltonian of the system 


#Where the strength of the springs is defined ?
The strength of the springs is defined in the topol.top file.
Notice that GROMACS requires k' rather than \Lambda_E' (remember as described
in the supplementary information pdf file that k'=2*Lambda_E'). Notice also
that in GROMACS k' should be  given in kJ nm**{-2}.  

#Einstein molecule or Einstein crystal calculation?
This is simply controlled by two lines that appears in the
grompp.mdp file

        * Einstein crystal --> center-of-mass = linear
			       comment lines 70 and 71 ( which provide
                               information about frozen atoms, if any) 

        * Einstein molecule--> center-of-mass = none 
			       Do not comment  lines 70 and 71 ( since they  provide
                               information about the frozen atom) 

#Where the location of the origin of the springs is defined ?
In the initial configuration !
GROMACS assumes that the origins of the springs are located on the
initial positions of the LJ atoms defined in the conf.g96 file.
For this reason it is absolutely required that the initial configuration is a perfect lattice.
**********************************************************************************************

Example for the Einstein molecule method (EM):
----------------------------------------------

----------------------
Obtaining \Delta A_1 |
---------------------- 
Create deltaa1/ folder and copy the following input files into it:
grompp.false
grompp_ideal.mdp
topol_ideal.top
topol.sts
deltaA1.sh
extrae_a1.sh
conf.g96
these can be found in the GROMACS_LJ_STS_EM_deltaa1.txt file.

Do the following :

1) cp topol_ideal.top   topol.top
   cp grompp_ideal.mdp  grompp.mdp 
   Execute GROMACS (i.e execute grompp_d first followed by mdrun_d)  
   (i.e perform an MD simulations of an ideal system of springs) 

2) cp traj.xtc traj_id.xtc 
   cp topol.tpr topol.oneconf.tpr 
   (i.e copy the trajectory of the run into another file) 
   (i.e copy the topol.tpr of the ideal system of springs into another file) 

3) cp topol.sts topol.top 
   cp grompp.false  grompp.mdp 
   Execute GROMACS (i.e execute grompp_d first followed by mdrun_d)  
   Read in the md.log file the value of the potential that corresponds
   to the lattice energy  (which corresponds to U_lattice in the  pdf supplementary material
   file). This potential energy (in GROMACS units) is used in the deltaA1.sh script as the variable 
   ulattgrom. 
   (i.e evaluate the U_lattice energy) 
 
3) Execute deltaA1.sh 
   
        * The DeltaA1 (in NkT units ) value is printed on the screen.
          If everything was working properly you should obtain -3.14(2) (NkT)

    Let us describe the deltaA1.sh scripts briefly 

   The deltaA1.sh script requires  two files and one additional script:

- topol.sts  --> contains the definition of the LJ STS Hamiltonian.

- grompp.false --> It is almost identical to the grompp.mdp used to generate the ideal
                   gas trajectory file, but in which the nsteps has been
                   set to one and the time step (dt) to cero.

- extrae_a1.sh --> bash script to extract the potential energy of each configuration. 
        * It uses the next path (GROMACS binary files): /usr/local/bin/
        * It is configured for the GROMACS version 4.5 and this run, that means that the order
          of the average quantity ( 3=potential energy )
          could change from one version to others, and from one system to other depending
          on the simulation parameters, you must check in which order is the quantity of
	  interest before run the bash script.

                  
- deltaA1.sh --> bash script to compute the DeltaA1 term.
        * It requires the previously calculated ideal gas trajectory file, traj_id.xtc,
          the topol.oneconf.tpr file, which is the topol.tpr file generated for the ideal
          gas run (from topol_ideal.top, grompp.mdp and conf.g96), and the grompp.false file.
        * From the information contained in the grompp_ideal.mdp file you could obtain 
          the following information required by the script. Number of saved configurations (N=10000),
          the time interval in ps between the stored configurations of the ideal gas run
          (tstep=dt*nstxtcout, where dt corresponds to the time step used in the ideal gas run and
          nstxtcout the frequency for saving configurations),
          temperature (T=240), number of atoms (nmol=256).
        * It requires the existence of the extrae_a1.sh bash script.
        * It uses the next path (GROMACS binary files): /usr/local/bin/
        * It requires the value of the lattice energy (ulattgrom) in GROMACS units,
        * It generates four output files:
                > energies.dat --> total potential energy of each ideal gas configuration calculated
                  with the real system Hamiltonian ("interacting Einstein crystal") in GROMACS units.
                > kt_energies.dat --> the same energies that energies.dat, but in k_{B}T units.
                > u_sol-u_latt.dat --> energy difference between the "interacting Einstein crystal" and
                  the lattice energy of each configuration in k_{B}T units.
                > exp_u_sol-u_latt.dat --> is the exponential value of the energy difference
                  between the "interacting Einstein crystal" and
                  the lattice energy of each configuration.
        * The DeltaA1 (in NkT units ) value is printed on the screen.

----------------------
Obtaining \Delta A_2 |
----------------------

Create deltaa2/ folder and copy the following input files into it:
topol.orig
grompp.mdp
landas.dat
deltaA2.sh
extrae_a2.sh
conf.g96
these can be found in the GROMACS_LJ_STS_EM_deltaa2.txt file.
                  
To compute Delta A_2 execute deltaA2.sh bash script.
If everything was working properly you should obtain -7.38(2) (NkT) for the EM and -7.35(2) for the EC.
	
- landas.dat --> contains the 15 k' values (kJ nm**{-2}) with which evaluate the integral of \Delta A_2.
                 We have used Gaussian quadrature method to evaluate the integral of Eq.(39)
                 of [C.Vega et al., J. Phys. Cond. Matt., 20, 153101 (2008)] with c=exp(3.5)
                 (see also Ref. [Undertanding Molecular Simulation of D. Frenkel and B. Smit,
                 second Edition, page 260]).

- topol.orig --> contains the definition of the system's Hamiltonian: i.e  
                 the LJ STS potential with harmonic springs of strength k'. 

- extrae_a2.sh --> bash script to extract the position restraint energy of each run.
        * It uses the next path (GROMACS binary files): /usr/local/bin/
        * It is configured for the GROMACS version 4.5 and this run, that means that the order
          of the average quantity ( 3=position restraint energy )
          could change from one version to others, and from one system to other depending
          on the simulation parameters, you must check in which order is the quantity of
          interest before run the bash script.
        * It requires to define the equilibration time in picoseconds (time), these configurations
          will be dismissed to the average.

- deltaA2.sh --> bash script to compute the DeltaA2 term.
  	* It requires to define the number of lambda values (N=15), temperature (T=240),
          number of atoms (nmol=256), and extrae.sh bash script (average position 3).
  	* It uses the next path (GROMACS binary files): /usr/local/bin/
  	* It creates a new directory (director), in which save all run files.
  	* It works with the topol.orig file structure given here (the value of the spring constants
	  must be at line 26), and it must be called topol.orig.
  	* It generate two output files: energies.dat, which contains the position restraints energies
          (in GROMACS units), and integral.dat, which contains the mean square displacement values
	  (in amstrongs**2). The integral.dat file contains the values of the integrand in Eq.(39) of 
          [C.Vega et al., J. Phys. Cond. Matt., 20, 153101 (2008)], and can be numerically integrated
          using the Gaussion quadrature method.

      *  The deltaA2 (in NkT units) value is printed on the screen. 

----------------------
Obtaining A_0        |
----------------------

You should open the A_0 folder, compile and execute the FORTRAN codes to compute this term
depending on the method:
       * Einstein crystal  --> A_0_ec.f
       * Einstein molecule --> A_0_em.f

Notice that A_sol = A_0 + \Delta A_1 + \Delta A_2 
so that you must only compute A_0 ( as given by Eq.2 (EC) or Eq.3 (EM) of the pdf file of the
supplementary material). Notice that to compute A_0, one should use \Lambda_E = 2500 kT/A**2 and 
\Lambda = sigma = 3.405 A. 


