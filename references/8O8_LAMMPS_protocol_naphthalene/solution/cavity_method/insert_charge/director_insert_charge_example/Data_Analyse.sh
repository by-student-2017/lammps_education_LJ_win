#!/bin/bash 

D=8 #number lines in "lambda2_charge.dat"

rm -rf mu*.dat 
gcc blockingaverage.c -o blockingaverage -lm

#"mu_elec.dat" --> free energy perturbation contributions to ΔG_insert_charge (add up)
#"mu_elec_intra.dat" --> free energy perturbation contributions to ΔG_insert_charge_intramolecular (add up for intramolecular electrostatic energy) 

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop chargehydrogen chargecarbon chargehydrogenp chargecarbonp
    echo $num
    
    rm -rf ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*/Final*
    \cp blockingaverage ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    \cp Final_a2_elec.sh ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    \cp Final_a2_elec_intra.sh ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    cd ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*

    ./Final_a2_elec.sh > here 
    echo $num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp > file
    cat file | tr "\n" " " >> ../mu_elec.dat
    tail -1 here >> ../mu_elec.dat
    #./blockingaverage exp_u_sol-u_latt.dat
    #mv Error Error_mu_elect.dat

    ./Final_a2_elec_intra.sh > here
    echo $num-$Astart-$Astop-$rho-$lambdastart-$lambdastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp > file
    cat file | tr "\n" " " >> ../mu_elec_intra.dat
    tail -1 here >> ../mu_elec_intra.dat
    #./blockingaverage exp_u_sol-u_latt.dat 
    #mv Error Error_mu_elec_intra.dat

    cd ../
	
    done) < ./lambda2_charge.dat 

