#!/bin/bash 

D=64

rm -rf *Error*
rm -rf *Average*
rm -rf *_result
rm -rf mu.dat 
rm -rf *~

gcc blockaverage.c -o blockaverage -lm
gcc histogram_cavity.c -o histogram_cavity -lm


(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop

    echo naphthalene_shrinking_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop

    cd naphthalene_shrinking_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop
    
    rm -rf ./*~
    rm -rf ./Final_a3.sh
    rm -rf ./Ucavity_id_*.dat
    rm -rf ./Error
    rm -rf ./record*
    rm -rf ./InG*.dat
    rm -rf ./G*.dat
    rm -rf ./*sol-u_latt*
    rm -rf ./block*
    rm -rf ./histogram*
    rm -rf ./kt*.dat
    rm -rf ./error.dat
    rm -rf ./file
    rm -rf ./here

    
    cd ../
	
    done) < ./lambda3.dat

