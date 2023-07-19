#!/bin/bash   
#this is the submit script to compute ΔA2

#working directory
cd /workingdirectory/solid/delta_A2_EA1
location=$PWD

#directory containing all the input files
location2=$location/IFile_A2

#directory to store data
rm -rf $location/director_A2_EA1
mkdir $location/director_A2_EA1

D=25 #number of k between kmax and kmin = 0 for thermodynamic integration (between num=1 and num=20, other num = 0.1-0.4 and num = 21 are for references)
#equivalent --> K between Kmax = 2500 kcalmol-1/Å^2 and Kmin = 0 
#0.5*kmax = Kmax and "kmax" is the input for "fix spring/self"
#"k_2.dat" has taken into account n=20 Legendre-Gauss quadrature weights and abscissae between kmin = 0 and kmax = 5000 kcalmol-1/Å^2 for c2 = 2.01 (see methodology for the meaning of c2 in computing ΔA2) 

N=1  #number of continued runs

(for((i=1; i<$D+1; i++)); do

    read num k kmax
    #num --> labelling paramter
    #k --> in u = 0.5*k(r-r0)^2 = K(r-r0)^2  
    #kmax --> in u = 0.5*kmax(r-r0)^2 = Kmax(r-r0)^2
    node=/scratch/solid_A2_EA1-$num-$k
    node2=/scratch/solid_A2_EA1-$num-$k.re 
    wd=$location/director_A2_EA1/solid_A2_EA1-$num-$k
    
    rm -rf $wd 
    mkdir $wd 
    
    #see energies.sh for editing input files according to "k_2.dat"  
    #see energies_re.sh for editing input files according to "k_2.dat" to continue runs
    #submit jobs
    jobid=`qsub -v num=$num,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,k=$k,kmax=$kmax -N A2_EA1 energies.sh`
    
    (for ((i=1; i<$N+1; i++)); do                                                                                                                                                    
	jobid=`qsub -hold_jid A2_EA1,Re_A2_EA1 -v num=$num,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,k=$k,kmax=$kmax,O=$i -N Re_A2_EA1 energies_re.sh` 
	done) 
    
    done) < $location/k_2.dat






