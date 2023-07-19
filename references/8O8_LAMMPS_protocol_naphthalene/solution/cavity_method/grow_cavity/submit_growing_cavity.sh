#!/bin/bash
#this is the submit script for computing the free energy of growing a cavity i.e. delta_G_grow

#working directory
cd /workingdirectory/solution/growing_cavity
location=$PWD

#directory containing all the LAMMPS input files and initial configuration
location2=$location/IFile_grow

#directory to store all simulation data 
rm -rf $location/director_growing
mkdir $location/director_growing

#as mentioned in "Readme_solution", we use the pairwise solute-solvent cavity potential u_cavity = 300exp(-r+lambda) --> LAMMPS' Born potential E_born = Aexp[(sigma-r)/rho]-C/r^6+D/r^8 
#using default real units in LAMMPS: energies are in kcal/mol and distances are in Å
#u_cavity = 300exp(-r+lambda) = E_born = Aexp[(sigma-r)/rho]-C/r^6+D/r^8  
#A = 300 kcal/mol; C = D = 0; rho = 1 
#we use lambda to label and vary our cavity size

D=64 #number of lambda values from minimum = -10 (negligible cavity size) to the desired lambda_max
#also the number of lines in "lambda3.dat"

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop
    #num = labbeling parameter 
    #A_start = A_stop = 300 kcal/mol 
    #rho = 1.0 for E_born = Aexp[(sigma-r)/rho]-C/r^6+D/r^8 
    #lambdastart --> equilibrium lambda for u_cavity = 300exp(-r+lambda)
    #lambdastop ---> perturbed lambda for u_cavity = 300exp(-r+lambda) 
    node=/scratch/naphthalene_growing_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop
    node2=/scratch/naphthalene_growing_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop.re 
    wd=$location/director_growing/naphthalene_growing_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop
        
    rm -rf $wd 
    mkdir $wd
 
    #read "energies_growing.sh" for editing the input files according to "lambda3.dat"
    #submit jobs
   jobid=`qsub -v num=$num,Astart=$Astart,Astop=$Astop,rho=$rho,lambdastart=$lambdastart,lambdastop=$lambdastop,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,O=$x -N growing-$num-growing_a1-$Astart-$Astop-$rho-$lambdastart-$lambdastop energies_growing.sh`
    
    
    done) < $location/lambda3.dat 
