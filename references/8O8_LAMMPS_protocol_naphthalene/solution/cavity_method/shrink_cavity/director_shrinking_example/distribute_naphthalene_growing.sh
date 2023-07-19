#!/bin/bash 

nmol=513
nmolsolvent=512
D=106

rm -rf *Error*
rm -rf *Average*
rm -rf mu.dat 

echo "lamda_start Ndata Nblock Average Error Stdev Eerror" >> Average_Ucavity

gcc blockaverage.c -o blockaverage -lm

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho sigmastart sigmastop

    echo $num

    rm -rf ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*/block* 
    rm -rf ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*/Final_a3.sh

    \cp ./blockaverage ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*
    \cp ./Final_a3.sh ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*
    cd ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*


    awk -v NORM=$sigmastart '{print ($10)}' energies3.dat > Ucavity_id_$sigmastart.dat
    ./blockaverage Ucavity_id_$sigmastart.dat
    echo $num >> ../ErrorCavity_Ucavity
    echo "Ndata block average error stdev Eerror" >> ../ErrorCavity_Ucavity
    cat Error >> ../ErrorCavity_Ucavity
    echo $sigmastart | tr "\n" " " >> ../Average_Ucavity
    tail -4 Error | head -1 >> ../Average_Ucavity
        
    ./Final_a3.sh > here
    echo $num-$Astart-$Astop-$rho-$sigmastart-$sigmastop > file
    cat file | tr "\n" " " >> ../mu.dat 
    tail -1 here >> ../mu.dat 
    ./blockaverage exp_u_sol-u_latt.dat 
    echo $num >> ../ErrorTotal 
    echo "Ndata block average error stdev Eerror" >> ../ErrorTotal
    cat Error >> ../ErrorTotal

    cd ../
	
    done) < ./lambda3.dat






