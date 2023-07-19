#!/bin/bash 

nmol=513
nmolsolvent=512
D=48


rm mu*.dat 



(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho sigmastart sigmastop chargehydrogen chargecarbon chargehydrogenp chargecarbonp
    echo $num

    rm -rf ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*/Final*
    \cp Final_a3_elec_notail.sh ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    \cp Final_a3_water_noetail.sh ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    \cp Final_a3_elec_intra.sh ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    \cp ./Final_a3_naph_noetail.sh ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    cd ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp*
    awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($7+$8)}' energies_solvent.dat > Ureal3_onlysolvent_$alpha.dat
    awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($7+$8)}' energies3.dat > Ureal3_$alpha.dat
    awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($7+$8)}' energies_intra2.dat > Uintra2_$alpha.dat
    paste -d' ' Ureal3_onlysolvent_$alpha.dat Ureal3_$alpha.dat Uintra2_$alpha.dat > Ureal3_onlysolventreal3intra4intra2_$alpha.dat
    rm -rf Ureal3_onlysolvent_$alpha.dat Ureal3_$alpha.dat Uintra2_$alpha.dat
    awk '{print (($2-$1-$3))}' Ureal3_onlysolventreal3intra4intra2_$alpha.dat > delta_Ureal3_onlysolventreal3intra4intra2_$alpha.dat
    delta=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' delta_Ureal3_onlysolventreal3intra4intra2_$alpha.dat`
    echo $num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$lambda-$alpha-$lambdap-$alphap $delta >> ../Average_delta.dat


    ./Final_a3_elec_notail.sh > here 
    echo $num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp > file
    cat file | tr "\n" " " >> ../mu_elec.dat
    tail -1 here >> ../mu_elec.dat

    ./Final_a3_water_noetail.sh > here
    echo $num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp > file
    cat file | tr "\n" " " >> ../mu_water_noetail.dat
    tail -1 here >> ../mu_water_noetail.dat

    ./Final_a3_naph_noetail.sh > here
    echo $num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp > file
    cat file | tr "\n" " " >> ../mu_naph_noetail.dat
    tail -1 here >> ../mu_naph_noetail.dat

    ./Final_a3_elec_intra.sh > here
    echo $num-$Astart-$Astop-$rho-$sigmastart-$sigmastop-$chargecarbon-$chargehydrogen-$chargecarbonp-$chargehydrogenp > file
    cat file | tr "\n" " " >> ../mu_elec_intra.dat
    tail -1 here >> ../mu_elec_intra.dat

    
    cd ../
	
    done) < ./landa2_step1_naphthalene_nocharge.dat






