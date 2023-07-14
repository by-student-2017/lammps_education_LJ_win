#!/bin/bash

vmd -dispdev text -e prep.tcl
gmx editconf -f ../INPUT/waterhexamer.pdb -o waterhexamer.pdb
gmx grompp -f run.mdp -c waterhexamer.pdb -p waterhexamer.top -o waterhexamer.tpr

gmx mdrun -s waterhexamer.tpr -o waterhexamer -e waterhexamer.edr -xvg none
