#!/bin/bash
#this is the submit script for computing ΔG_insert_vdwl

#working directory
cd /workingdirectory/solution/insert_vdwl
location=$PWD

#directory containing all the LAMMPS input files
location2=$location/IFile_insert_vdwl

#directory to store data 
rm -rf $location/director_insert_vdwl
mkdir $location/director_insert_vdwl

D=180 
#number of line in "lambda2.dat" 
#number of lambda_vdwl, which is the linear coupling parameter for the vdwl part of solute-solvent interaction between 0 and 1  (0≤lambda_vdwl≤1)

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop e13 e14 e13p e14p
    #num = labbeling parameter
    #A_start = A_stop = 300 kcal/mol
    #rho = 1.0 for E_born = Aexp[(sigma-r)/rho]-C/r^6+D/r^8 of the LAMMPS Born potential
    #lambdastart = lambdastop --> equilibrium lambda for u_cavity = 300exp(-r+lambda)
    #e13 --> equilibrium lambda_vdwl*epsilon of LJ interaction between carbon in naphthalene and oxygen in water 
    #e14 --> equilibrium lambda_vdwl*epsilon of LJ interaction between hydrogen in naphthalene and oxygen in water
    #e13p --> perturbed lambda_vdwl*epsilon of LJ interaction between carbon in naphthalene and oxygen in water 
    #e14p --> perturbed lambda_vdwl*epsilon of LJ interaction between hydrogen in naphthalene and oxygen in water
    #because there are only two vdwl atomic types for the solute here, we do not use lambda_vdwl but read int e13,e14,e13p and e14p directly.

    node=/scratch/insert_vdwl_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14
    node2=/scratch/insert_vdwl_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14.re 
    wd=$location/director_insert_vdwl/insert_vdwl_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14 #the one in home that is created in energies.sh
    
    rm -rf $wd 
    mkdir $wd
 
    #submit jobs
    jobid=`qsub -v num=$num,Astart=$Astart,Astop=$Astop,rho=$rho,lambdastart=$lambdastart,lambdastop=$lambdastop,e13=$e13,e13p=$e13p,e14=$e14,e14p=$e14p,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,O=$x -N insert_vdwl-$num-step2_$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14 energies_insert_vdwl.sh`
    
    done) < $location/lambda2.dat 





