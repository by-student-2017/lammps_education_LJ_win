#!/bin/bash

nmol=864
kcalmolkt=1.688656246

#($5-$6) vdwl energy excluding the tail correction
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($5-$6)*ratio}' energies4.dat > kt_energies4.dat
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($5-$6)*ratio}' energies_intra4.dat > kt_energies_intra4.dat
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($5-$6)*ratio}' energies3.dat > kt_energies3.dat
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($5-$6)*ratio}' energies_intra2.dat > kt_energies_intra2.dat

paste -d' ' kt_energies4.dat kt_energies_intra4.dat kt_energies3.dat kt_energies_intra2.dat > kt.dat

awk '{print (($1-$2)-($3-$4))}' kt.dat > u_sol-u_latt.dat

awk '{print exp(-$1)}' u_sol-u_latt.dat > exp_u_sol-u_latt.dat

prod=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' exp_u_sol-u_latt.dat`

echo "av_exp(-beta(U_insert-U_ref)) ----> " $prod

logN=`echo $prod $nmol | awk '{print log($1)}'`

echo "ln[<exp(-beta(U_insert-U_ref)>] ----> " $logN

mu=`echo $kcalmolkt | awk -v aver=$logN '{print -(aver)/$1}'`

echo ""
echo "--------------------------"
echo ""
echo "mu/kcalmol-1 ----> " $mu
