LAMMPS files (GROMACS_LJ_STS_EC.txt and GROMACS_LJ_STS_EM.txt)
**************************************************************
We have paste all together the input files needed to perform the
Einstein crystal (EC) and Einstein molecule (EM) calculations
into five ascii files:
  - LAMMPS_LJ_STS_EC_deltaa1.txt --> contains the input files to compute the Delta A_1 term
                              for the Einstein crystal method.
  - LAMMPS_LJ_STS_EC_deltaa2.txt --> contains the input files to compute the Delta A_2 term
                              for the Einstein crystal method.
  - LAMMPS_LJ_STS_EM_deltaa1.txt --> contains the input files to compute the Delta A_1 term
                              for the Einstein molecule approach.
  - LAMMPS_LJ_STS_EM_deltaa2.txt --> contains the input files to compute the Delta A_2 term
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

#Where the strength of the springs is defined ?

Depending on the method and the term of the free energy that one wants to calculate,
we have used:
     > Einstein crystal:
       fix spring/self k'
       where k' is the spring strenght in LAMMPS units
     > Einstein molecule:
       bond_style harmonic
       bond_coeff 1 \Lambda_E' 0.00001
       where \Lambda_E' corresponds to the harmonic spring constant (\Lambda_E'=2*k').
       It defines an harmonic potential bond between each atom and a "ghost" atom 
       located at fcc lattice sites.

#Where the location of the origin of the springs is defined ?
In case we are using:
     > Einstein crystal (fix spring/self k')
       the origin of the springs is taken from the initial configuration.
       For this reason it is absolutely required the initial configuration
       to be a perfect latttice (config-EC.dat).
     > Einstein molecule (bond_style harmonic
                          bond_coeff 1 \Lambda_E' 0.00001)
       you have to prepare the initial configuration with ghost atoms located at
       fcc lattice sites (config-EM.dat).

#Einstein molecule or Einstein crystal calculation?

They are different depending on the free energy calculation method,
Einstein crystal (EC) or Einstein molecule (EM).
To execute LAMMPS you need to provide two files: input-XX.dat and config-XX.dat,
where XX corresponds to EC or EM.

- input-EC.dat --> input file for Einstein Crystal
  	       	   it contains the definition of the system's Hamiltonian.
        	   Here we define the harmonic spring constant (k'=2* Lambda_E').
                   From these runs one will obtain the total elastic energy; 
                   thus, the means square displacement.
                   In order to compute DeltaA2 (integral in Eq. (5) of Supplementary materials)
                   one simply should change the value of the given lambda with
                   the corresponding from file landas_EC.dat, and the numerically
                   integrate the means square displacement using Gaussian quadrature method.

- config-EC.dat -->initial configuration for Einstein Crystal
  		   equilibrated fcc-solid at rho*=1.28 
		   it contains 256 LJ-atoms (type 1) 
 
                   or 

- input-EM.dat --> input file for Einstein Molecule
  	           it contains the definition of the system's Hamiltonian.
                   Here we define the harmonic spring constant (Lambda_E)
                   From these runs one will obtain the total elastic energy; 
                   thus, the means square displacement.
                   In order to compute DeltaA2 (integral in Eq. (5) of Supplementary materials)
                   one simply should change the value of the given lambda with
                   the corresponding from file landas_EM.dat, and the numerically
                   integrate the means square displacement using Gaussian quadrature method.

- config-EM.dat -->initial configuration for Einstein Molecule
  		   equilibrated fcc-solid at rho*=1.28
  		   it contains 511 atoms (255 LJ-atoms (type 1) bounded to 
		   255 ideal ghost atoms (type 2) and 1 fixed LJ-atom 
		   (type 3))

Example of LAMMPS run:

./lmp_serial < input-EM.dat

****************************************************************************************************
----------------------
Obtaining \Delta A_1 |
----------------------

Create deltaa1/ folder and copy the following input files into it
(these can be found in the GROMACS_LJ_STS_EM_deltaa1.txt file):

        > input-id-XX, which corresponds to an ideal gas Hamiltonian, and read the initial
          configuration. It is used to start the ideal gas simulation in which the atoms
          of the system are attached to their lattice postions by harmonic springs.
           * For Einstein Crystal (EC) the harmonic springs are defined using:
             fix spring/self k'
           * For Einstein Molecule (EM) the harmonic springs are defined using
             an harmonic potential bond between each atom and a ghost located at fcc lattice sites.
             bond_style harmonic
             bond_coeff 1 \Lambda_E' 0.00001
          (input-id-EC for Einstein Crystal and input-id-EM for Einstein Molecule)

        > input-real-XX, which corresponds to the real system Hamiltonian, and read the
          last configuration generated by the ideal gas run calculating its potential
          energy with the real system Hamiltonian.
          (input-real-EC for Einstein Crystal and input-real-EM for Einstein Molecule).
          For Einstein Molecule (EM) the harmonic springs constant should be set to zero
          in order to obtain the potential energy of each configuration of the previous runs
          using the real Hamiltonian of the system in absence of the harmonic springs.

        > input-continue-XX, which corresponds to the ideal gas Hamiltonian (input-id-XX),
          but it is used to continue the original run.
          (input-continue-EC for Einstein Crystal and input-continue-EM for Einstein Molecule)

        > deltaA1.sh

        > config-XX.dat --> It depends on the free energy calculation method:
             * Einstein Crystal: initial configuration equilibrated fcc-solid at rho*=1.28
                                 it contains 256 LJ-atoms (type 1).
             * Einstein molecule: initial configuration for Einstein Molecule
                                  equilibrated fcc-solid at rho*=1.28
                                  it contains 511 atoms (255 LJ-atoms (type 1) bounded to
                                  255 ideal ghost atoms (type 2) and 1 fixed LJ-atom
                                  (type 3)).
                            
1) Evaluate the U_lattice energy
   * LAMMPS binary file must be into the script directory.
   ./lmp_serial < input-real-EM.dat
   It requires config-EM.dat
   Read in the log.lammps file the value of the potential that corresponds
   to the lattice energy  (which corresponds to U_lattice in the pdf supplementary material
   file). This potential energy (in LAMMPS units) is used in the deltaA1.sh script as the variable
   ulattgrom.
    
2) Execute deltaA1.sh bash script.
   It will perform an ideal gas simulation in which the atoms
   of the system are attached to their lattice postions by harmonic springs
   (\Lambda_E=2500 k_BT/A**2=115940.25 \epsilon/sigma**2).

   * LAMMPS binary file must be into the script directory.
   * deltaA1.sh requires to define the total number of independent configurations (N),
     the temperature (TK), epsilon (\epsilon), ulattgrom (U_lattice) and the total number of atoms (nmol). 
   * The output of the log.lammps depends on the given input, therefore with the provided
     input files the potential energy is always in line 26
     (tail -26 log.lammps  |head -1 |awk '{print $3}' >> energies.dat).
     You must check your log.lammps file in order to define the correct line for
     the potential energy.
   * It generates four output files:
	> energies.dat --> total potential energy of each ideal gas configuration calculated
		           with the real system Hamiltonian ("interacting Einstein crystal") in LAMMPS units.
        > kt_energies.dat --> the same as in energies.dat, but in k_B T units.
        > u_sol-u_latt.dat --> energy difference between the "interacting Einstein crystal" and
                               the lattice energy of each configuration in k_B T units.
        > exp_u_sol-u_latt.dat --> the exponential value of the energy difference
                                   between the "interacting Einstein crystal" and
                                   the lattice energy of each configuration.
   * The DeltaA1 value is printed on the screen. 


