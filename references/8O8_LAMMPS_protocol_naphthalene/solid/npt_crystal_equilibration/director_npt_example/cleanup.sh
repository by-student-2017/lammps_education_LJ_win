#!/bin/bash

D=1 

rm -rf *~

(for((i=1; i<$D+1; i++)); do

    read num T Tdamp pressure Pdamp link

    cd solid_npt-$num-$T-$Tdamp-$pressure-$Pdamp-$link

    rm -rf *~

    cd ../


    done) < ./parameter.dat






