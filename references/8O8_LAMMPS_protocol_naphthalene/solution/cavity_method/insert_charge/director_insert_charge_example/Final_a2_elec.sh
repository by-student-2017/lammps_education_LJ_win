#!/bin/bash

nmol=864 #number of water molecules
kcalmolkt=1.688656246 #kcal/mol to temperature 

#"($7+$8)" is the total electrostatic energy of the corresponding input file
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($7+$8)*ratio}' energies4.dat > kt_energies4.dat
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($7+$8)*ratio}' energies3.dat > kt_energies3.dat
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($7+$8)*ratio}' energies_intra2.dat > kt_energies_intra2.dat
awk -v ratio=$kcalmolkt -v nat=$nmol '{print ($7+$8)*ratio}' energies_intra4.dat > kt_energies_intra4.dat

paste -d' ' kt_energies4.dat kt_energies3.dat kt_energies_intra4.dat kt_energies_intra2.dat > kt.dat

awk '{print (($1-$3)-($2-$4))}' kt.dat > u_sol-u_latt.dat

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
