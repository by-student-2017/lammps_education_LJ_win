#!/bin/bash 
#this edit the input files according to "k_2.dat"

rm -rf $node 
mkdir $node
cd $node
#this is to copy all the input files from "IFile_A2" 
\cp $location2/* ./

#Ba is the Central Atom in the extended Einstein crystal method 
#CO is the Orientational Atoms in the extended Einstein crystal method
#fixed is Central Atom + Orientational Atoms
#see input file for atoms in "Ba" and "CO"

#read configurations to continue simulations 
restartfile=$location/director_A2_EA1/solid_A2_EA1-$num-$k
\cp $restartfile/old_config_1.dat ./      

head -94 input_2.dat > input.dat 
echo "fix            2 fixed spring/self $k" >> input.dat 
tail -17 input_2.dat >> input.dat 

#run
lammps_exectable < input.dat > log_2_$O.dat
\cp data_restart data_restart_$O
\cp old_config_1.dat old_config_1_$O.dat   

\cp $node/* $wd 
rm -rf $node 
cd $wd
