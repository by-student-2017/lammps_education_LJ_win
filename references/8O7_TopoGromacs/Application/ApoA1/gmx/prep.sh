#!/bin/bash

vmd -dispdev text -e prep.tcl
gmx editconf -f minimizedrecentered.pdb -o apoa1.pdb -box 10.88612 10.88612 7.7758
gmx grompp -f run.mdp -c apoa1.pdb -p apoa1.top -o apoa1.tpr -maxwarn 2

gmx mdrun -s apoa1.tpr -o apoa1.trr -e apoa1.edr -xvg none -notunepme
