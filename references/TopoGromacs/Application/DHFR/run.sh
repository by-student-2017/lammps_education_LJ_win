#!/bin/bash

cd CHARMM
charmm < minimize.inp > minimize.log
charmm < charmm.inp > charmm.log
cd ../NAMD
namd2 +p10 run.namd > run.log
cd ../gmx
./prep.sh
cd ..
