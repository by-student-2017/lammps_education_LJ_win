#!/bin/bash

vmd -dispdev text -e prep.tcl
gmx editconf -f minimizedrecentered.pdb -o dhfr.pdb -box 6.223 6.223 6.223
gmx grompp -f run.mdp -c dhfr.pdb -p dhfr.top -o dhfr.tpr -maxwarn 2

gmx mdrun -s dhfr.tpr -o dhfr.trr -e dhfr.edr -xvg none -notunepme
