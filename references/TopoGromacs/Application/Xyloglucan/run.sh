#!/bin/bash
NAMDARGS=+p10
cd INPUT
vmd -dispdev text -e solvate.tcl
namd2 $NAMDARGS minimize.namd > minimize.log
cd ../NAMD
namd2 $NAMDARGS run.namd > run.log
namd2 $NAMDARGS run2.namd > run2.log
cd ../gmx
./prep.sh
cd ..
