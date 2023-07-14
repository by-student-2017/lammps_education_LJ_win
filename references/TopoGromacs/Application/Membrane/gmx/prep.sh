#!/bin/bash

vmd -dispdev text -e prep.tcl
gmx editconf -f minimizedrecentered.pdb -o memb.pdb -box 11.1067 11.1067 16.3506
gmx grompp -f run.mdp -c memb.pdb -p memb.top -o memb.tpr -maxwarn 2

gmx mdrun -s memb.tpr -o memb.trr -e memb.edr -xvg none -notunepme