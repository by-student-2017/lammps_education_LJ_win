#!/bin/bash 

nmol=865 #total number of molecules 
nmolsolvent=864 #total number of solvent molecules 
D=64 #number of lines in "lambda3.dat"

rm -rf *Error*
rm -rf *Average*
rm -rf *_result
rm -rf mu.dat 

#"Average_Ucavity" contains the integrands for ΔG_grow = integration{<dUcavity(lambda)/dlambda>} = integration{<Ucavity(lambda)>} from lambda_min = -10 to lambda_max
#"Error" column is the error in "Average"
#"mu.dat" contains the free energy perturbation terms for ΔG_grow
#simply add all the terms in mu.dat to obtain ΔG_grow   
#values from FEP and TI should agree
#note: here in the example, the data are not the direct simulation results from the listed input files

echo "lambda_start Ndata Nblock Average Error Stdev Eerror" >> Average_Ucavity

gcc blockaverage.c -o blockaverage -lm
gcc histogram_cavity.c -o histogram_cavity -lm

(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho lambdastart lambdastop

    echo $num
    
    rm -rf ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop*/block* 
    rm -rf ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop*/histogram*
    rm -rf ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop*/Final_a3.sh

    \cp ./blockaverage ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop*
    \cp ./histogram_cavity ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop*
    \cp ./Final_a3.sh ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop*
    cd ./*$num-$Astart-$Astop-$rho-$lambdastart-$lambdastop*
    
    #U_cavity --> total cavity energy
    awk -v NORM=$lambdastart '{print ($10)}' energies3.dat > Ucavity_id_$lambdastart.dat
    ./blockaverage Ucavity_id_$lambdastart.dat
    echo $num >> ../ErrorCavity_Ucavity
    echo "Ndata block average error stdev Eerror" >> ../ErrorCavity_Ucavity
    cat Error >> ../ErrorCavity_Ucavity
    echo $lambdastart | tr "\n" " " >> ../Average_Ucavity
    tail -4 Error | head -1 >> ../Average_Ucavity
    ./histogram_cavity energies_id.dat
    
    #free energy perturbation step
    ./Final_a3.sh > here
    echo $num-$Astart-$Astop-$rho-$lambdastart-$lambdastop > file
    cat file | tr "\n" " " >> ../mu.dat 
    tail -1 here >> ../mu.dat 
    rm -rf here
    ./blockaverage exp_u_sol-u_latt.dat 
    echo $num >> ../ErrorTotalFep 
    echo "Ndata block average error stdev Eerror" >> ../ErrorTotalFep
    cat Error >> ../ErrorTotalFep

    cd ../
	
    done) < ./lambda3.dat






