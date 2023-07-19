#!/bin/bash
NAMDARGS=+p10
cd charmm-gui
namd2 $NAMDARGS minimize.namd > minimize.log
vmd -dispdev text -e minimizewrite.tcl
cd ../NAMD
namd2 $NAMDARGS run.namd > run.log
cd ../gmx
./prep.sh
cd ..
