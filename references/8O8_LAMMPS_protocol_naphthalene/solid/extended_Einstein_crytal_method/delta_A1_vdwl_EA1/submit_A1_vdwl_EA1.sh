#!/bin/bash 
#this is the submit script to compute ΔA1_vdwl

#working directory 
cd /workingdirectory/solid/delta_A1_vdwl_EA1
location=$PWD

#directory with all the input files
location2=$location/IFile_A1_vdwl_EA1

#local directory to store all the data   
rm -rf $location/director_A1_vdwl_EA1
mkdir $location/director_A1_vdwl_EA1

D=16 #number of lines in "k_TI.dat"  
#"k_TI.dat" contains paramters to gradually turn on the Lennard-Jones (LJ) van der Waals (vdwl) interactions for ΔA1_vdwl via thermodynamic integration, with full atomic (partial) charges (see methodology).

(for((i=1; i<$D+1; i++)); do

    read num e11 s11 e22 s22 e12 s12 e11p e22p e12p kmax lambda_vdwl
    #e11 --> equilibrium epsilon of Lennard-Jones (LJ) van der Waals (vdwl) interaction between carbon atoms (there are only two atom types in terms of vdwl)
    #e22 --> equilibrium epsilon of Lennard-Jones (LJ) van der Waals (vdwl) interaction between hydrogen atoms
    #e12 --> equilibrium epsilon of Lennard-Jones (LJ) van der Waals (vdwl) interaction between carbon and hydrogen atoms
    #e11p,e22p,e12p --> perturbed epsilon
    #kmax --> kmax in u = 0.5*kmax*(r-r0)^2 = kmax*(r-r0)^2 for the Einstein crystal method
    #lambda_vdwl --> ratio of each equilibrium epsilon over its full value (i.e. 0≤lambda_vdwl≤1)
    #For the naphthalene solute here, we have included the values of "lambda_vdwl*epsilon" of e11, e22 and e12 directly in "k_TI.dat" 
    #This is because there are only 2 vdwl atom types and hence only 3 atom-atom combinations --> so we simply set "lambda_vdwl=1" in "k_TI.dat"

    node=/scratch/A1_5_si_A1_vdwl_EA1-$num-$kmax
    node2=/scratch/A1_5_si_A1_vdwl_EA1-$num-$kmax.re 
    wd=$location/director_A1_vdwl_EA1/A1_vdwl_EA1-$num-$kmax #the one in home that is created in energies.sh
    
    rm -rf $wd 
    mkdir $wd 

    #read "energies_A1_vdwl_EA1.sh" for editing input files according to "k_TI.dat"
    #submit jobs
    jobid=`qsub -v num=$num,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,kmax=$kmax,e11=$e11,s11=$s11,e12=$e12,s12=$s12,e22=$e22,s22=$s22,e11p=$e11p,e12p=$e12p,e22p=$e22p,lambda_vdwl=$lambda_vdwl -N A1_vdwl_EA1-$num-$kmax energies_A1_vdwl_EA1.sh`
    
    
    done) < $location/k_TI.dat






