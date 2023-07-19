#!/bin/bash 

D=18

rm -rf *Error*
rm -rf *Average*
rm -rf *_result
rm -rf mu*.dat 
rm -rf *~

#gcc blockaverage.c -o blockaverage -lm
#gcc histogram_cavity.c -o histogram_cavity -lm

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop e13 e14 e13p e14p
    
    #mv *$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14* insert_vdwl_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14
    
    echo insert_vdwl_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14

    cd insert_vdwl_$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$e13-$e14
    
    rm -rf ./Final_a2.sh
    rm -rf ./Final_a2_etailonly.sh
    rm -rf ./*~
    rm -rf ./delta_Real3.dat
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
	
    done) < ./lambda2.dat

