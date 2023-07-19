#!/bin/bash 
#this script edits the input files in "IFile_npt" accorinding to the parameters read from "parameter.dat": T, Tdamp, pressure and Pdamp
#T --> temperature 
#Tdamp --> damping parameter for temperature 
#pressure --> pressure 
#Pdamp --> damping parameter for pressure 
#see "fix npt" in LAMMPS manual

rm -rf $node 
mkdir $node
cd $node
#copy input files in "IFile_npt" 
\cp $location2/* ./

O=0 #labelling parameter

#edit input files
head -94 input_withmin.dat > input_withmin_1.dat
echo "fix            1 all npt temp $T $T $Tdamp tri $pressure $pressure $Pdamp" >> input_withmin_1.dat
tail -9 input_withmin.dat >> input_withmin_1.dat

#assign a spring constant for the artificial bonds bewteen the virtual atom and the two aromatic fusion atoms 
head -76 input_withmin_1.dat > input_withmin.dat
echo "bond_coeff      3 $link 0.70" >> input_withmin.dat
tail -27 input_withmin_1.dat >> input_withmin.dat

#run
lammps_executable < input_withmin.dat > log_withmin.dat

\cp data_restart_continue data_restart_continue_$num-$T-$Tdamp-$pressure-$Pdamp-$link

\mv $node/* $wd
rm -rf $node 