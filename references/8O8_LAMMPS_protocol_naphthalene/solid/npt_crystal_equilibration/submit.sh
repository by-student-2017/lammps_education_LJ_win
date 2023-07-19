#!/bin/bash
#this is the submit script

#working directory
cd /workingdirectory/solid/npt_equilibration
location=$PWD

#directory with all the input files
location2=$location/IFile_npt

#directory to store data
rm -rf $location/director_npt
mkdir $location/director_npt

D=1 #number of combinations of temperature and pressure to be simulated 
    #D is also number of lines in "parameter.dat"

(for((i=1; i<$D+1; i++)); do

    read num T Tdamp pressure Pdamp link
    #T,Tdamp,pressure and Pdamp are parameters used in isobaric-isothermal NpT relaxations (see "fix npt" of LAMMPS)
    #num --> labelling parameter
    #T --> temperature 
    #Tdamp --> damping parameter for temperature (see "fix npt" of LAMMPS)
    #pressure --> pressure 
    #Pdamp --> damping parameter for pressure (see "fix npt" of LAMMPS)
    #within each naphthalene molecule, "link" is the spring constant attaching the virtual atom (if there is) to the two aromatic fusion carbon atoms
    #the virtual atom has equal bond distances to the two aromatic fusion carbon atoms
    #(the same virtual atom setting applies to the solution as well/virtual atom is the centre of the cavity potential)
    #the virtual atom has no nonbonding interactions
    #in the extended Einstein crystal method, the virtual atom is the "Central Atom" (read methodology description for the meaning of "Central Atom")

    node=/scratch/solid_npt-$num-$T-$Tdamp-$pressure-$Pdamp-$link
    node2=/scratch/solid_npt-$num-$T-$Tdamp-$pressure-$Pdamp-$link.re 
    wd=$location/director_npt/npt-$num-$T-$Tdamp-$pressure-$Pdamp-$link #the one in home that is created in energies.sh
    
    rm -rf $wd 
    mkdir $wd 
    
    #read "npt.sh" for editing input files (e.g. assign T,Tdamp,pressure and Pdamp) to run simuations 
    #submit jobs
    jobid=`qsub -v num=$num,T=$T,Tdamp=$Tdamp,pressure=$pressure,Pdamp=$Pdamp,link=$link,location=$location,location2=$location2,node=$node,node2=$node2,wd=$wd -N npt-$num-$T-$Tdamp-$pressure-$Pdamp-$link npt.sh`

3    done) < $location/parameter.dat






