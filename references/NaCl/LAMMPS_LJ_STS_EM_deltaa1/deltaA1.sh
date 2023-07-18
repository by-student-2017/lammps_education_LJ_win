#!/bin/bash

N=10000
nmol=256
nmolghost=511
epsilon=120.
TK=240.
ulattgrom=-3.1578029

T=`echo $TK $epsilon | awk '{print $1/$2}'`

rm energies.dat kt_energies.dat u_sol-u_latt.dat exp_u_sol-u_latt.dat
touch energies.dat

./lmp_serial < input-id-EM
cp old_config_1.dat old_config_1.dat.0
./lmp_serial < input-real-EM
tail -26 log.lammps  |head -1 |awk '{print $3}' >> energies.dat

(for ((i=1; i<$N; i++)); do
echo $i

./lmp_serial < input-continue-EM

./lmp_serial < input-real-EM
tail -26 log.lammps  |head -1 |awk '{print $3}' >> energies.dat

done)

ulatt=`echo $T $ulattgrom $nmolghost $nmol | awk '{print $2*$3/$4/$1}'`


echo ""
echo "--------------------------"
echo "U_latt (kT units) ----> " $ulatt

awk -v temp=$T natghost=$nmolghost'{print natghost*$1/temp}' energies.dat > kt_energies.dat
awk -v latt=$ulatt natm=$nmol'{print (($1/natm)-latt)}' kt_energies.dat > u_sol-u_latt.dat
awk '{print exp(-$1)}' u_sol-u_latt.dat > exp_u_sol-u_latt.dat
prod=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' exp_u_sol-u_latt.dat`

echo "av_exp(-beta(U_sol-U_latt)) ----> " $prod

logN=`echo $prod $nmol | awk '{print log($1)/$2}'`

echo "1/N ln[av_exp(-beta(U_sol-U_latt))] ----> " $logN

deltaA1=`echo $ulatt $logN | awk '{print ($1-$2)}'`

echo ""
echo "--------------------------"
echo ""
echo "DA_1/NkT ----> " $deltaA1