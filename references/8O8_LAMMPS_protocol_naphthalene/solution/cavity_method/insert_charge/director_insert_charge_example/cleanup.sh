#!/bin/bash 

D=8

rm -rf mu*.dat 
rm -rf Average*
rm -rf *~
rm -rf *u_sol-u_latt*
rm -rf kt*

gcc blockingaverage.c -o blockingaverage -lm

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop chargehydrogen chargecarbon chargehydrogenp chargecarbonp
    echo $num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp
        
    cd ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*

    rm -rf ./file*
    rm -rf ./Final_a2_elec.sh
    rm -rf ./Final_a2_elec_intra.sh
    rm -rf ./blockingaverage
    rm -rf ./here*
    rm -rf ./kt*
    rm -rf ./*u_sol-u_latt*

    cd ../
	
    done) < ./lambda2_charge.dat 

