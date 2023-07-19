#!/bin/bash 

nmol=240
kcalmolkt=1.688656246
D=16

rm -rf ./Average*
rm -rf ./mu*.dat 
rm -rf ./Error*
rm -rf *~

(for((i=1; i<$D+1; i++)); do

    read num e11 s11 e22 s22 e12 s12 e11p e22p e12p kmax fraction


    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/*~
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/*rdf
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/dump*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/InG*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/G_*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/mean*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/*inter*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/record*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/stdv*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/Error
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/error.dat
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/Elattice*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/histogram*
    rm -rf ./A1_5_si_A1_vdwl_EA1-$num-$kmax/blockaverage

    done) < ./k_TI.dat







