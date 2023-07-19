#!/bin/bash 

nmol=240 #number of molecuels 
kcalmolkt=1.688656246 #kcal/mol to temperature

D=15
N=0 

#this script produce "Average_Uinter-elec_equi" for ΔA1_electrostatic, meaning "averaged intermolecular electrostatic energy at the equilibrium atomic partial charges"
#"Average_Uinter-elec_equi" --> three columns "num alpha Average_Uinter-elec_equi"
#num --> labelling parameter
#alpha --> atomic (partial) charge ratio (0≤alpha≤1) 
#Average_Uinter-elec_equi --> "averaged intermolecular electrostatic energy at the equilibrium atomic partial charges"
#Read methodology description --> ΔA1_electrostatic = integration{<dUinter-elec_equi/dalpha> dalpha} between alpha = 1.0 and alpha = 0.0 
#dUinter-elec_equi(alpha)/dalpha = 2*Uinter-elec_equi(alpha)/alpha as the electrostatics are pairwise additive (exact for computing electrostatics but sufficient for the current accuracy)
#so <dUinter-elec_equi(alpha)/dalpha> = <2*Uinter-elec_equi(alpha)/alpha

gcc inter.c -o inter -lm
gcc histogram_Uinter-elec_equi.c -o histogram_Uinter-elec_equi -lm
gcc blockaverage.c -o blockaverage -lm

rm -rf  ./Average*
rm -rf  ./Error*

echo "num alpha Average_Uinter-elec_equi" > ./Average_Uinter-elec_equi 

(for((i=1; i<$D+1; i++)); do

    read num e11 s11 e22 s22 e12 s12 e11p e22p e12p kmax lambda_vdwl chargecarbon chargehydrogen chargecarbonp chargehydrogenp alpha

    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/histogram_*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/blockaverage

    
    cp ../IFile_A1_charge_EA1/data_restart_continue ./*$num-$kmax-$chargehydrogen-$chargecarbon*
    echo $num-$kmax-$chargehydrogen-$chargecarbon
    \cp ./inter ./*$num-$kmax-$chargehydrogen-$chargecarbon*
    \cp ./blockaverage ./*$num-$kmax-$chargehydrogen-$chargecarbon*
    \cp ./histogram_Uinter-elec_equi ./*$num-$kmax-$chargehydrogen-$chargecarbon*
    cd ./*$num-$kmax-$chargehydrogen-$chargecarbon*

    ./inter energies_single2.dat energies.dat > ../output_equi
    
    ####equi state #########
    #head -400 Elattice_elec_equi.dat > elattice_elec_equi.dat
    echo $lambda_vdwl
    awk -v lattice=$lattice -v kcalmolkt=$kcalmolkt -v lambda_vdwl=$lambda_vdwl '{print ($2/lambda_vdwl)}' Elattice_elec_equi.dat > ./Uinter-elec_equi.dat
    ./histogram_Uinter-elec_equi Uinter-elec_equi.dat

    ./blockaverage Uinter-elec_equi.dat
    echo $num $lambda_vdwl | tr "\n" " " >> ../Average_Uinter-elec_equi
    tail -7 Error | head -1 > ./Error_firstline
    errorfirstline=`echo $OUTPUT | awk -v nmol=$nmol '{print ($3)}' Error_firstline`    
    echo $errorfirstline >> ../Average_Uinter-elec_equi
    stdv=`echo $OUTPUT | awk '{print ($5)}' Error_firstline`
    mean=`echo $OUTPUT | awk '{print ($3)}' Error_firstline`
    echo $stdv $mean > stdvmean.dat
    cat Error_firstline >> ../Error_Average
    rm -rf  Error_firstline

    cd ../

    done) < ./k_TI.dat







