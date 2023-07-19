#!/bin/bash 

nmol=513
nmolsolvent=512
D=98

rm -rf *Error*
rm -rf *Average*
rm -rf *_result
rm -rf mu.dat 

echo "num lamda_start Ndata Nblock Average Error Stdev Eerror" >> Average_Sum

gcc BLOCKfinalexp.c -o blockexp -lm
gcc histogram_intra2.c -o histogram_intra2 -lm
gcc BLOCKfinalenergies_id_p.c -o blockenergies_id_p -lm
gcc BLOCKfinaltwocolumn.c -o BLOCKfinaltwocolumn -lm


(for((i=1; i<$D+1; i++)); do

    read num Astart Astop rho sigmastart sigmastop chargehydrogen chargecarbon chargehydrogenp chargecarbonp

    echo $num

    

    rm -rf ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*/histogram_intra2
    rm -rf ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*/blockexp
    \cp ./histogram_intra2 ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*
    \cp ./blockexp ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*
    cd ./*$num-$Astart-$Astop-$rho-$sigmastart-$sigmastop*

    awk -v a=$nmol -v NORM=$sigmastart '{print ($5-$6+$7+$8)}' energies_intra2.dat > Uintra2_id_$sigmastart.dat
    ./blockexp Uintra2_id_$sigmastart.dat
    echo $num >> ../ErrorIntra2_Uintra2
    echo "Ndata block average error stdev Eerror" >> ../ErrorIntra2_Uintra2
    cat Error >> ../ErrorIntra2_Uintra2
    echo $num-$Astart-$Astop-$rho-$sigmastart-$sigmastop $sigmastart | tr "\n" " " >> ../Average_Uintra2
    tail -7 Error | head -1 >> ../Average_Uintra2
    ./histogram_intra2 energies_intra2.dat

    cd ../
	
    done) < ./landa2_step1_naphthalene.dat






