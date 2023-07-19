#!/bin/bash                                                                                                                                                                                                                                                

nmol=240 #number of molecules in the crystal 
kcalmolkt=1.688656246 #energy unit from kcal/mol to temperature

D=15
N=0

rm -rf  *~
rm -rf  ./Average*
rm -rf  ./Error*
rm -rf  histogram_Uinter-elec_equi
rm -rf  blockaverage


(for((i=1; i<$D+1; i++)); do
    
    read num e11 s11 e22 s22 e12 s12 e11p e22p e12p kmax lambda_vdwl chargecarbon chargehydrogen chargecarbonp chargehydrogenp alpha
    
    echo $num
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/histogram_*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/blockaverage
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/Error
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/error.dat
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/InG*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/G_*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/*2_5_elec_equi*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/*inter*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/mean*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/record*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/stdv*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/Elattice*
    rm -rf  ./*$num-$kmax-$chargehydrogen-$chargecarbon*/*~

    done) < ./k_TI.dat