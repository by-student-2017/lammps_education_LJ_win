#!/bin/bash 
#this edit the input files according to "k.dat"

rm -rf $node 
mkdir $node
cd $node
#this is to copy all the input files from "IFile_A0"
\cp $location2/* ./

O=0 #labelling parameter

#Ba is the Central Atom in the extended Einstein crystal method 
#CO is the Orientational Atoms in the extended Einstein crystal method     
#see input file for atoms in "Ba" and "CO" 

head -94 input_1.dat > input.dat 
echo "fix            2 CO spring/self $k" >> input.dat 
echo "fix_modify     2 energy no" >> input.dat
echo "fix            3 Ba spring/self $kmax" >> input.dat
echo "fix_modify      3 energy no" >> input.dat
tail -15 input_1.dat >> input.dat 

#run 
lammps_executable < input.dat > log.dat
\cp old_config_1.dat old_config_1_init.dat 

\cp $node/* $wd 
rm -rf $node 
cd $wd