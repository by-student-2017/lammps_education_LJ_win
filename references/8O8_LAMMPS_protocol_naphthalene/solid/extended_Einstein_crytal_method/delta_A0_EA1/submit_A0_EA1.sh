#!/bin/bash   
#this is the submit script to compute ΔA0

#working directory
cd /workingdirectory/solid/delta_A0_EA1
location=$PWD

#directory containing all the input files
location2=$location/IFile_A0

#directory to store data
rm -rf $location/director_A0_EA1
mkdir $location/director_A0_EA1

D=25 #number of k between kmax = 5000 kcalmol-1/Å^2 and kmin = 0 for thermodynamic integration (between num=1 and num=20, other num = 0.1-0.4 and num = 21 are for reference) 
#equivalent --> K between Kmax = 2500 kcalmol-1/Å^2 and Kmin = 0 
#0.5*kmax = Kmax and "kmax" is the input for "fix spring/self"
#"k.dat" has taken into account n=20 Legendre-Gauss quadrature weights and abscissae between kmin = 0 and kmax = 5000 kcalmol-1/Å^2 for c1 = 0.07 (see methodology for the meaning of c1 in computing ΔA0)

N=1  #number of continued runs

(for((i=1; i<$D+1; i++)); do

    read num k kmax
    #num --> labelling parameter
    #k --> in u = 0.5*k(r-r0)^2 = K(r-r0)^2
    #kmax --> in u = 0.5*kmax(r-r0)^2 = Kmax(r-r0)^2
    node=/scratch/solid_A0_EA1-$num-$k
    node2=/scratch/solid_A0_EA1-$num-$k.re 
    wd=$location/director_A0_EA1/solid_A0_EA1-$num-$k
    
    rm -rf $wd 
    mkdir $wd 
    
    #read "energies.sh" for editing input files according to "k.dat"
    #submit jobs
    jobid=`qsub -v num=$num,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,k=$k,kmax=$kmax -N A0_EA1 energies.sh`
    
    (for ((i=1; i<$N+1; i++)); do                                                                                                                                                    
	jobid=`qsub -hold_jid A0_EA1,Re_A0_EA1 -v num=$num,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd,k=$k,kmax=$kmax,O=$i -N Re_A0_EA1 energies_re.sh` 
	done) 
    
    
    done) < $location/k.dat