----------------------
Obtaining \Delta A_2 |
----------------------

Create deltaa1/ folder and copy the following input files into it:

input-XX.dat
landas_XX.dat
deltaA2.sh
config-XX.dat

where XX corresponds to EC or EM.
These can be found in the GROMACS_LJ_STS_EM_deltaa1.txt file.

To compute Delta A_2 execute deltaA2.sh bash script.

- landas_EC.dat --> contains the 15 k' values (epsilon/sigma**{-2}) with which evaluate the
                 integral of \Delta A_2. We have used Gaussian quadrature method to
                 evaluate the integral of Eq.(39) of
                 [C.Vega et al., J. Phys. Cond. Matt., 20, 153101 (2008)] with c=exp(3.5)
                 (see also Ref. [Undertanding Molecular Simulation of D. Frenkel and B. Smit,
                 second Edition, page 260]).

- landas_EM.dat --> contains the 15 \Lambda_E' values (epsilon/sigma**{-2}) with which evaluate the
                 integral of \Delta A_2. We have used Gaussian quadrature method to
                 evaluate the integral of Eq.(39) of
                 [C.Vega et al., J. Phys. Cond. Matt., 20, 153101 (2008)] with c=exp(3.5)
                 (see also Ref. [Undertanding Molecular Simulation of D. Frenkel and B. Smit,
                 second Edition, page 260]).
 
- deltaA2.sh --> bash script to compute the DeltaA2 term.
        * LAMMPS binary file must be into the script directory.
        * It requires to define the number of lambda values (N=15), temperature (T=240),
          and number ot atoms (nmol=256).
        * It creates a new directory (director), in which save all run files.
        * It generate two output files: energies.dat, which contains the position restraints energies
          (in LAMMPS units), and integral.dat, which contains the mean square displacement values
          (in amstrongs**2). The integral.dat file contains the values of the integrand in Eq.(39) of
          [C.Vega et al., J. Phys. Cond. Matt., 20, 153101 (2008)], and can be numerically integrated
          using the Gaussion quadrature method.

        *  The deltaA2 (in NkT units) value is printed on the screen.


----------------------
Obtaining A_0        |
----------------------

You should open the A_0 folder, compile and execute the fortran codes to compute this term
dependig on the method:
       * Einstein crystal  --> A_0_ec.f
       * Einstein molecule --> A_0_em.f

Notice that A_sol = A_0 + \Delta A_1 + \Delta A_2
so that you must only compute A_0 ( as given by Eq.2 (EC) or Eq.3 (EM) of the pdf file of the
supplementary material). Notice that to compute A_0, one should use \Lambda_E = 2500 kT/A**2 and
\Lambda = sigma = 3.405 A.

**********************************


