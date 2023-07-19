#!/bin/bash

N=5000
nmol=256
epsilon=120.
TK=240.
ulattgrom=-6.3032707

T=`echo $TK $epsilon | awk '{print $2/$1}'`

rm energies.dat kt_energies.dat u_sol-u_latt.dat exp_u_sol-u_latt.dat
touch energies.dat

./lmp_serial < input-id-EC
cp old_config_1.dat old_config_1.dat.0
./lmp_serial < input-real-EC
tail -22 log.lammps  |head -1 |awk '{print $3}' >> energies.dat

(for ((i=1; i<$N; i++)); do
echo $i

./lmp_serial < input-continue-EC

./lmp_serial < input-real-EC
tail -22 log.lammps  |head -1 |awk '{print $3}' >> energies.dat

done)

ulatt=`echo $T $ulattgrom $nmol | awk '{print $2*$1*$3}'`
ulattnkt=`echo $T $ulattgrom $nmol | awk '{print ($2*$1}'`


echo ""
echo "--------------------------"
echo "U_latt (kT units) ----> " $ulatt
echo "U_latt (NkT units) ----> " $ulattnkt

echo "Continue"
read si

awk -v temp=$T -v nat=$nmol '{print $1*temp*nat}' energies.dat > kt_energies.dat
awk -v latt=$ulatt '{print ($1-latt)}' kt_energies.dat > u_sol-u_latt.dat
awk '{print exp(-$1)}' u_sol-u_latt.dat > exp_u_sol-u_latt.dat
prod=`echo $OUTPUT | awk '{s+=$1}END{print s/NR}' exp_u_sol-u_latt.dat`

echo "av_exp(-beta(U_sol-U_latt)) ----> " $prod

logN=`echo $prod $nmol | awk '{print log($1)/$2}'`

echo "1/N ln[av_exp(-beta(U_sol-U_latt))] ----> " $logN

deltaA1=`echo $ulatt $nmol | awk -v aver=$logN '{print ($1/$2)-(aver)}'`

echo ""
echo "--------------------------"
echo ""
echo "DA_1/NkT ----> " $deltaA1
