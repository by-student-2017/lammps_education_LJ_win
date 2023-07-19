#!/bin/bash

N=15
Nsteps=100
T=240.
nmol=256
cexp=33.11545

rm pesos.dat calcula.dat
rm -r ./director
rm energies.dat integral.dat
mkdir ./director

(for ((i=1; i<$N+1; i++)); do

 read num landa w
 echo $w >> pesos.dat

 mkdir ./director/$landa

 head -14 input-EM.dat > input.dat
 echo "bond_coeff      1 $landa 0.00001" >> input.dat
 tail -30 input-EM.dat >> input.dat

 ./lmp_serial < input.dat

 cp log.lammps ./director/$landa
 cp input.dat ./director/$landa

 endline=`awk '{ if($1=="Loop") print NR}' log.lammps`

 numline=`awk '{ if($2=="E_mol") print NR}' log.lammps`
 awk -v line=$numline end=$endline'{if((NR>line)&&(NR<end)) print $1,$2}' log.lammps > log.lammps.1
 awk -v NORM=$landa '{print $1,$2/NORM*11.59}' log.lammps.1 > drbond.dat

 integ=`awk '{a=a+$2 ; print a/NR}' drbond.dat  |tail -1` 
 landakt=`echo $landa | awk '{print $1*0.04325}' `
 echo $landakt $integ >> integral.dat

 rm log.lammps input.dat log.lammps.1

done) < landas_EM.dat

paste integral.dat pesos.dat > calcula.dat

awk -v const=$cexp '{s+=($2*($1+const))*$3} END {print (-1)*s}' calcula.dat > final_value_DA2.txt
read Da2 < final_value_DA2.txt

echo "Delta A_2 / NkT =" $Da2

rm pesos.dat calcula.dat