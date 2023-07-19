#!/bin/bash

nmol=240 #number of molecules
spring=4 #number of Orientational Atoms/Springs per molecule --> atomic mean-squared-displacements contributing to delta_A0 (see methodology)
kcalmolkt=1.688656246 #kcalmol-1 to temperature 
D=25

#this script produce delta_A0/N per molecule
#Ebond.dat --> the energy output of "fix spring/self" of "Orientational Atoms/Springs" (see "fix spring/self" in LAMMPS) 
#msd.dat --> mean-squared-displacement of "Orientational Atoms/Springs" without subtracting out the effect of any drift in the center-of-mass of "Orientational Atoms/Springs" (per atom msd) (see "compute msd" in LAMMPS)
#msd2.dat --> mean-squared-displacement of "Orientational Atoms/Springs" with subtracting out the effect of any drift in the center-of-mass of "Orientational Atoms/Springs" (per atom msd) (see "compute msd" in LAMMPS)

#Ebond.dat --> gives A0_msd.dat --> same as A0_Sumofmsd.dat
#We use A0_Sumofmsd2_comyes.dat for computing delta_A0/N per molecule
#See methodology: delta_A0/N per molecule = integration{<Σ_orientational(r-r0)^2>*(K+c1)dln(K+c1)} between max:ln(Kmax+c1) and min:ln(Kmin+c1)=ln(c1)

rm -rf *~
rm -rf *A0*.dat
rm -rf *Average*
rm -rf *Error*
gcc blockaverage.c -o blockaverage -lm
gcc histogram_Sumofmsd2.c -o histogram_Sumofmsd2 -lm
\cp ../k.dat ./

(for((i=1; i<$D+1; i++)); do

    read num k kmax
    \cp ./*$num-$k-$kmax*/log.dat ./

    endline=`awk '{ if($1=="Loop") print NR}' log.dat`
    numline=`awk '{ if($1=="1000000") print NR}' log.dat`
    awk -v line=$numline end=$endline'{if((NR>line)&&(NR<end)) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33}' log.dat > log.lammps.1
    awk -v a=$nmol -v k=$k '{print $1,$32}' log.lammps.1 > Ebond.dat
    awk -v a=$nmol -v k=$k '{print ($23)}' log.lammps.1 > msd.dat
    awk -v a=$nmol -v k=$k '{print ($24)}' log.lammps.1 > msd2_comyes.dat
    rm -rf log.lammps.1
    
    awk -v ratio=$kcalmolkt -v nmol=$nmol '{print ($2*2)/nmol}' Ebond.dat > kcalpermol_Ebond.dat
    awk -v nmol=$nmol -v k=$k '{print ($1/k)}' kcalpermol_Ebond.dat > SumofRsquared.dat
    awk -v ratio=$kcalmolkt -v spring=$spring '{print ($1*spring)}' msd2_comyes.dat > Sumofmsd2_comyes.dat
    awk -v ratio=$kcalmolkt -v spring=$spring '{print ($1*spring)}' msd.dat > Sumofmsd.dat


    ################## Sumofmsd2_comyes.dat ###########                                                                                                                                                        
    ./blockaverage Sumofmsd2_comyes.dat
    echo $num $k >> ./ErrorTotal_Sumofmsd2
    echo "Ndata block average error stdev Eerror" >> ./ErrorTotal_Sumofmsd2
    cat Error >> ./ErrorTotal_Sumofmsd2
    echo $num | tr "\n" " " >> ./Average_Sumofmsd2
    tail -7 Error | head -1 > ./Error_firstline
    errorfirstline=`echo $OUTPUT | awk -v nmol=$nmol '{print ($4)}' Error_firstline`
    echo $errorfirstline >> ./Average_Sumofmsd2
    ########################################   

    prod=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' SumofRsquared.dat`
    T=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' msd.dat`
    U=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' msd2_comyes.dat`
    US=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' Sumofmsd2_comyes.dat`
    UP=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' Sumofmsd.dat`

    echo "k----> " $k
    echo "av_SumofRsquared ----> " $prod
    echo ""
    
    echo $num $k $prod >> A0.dat 
    echo $num $k $T >> Average_msd.dat
    echo $num $k $U >> Average_msd2_comyes.dat
    echo $num $k $US >> A0_Sumofmsd2_comyes.dat
    echo $num $k $UP >> A0_Sumofmsd.dat

    rm -rf log.dat
    

    done) < ./k.dat