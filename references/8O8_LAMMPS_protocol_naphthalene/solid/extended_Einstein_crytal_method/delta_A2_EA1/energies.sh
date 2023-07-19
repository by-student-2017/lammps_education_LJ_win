#!/bin/bash 
#this edit the input files according to "k_2.dat"  

rm -rf $node
mkdir $node
cd $node
cd $wd
#this is to copy all the input files from "IFile_A2"
\cp $location2/* ./

O=0 #labelling parameter

#Ba is the Central Atom in the extended Einstein crystal method                                                                                                                                                   
#CO is the Orientational Atoms in the extended Einstein crystal method                                                                                                                                             
#fixed is Central Atom + Orientational Atom 
#see input file for atoms in "Ba" and "CO"                                                                                                                                                                

head -94 input_1.dat > input.dat 
echo "fix            2 fixed spring/self $k" >> input.dat 
echo "fix_modify     2 energy no" >> input.dat 
tail -17 input_1.dat >> input.dat 

#run
lammps_exectable < input.dat > log.dat

\cp $node/* $wd 
rm -rf $node 
cd $wd