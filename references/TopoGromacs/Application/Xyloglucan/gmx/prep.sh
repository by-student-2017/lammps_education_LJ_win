#!/bin/bash

vmd -dispdev text -e prep.tcl
gmx editconf -f xylo.pdb -o xyloglucan.pdb -box 7 7 7
gmx grompp -f run.mdp -c xyloglucan.pdb -p xyloglucan.top -o xyloglucan.tpr -maxwarn 1
gmx grompp -f runzero.mdp -c xyloglucan.pdb -p xyloglucan.top -o xyloglucan.tpr -maxwarn 1

gmx mdrun -s xyloglucan.tpr -o xyloglucan -e xyloglucan.edr -xvg none
