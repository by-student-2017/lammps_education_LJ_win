#!/bin/bash

cd NAMD
namd2 run.namd > run.log
cd ../gmx
./prep.sh
cd ..
