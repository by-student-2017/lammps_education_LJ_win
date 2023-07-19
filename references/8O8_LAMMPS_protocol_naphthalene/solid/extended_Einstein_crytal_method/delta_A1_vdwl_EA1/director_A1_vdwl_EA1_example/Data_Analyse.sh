#!/bin/bash 

nmol=240 #number of molecules 
kcalmolkt=1.688656246 #kcalmol-1 to temperature 
D=16

#this script produce "Average_Uinter-vdwl_equi" for ΔA1_vdwl, meaning "averaged intermolecular vdwl energy at the equilibrium atomic partial charges"
#in "Average_Uinter-vdwl_equi" --> three columns "num lambda_vdwl Average_Uinter-vdwl_equi"
#num --> labelling parameter
#lambda_vdwl --> ratio of each equilibrium atomic LJ vdwl epsilon over its full value (0≤lambda_vdw≤1)lambda_vdwl
#Average_Uinter-vdwl_equi --> "averaged intermolecular vdwl energy at the equilibrium atomic partial charges"
#Read methodology description --> ΔA_vdwl = integration{<dUinter-vdwl_equi(lambda_vdwl)/dlambda_vdwl> dlambda_vdwl} between lambda_vdwl = 1.0 and lambda_vdwl = 0.0 
#dUinter-vdwl_equi(lambda_vdwl)/dlambda_vdwl = Uinter-vdwl_equi(lambda_vdwl)/lambda_vdwl
#so <dUinter-vdwl_equi(lambda_vdwl)/dlambda_vdwl> = <Uinter-vdwl_equi(lambda_vdwl)/lambda_vdwl>

gcc histogram_single2_instant.c -o histogram_single2_instant -lm
gcc histogram_Uinter-vdwl_equi.c -o histogram_Uinter-vdwl_equi -lm
gcc inter.c -o inter -lm
gcc blockaverage.c -o blockaverage -lm

rm -rf ./Average*
rm -rf ./mu*.dat 
rm -rf ./Error*

echo "num lambda_vdwl Average_Uinter-vdwl_equi" > ./Average_Uinter-vdwl_equi 

(for((i=1; i<$D+1; i++)); do

    read num e11 s11 e22 s22 e12 s12 e11p e22p e12p kmax lambda_vdwl

    cp ../IFile_A1_vdwl_EA1/data_restart_continue ./A1_5_si_A1_vdwl_EA1-$num-$kmax
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/histogram_*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/blockaverage
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/*inter*

    echo final-$num-$kmax-$lambda_vdwl
    \cp ./inter ./A1_5_si_A1_vdwl_EA1-$num-$kmax
    \cp ./histogram_Uinter-vdwl_equi ./A1_5_si_A1_vdwl_EA1-$num-$kmax
    \cp ./blockaverage ./A1_5_si_A1_vdwl_EA1-$num-$kmax
    \cp ./histogram_single2_instant ./A1_5_si_A1_vdwl_EA1-$num-$kmax
    cd ./A1_5_si_A1_vdwl_EA1-$num-$kmax
    rm -rf ./*NAPHTA36*
    rm -rf ./InG*
    rm -rf ./*real*

    ./inter energies_single2.dat energies.dat > ../output_equi
    #./histogram_single2_instant energies_single2.dat

    ####equi state #########
    #head -400 Elattice_vdwl_equi.dat > elattice_vdwl_equi.dat
    awk -v lattice=$lattice -v kcalmolkt=$kcalmolkt -v lambda_vdwl=$lambda_vdwl '{print ($2)}' Elattice_vdwl_equi.dat > ./Uinter-vdwl_equi.dat
    ./histogram_Uinter-vdwl_equi Uinter-vdwl_equi.dat

    ./blockaverage Uinter-vdwl_equi.dat
    echo $num $lambda_vdwl | tr "\n" " " >> ../Average_Uinter-vdwl_equi
    tail -7 Error | head -1 > ./Error_firstline
    errorfirstline=`echo $OUTPUT | awk -v nmol=$nmol '{print ($3)}' Error_firstline`    
    echo $errorfirstline >> ../Average_Uinter-vdwl_equi
    stdv=`echo $OUTPUT | awk '{print ($5)}' Error_firstline`
    mean=`echo $OUTPUT | awk '{print ($3)}' Error_firstline`
    echo $stdv $mean > stdvmean.dat
    cat Error_firstline >> ../Error_Average_Uinter-vdwl_equi
    rm -rf Error_firstline

    cd ../

    done) < ./k_TI.dat







