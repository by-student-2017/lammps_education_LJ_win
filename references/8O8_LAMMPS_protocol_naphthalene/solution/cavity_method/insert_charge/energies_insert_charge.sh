#!/bin/bash
#this script edit the input files for computing ΔG_insert_electrostatic

rm -rf $node 
mkdir $node
cd $node
#copy all the input files from "IFile_insert_charge"
\cp $location2/* ./

O=0 #labelling parameter
M=2000 #number of data sampledfor free energy perturbation (FEP)

#initial equilibration
\cp input_init_1.dat input_1.dat

#assign equilibrium atomic (partial) charges
#C: non-aromatic carbon atoms
#He: hydrogen atoms
#Na: virtual atom between the fusion carbons as the cavity centre
#See input files for details
###########################################################################
head -32 input_init_2.dat > input_2.dat
echo "set             group C charge $chargecarbon" >> input_2.dat
echo "set             group He charge $chargehydrogen" >> input_2.dat
echo "set             group Na charge 0.000" >> input_2.dat
echo "" >> input_2.dat
echo "pair_style      hybrid/overlay lj/cut/coul/long 12.0 12.0 born 12.0" >> input_2.dat
echo "#spc water" >> input_2.dat
echo "pair_coeff      1 1 lj/cut/coul/long 0.15535 3.1660" >> input_2.dat
echo "pair_coeff      1 2 lj/cut/coul/long 0.00000 0.0000" >> input_2.dat
echo "pair_coeff      2 2 lj/cut/coul/long 0.00000 0.0000" >> input_2.dat
echo "" >> input_2.dat
echo "" >> input_2.dat
echo "pair_coeff      1 3 lj/cut/coul/long 0.10428 3.35800"  >> input_2.dat
echo "pair_coeff      2 3 lj/cut/coul/long 0.00000 0.00000" >> input_2.dat
echo "pair_coeff      3 3 lj/cut/coul/long 0.07000 3.55000" >> input_2.dat
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input_2.dat
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input_2.dat
echo "#c10h8water O & H with the solute Os (lambda is average)" >> input_2.dat
echo "pair_coeff      1 4 lj/cut/coul/long 0.06827 2.79300" >> input_2.dat
echo "pair_coeff      2 4 lj/cut/coul/long 0.00000 0.00000"  >> input_2.dat
echo "pair_coeff      3 4 lj/cut/coul/long 0.04583 2.98500" >> input_2.dat
echo "pair_coeff      4 4 lj/cut/coul/long 0.03000 2.42000" >> input_2.dat
echo "" >> input_2.dat
echo "pair_coeff      1 5 lj/cut/coul/long 0.10428 3.35800" >> input_2.dat
echo "pair_coeff      2 5 lj/cut/coul/long 0.00000 0.00000" >> input_2.dat
echo "pair_coeff      3 5 lj/cut/coul/long 0.07000 3.55000" >> input_2.dat
echo "pair_coeff      4 5 lj/cut/coul/long 0.04583 2.98500" >> input_2.dat
echo "pair_coeff      5 5 lj/cut/coul/long 0.07000 3.55000" >> input_2.dat
echo "" >> input_2.dat
echo "pair_coeff      1 6 lj/cut/coul/long 0.00000 0.00000" >> input_2.dat
tail -70 input_init_2.dat >> input_2.dat
###########################################################################

#assign equilibrium charges for data samplings
###########################################################################
head -32 input_continue.dat > input-continue
echo "set             group C charge $chargecarbon" >> input-continue
echo "set             group He charge $chargehydrogen" >> input-continue
echo "set             group Na charge 0.000" >> input-continue
echo "" >> input-continue
echo "pair_style      hybrid/overlay lj/cut/coul/long 12.0 12.0 born 12.0" >> input-continue
echo "#spc water" >> input-continue
echo "pair_coeff      1 1 lj/cut/coul/long 0.15535 3.1660" >> input-continue
echo "pair_coeff      1 2 lj/cut/coul/long 0.00000 0.0000" >> input-continue
echo "pair_coeff      2 2 lj/cut/coul/long 0.00000 0.0000" >> input-continue
echo "" >> input-continue
echo "" >> input-continue
echo "pair_coeff      1 3 lj/cut/coul/long 0.10428 3.35800"  >> input-continue
echo "pair_coeff      2 3 lj/cut/coul/long 0.00000 0.00000" >> input-continue
echo "pair_coeff      3 3 lj/cut/coul/long 0.07000 3.55000" >> input-continue
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input-continue
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input-continue
echo "#c10h8water O & H with the solute Os (lambda is average)" >> input-continue
echo "pair_coeff      1 4 lj/cut/coul/long 0.06827 2.79300" >> input-continue
echo "pair_coeff      2 4 lj/cut/coul/long 0.00000 0.00000"  >> input-continue
echo "pair_coeff      3 4 lj/cut/coul/long 0.04583 2.98500" >> input-continue
echo "pair_coeff      4 4 lj/cut/coul/long 0.03000 2.42000" >> input-continue
echo "" >> input-continue
echo "pair_coeff      1 5 lj/cut/coul/long 0.10428 3.35800" >> input-continue
echo "pair_coeff      2 5 lj/cut/coul/long 0.00000 0.00000" >> input-continue
echo "pair_coeff      3 5 lj/cut/coul/long 0.07000 3.55000" >> input-continue
echo "pair_coeff      4 5 lj/cut/coul/long 0.04583 2.98500" >> input-continue
echo "pair_coeff      5 5 lj/cut/coul/long 0.07000 3.55000" >> input-continue
echo "" >> input-continue
echo "pair_coeff      1 6 lj/cut/coul/long 0.00000 0.00000" >> input-continue
tail -70 input_continue.dat >> input-continue
########################################################################### 

#assign equilibrium charges for data samplings 
########################################################################### 
head -32 input_real.dat > input-real3.dat
echo "set             group C charge $chargecarbon" >> input-real3.dat 
echo "set             group He charge $chargehydrogen" >> input-real3.dat 
echo "set             group Na charge 0.000" >> input-real3.dat 
echo "" >> input-real3.dat 
echo "pair_style      hybrid/overlay lj/cut/coul/long 12.0 12.0 born 12.0" >> input-real3.dat 
echo "#spc water" >> input-real3.dat 
echo "pair_coeff      1 1 lj/cut/coul/long 0.15535 3.1660" >> input-real3.dat 
echo "pair_coeff      1 2 lj/cut/coul/long 0.00000 0.0000" >> input-real3.dat 
echo "pair_coeff      2 2 lj/cut/coul/long 0.00000 0.0000" >> input-real3.dat 
echo "" >> input-real3.dat 
echo "" >> input-real3.dat 
echo "pair_coeff      1 3 lj/cut/coul/long 0.10428 3.35800"  >> input-real3.dat
echo "pair_coeff      2 3 lj/cut/coul/long 0.00000 0.00000" >> input-real3.dat
echo "pair_coeff      3 3 lj/cut/coul/long 0.07000 3.55000" >> input-real3.dat
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input-real3.dat
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input-real3.dat
echo "#c10h8water O & H with the solute Os (lambda is average)" >> input-real3.dat
echo "pair_coeff      1 4 lj/cut/coul/long 0.06827 2.79300" >> input-real3.dat
echo "pair_coeff      2 4 lj/cut/coul/long 0.00000 0.00000"  >> input-real3.dat
echo "pair_coeff      3 4 lj/cut/coul/long 0.04583 2.98500" >> input-real3.dat
echo "pair_coeff      4 4 lj/cut/coul/long 0.03000 2.42000" >> input-real3.dat
echo "" >> input-real3.dat
echo "pair_coeff      1 5 lj/cut/coul/long 0.10428 3.35800" >> input-real3.dat
echo "pair_coeff      2 5 lj/cut/coul/long 0.00000 0.00000" >> input-real3.dat
echo "pair_coeff      3 5 lj/cut/coul/long 0.07000 3.55000" >> input-real3.dat
echo "pair_coeff      4 5 lj/cut/coul/long 0.04583 2.98500" >> input-real3.dat
echo "pair_coeff      5 5 lj/cut/coul/long 0.07000 3.55000" >> input-real3.dat
echo "" >> input-real3.dat
echo "pair_coeff      1 6 lj/cut/coul/long 0.00000 0.00000" >> input-real3.dat
tail -70 input_real.dat >> input-real3.dat
########################################################################### 

#assign perturbed charges for data samplings  
########################################################################### 
head -32 input_real.dat > input-real4.dat
echo "set             group C charge $chargecarbonp" >> input-real4.dat
echo "set             group He charge $chargehydrogenp" >> input-real4.dat
echo "set             group Na charge 0.000" >> input-real4.dat
echo "" >> input-real4.dat
echo "pair_style      hybrid/overlay lj/cut/coul/long 12.0 12.0 born 12.0" >> input-real4.dat
echo "#spc water" >> input-real4.dat
echo "pair_coeff      1 1 lj/cut/coul/long 0.15535 3.1660" >> input-real4.dat
echo "pair_coeff      1 2 lj/cut/coul/long 0.00000 0.0000" >> input-real4.dat
echo "pair_coeff      2 2 lj/cut/coul/long 0.00000 0.0000" >> input-real4.dat
echo "" >> input-real4.dat
echo "" >> input-real4.dat
echo "pair_coeff      1 3 lj/cut/coul/long 0.10428 3.35800"  >> input-real4.dat
echo "pair_coeff      2 3 lj/cut/coul/long 0.00000 0.00000" >> input-real4.dat
echo "pair_coeff      3 3 lj/cut/coul/long 0.07000 3.55000" >> input-real4.dat
echo "pair_coeff      1 6 born $Astop $rho $lambdastop 0 0" >> input-real4.dat
echo "pair_coeff      6 6 born $Astop $rho $lambdastop 0 0" >> input-real4.dat
echo "#c10h8water O & H with the solute Os (lambda is average)" >> input-real4.dat
echo "pair_coeff      1 4 lj/cut/coul/long 0.06827 2.79300" >> input-real4.dat
echo "pair_coeff      2 4 lj/cut/coul/long 0.00000 0.00000"  >> input-real4.dat
echo "pair_coeff      3 4 lj/cut/coul/long 0.04583 2.98500" >> input-real4.dat
echo "pair_coeff      4 4 lj/cut/coul/long 0.03000 2.42000" >> input-real4.dat
echo "" >> input-real4.dat
echo "pair_coeff      1 5 lj/cut/coul/long 0.10428 3.35800" >> input-real4.dat
echo "pair_coeff      2 5 lj/cut/coul/long 0.00000 0.00000" >> input-real4.dat
echo "pair_coeff      3 5 lj/cut/coul/long 0.07000 3.55000" >> input-real4.dat
echo "pair_coeff      4 5 lj/cut/coul/long 0.04583 2.98500" >> input-real4.dat
echo "pair_coeff      5 5 lj/cut/coul/long 0.07000 3.55000" >> input-real4.dat
echo "" >> input-real4.dat
echo "pair_coeff      1 6 lj/cut/coul/long 0.00000 0.00000" >> input-real4.dat
tail -70 input_real.dat >> input-real4.dat
########################################################################### 

#assign equilibrium charges for data samplings with only the solute charges
###########################################################################
head -32 input_intra.dat > input-intra2.dat
echo "set             group C charge $chargecarbon" >> input-intra2.dat
echo "set             group He charge $chargehydrogen" >> input-intra2.dat
echo "set             group Na charge 0.000" >> input-intra2.dat
echo "" >> input-intra2.dat
echo "pair_style      hybrid/overlay lj/cut/coul/long 12.0 12.0 born 12.0" >> input-intra2.dat
echo "#spc water" >> input-intra2.dat
echo "pair_coeff      1 1 lj/cut/coul/long 0.15535 3.1660" >> input-intra2.dat
echo "pair_coeff      1 2 lj/cut/coul/long 0.00000 0.0000" >> input-intra2.dat
echo "pair_coeff      2 2 lj/cut/coul/long 0.00000 0.0000" >> input-intra2.dat
echo "" >> input-intra2.dat
echo "" >> input-intra2.dat
echo "pair_coeff      1 3 lj/cut/coul/long 0.10428 3.35800"  >> input-intra2.dat
echo "pair_coeff      2 3 lj/cut/coul/long 0.00000 0.00000" >> input-intra2.dat
echo "pair_coeff      3 3 lj/cut/coul/long 0.07000 3.55000" >> input-intra2.dat
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input-intra2.dat
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input-intra2.dat
echo "#c10h8water O & H with the solute Os (lambda is average)" >> input-intra2.dat
echo "pair_coeff      1 4 lj/cut/coul/long 0.06827 2.79300" >> input-intra2.dat
echo "pair_coeff      2 4 lj/cut/coul/long 0.00000 0.00000"  >> input-intra2.dat
echo "pair_coeff      3 4 lj/cut/coul/long 0.04583 2.98500" >> input-intra2.dat
echo "pair_coeff      4 4 lj/cut/coul/long 0.03000 2.42000" >> input-intra2.dat
echo "" >> input-intra2.dat
echo "pair_coeff      1 5 lj/cut/coul/long 0.10428 3.35800" >> input-intra2.dat
echo "pair_coeff      2 5 lj/cut/coul/long 0.00000 0.00000" >> input-intra2.dat
echo "pair_coeff      3 5 lj/cut/coul/long 0.07000 3.55000" >> input-intra2.dat
echo "pair_coeff      4 5 lj/cut/coul/long 0.04583 2.98500" >> input-intra2.dat
echo "pair_coeff      5 5 lj/cut/coul/long 0.07000 3.55000" >> input-intra2.dat
echo "" >> input-intra2.dat
echo "pair_coeff      1 6 lj/cut/coul/long 0.00000 0.00000" >> input-intra2.dat
tail -70 input_intra.dat >> input-intra2.dat
###########################################################################

#assign perturbed charges for data samplings with only the solute charges
###########################################################################                                                                                                                                    
head -32 input_intra.dat > input-intra4.dat
echo "set             group C charge $chargecarbonp" >> input-intra4.dat
echo "set             group He charge $chargehydrogenp" >> input-intra4.dat
echo "set             group Na charge 0.000" >> input-intra4.dat
echo "" >> input-intra4.dat
echo "pair_style      hybrid/overlay lj/cut/coul/long 12.0 12.0 born 12.0" >> input-intra4.dat
echo "#spc water" >> input-intra4.dat
echo "pair_coeff      1 1 lj/cut/coul/long 0.15535 3.1660" >> input-intra4.dat
echo "pair_coeff      1 2 lj/cut/coul/long 0.00000 0.0000" >> input-intra4.dat
echo "pair_coeff      2 2 lj/cut/coul/long 0.00000 0.0000" >> input-intra4.dat
echo "" >> input-intra4.dat
echo "" >> input-intra4.dat
echo "pair_coeff      1 3 lj/cut/coul/long 0.10428 3.35800"  >> input-intra4.dat
echo "pair_coeff      2 3 lj/cut/coul/long 0.00000 0.00000" >> input-intra4.dat
echo "pair_coeff      3 3 lj/cut/coul/long 0.07000 3.55000" >> input-intra4.dat
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input-intra4.dat
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input-intra4.dat
echo "#c10h8water O & H with the solute Os (lambda is average)" >> input-intra4.dat
echo "pair_coeff      1 4 lj/cut/coul/long 0.06827 2.79300" >> input-intra4.dat
echo "pair_coeff      2 4 lj/cut/coul/long 0.00000 0.00000"  >> input-intra4.dat
echo "pair_coeff      3 4 lj/cut/coul/long 0.04583 2.98500" >> input-intra4.dat
echo "pair_coeff      4 4 lj/cut/coul/long 0.03000 2.42000" >> input-intra4.dat
echo "" >> input-intra4.dat
echo "pair_coeff      1 5 lj/cut/coul/long 0.10428 3.35800" >> input-intra4.dat
echo "pair_coeff      2 5 lj/cut/coul/long 0.00000 0.00000" >> input-intra4.dat
echo "pair_coeff      3 5 lj/cut/coul/long 0.07000 3.55000" >> input-intra4.dat
echo "pair_coeff      4 5 lj/cut/coul/long 0.04583 2.98500" >> input-intra4.dat
echo "pair_coeff      5 5 lj/cut/coul/long 0.07000 3.55000" >> input-intra4.dat
echo "" >> input-intra4.dat
echo "pair_coeff      1 6 lj/cut/coul/long 0.00000 0.00000" >> input-intra4.dat
tail -70 input_intra.dat >> input-intra4.dat
###########################################################################                                          

#run
#################################################
#1st equilibration
lammps_executable < input_1.dat > log_1.dat
#2nd equiliration
lammps_executable < input_2.dat > log_2.dat
\cp log.lammps log_2.lammps
###################################################                                                                                                                                                            
#get a fixed gewald factor of pppm from the long equilibration for subsequent data samplings
#"tail -7 log_2.lammps" --> not necessarily the first line of the last 7 lines --> depends on the lammps version 
tail -7 log_2.lammps | head -1 > gewald.dat
gcc gewald.c -o gewald -lm
./gewald gewald.dat > GE
ge=`echo $OUTPUT | awk '{print ($1)}' GE`
######################################                                   
#assign a fixed gewald factor of pppm for data samplings
head -68 ./input-continue > ./input-continue1
echo "kspace_modify  gewald $ge" >> ./input-continue1
tail -62 ./input-continue >> ./input-continue1
\mv ./input-continue1 ./input-continue

head -68 ./input-real3.dat > ./input-real3
echo "kspace_modify  gewald $ge" >> ./input-real3
tail -62 ./input-real3.dat >> ./input-real3
\mv ./input-real3 ./input-real3.dat

head -68 ./input-real4.dat > ./input-real4
echo "kspace_modify  gewald $ge" >> ./input-real4
tail -62 ./input-real4.dat >> ./input-real4
\mv ./input-real4 ./input-real4.dat

head -68 ./input-intra2.dat > ./input-intra2
echo "kspace_modify  gewald $ge" >> ./input-intra2
tail -62 ./input-intra2.dat >> ./input-intra2
\mv ./input-intra2 ./input-intra2.dat

head -68 ./input-intra4.dat > ./input-intra4
echo "kspace_modify  gewald $ge" >> ./input-intra4
tail -62 ./input-intra4.dat >> ./input-intra4
\mv ./input-intra4 ./input-intra4.dat
######################################

#continued runs and data samplings 
(for ((i=1; i<$M+1; i++)); do

    #"tail -32 log_continue.lammps" --> sample energetic output
    #tail -32 log_continue.lammps --> not necessarily the first line of the last 32 lines --> depends on the lammps version
    #similarly for "tail -22 log_intra2.lammps" etc.
    lammps_executable < input-continue >> log_continue_$O
    \cp log.lammps log_continue.lammps
    tail -32 log_continue.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies_id_$O.dat
    
    lammps_executable < input-real3.dat >> log_real3_$O
    \cp log.lammps log_real3.lammps
    tail -23 log_real3.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies3_$O.dat

    lammps_executable < input-real4.dat >> log_real4_$O
    \cp log.lammps log_real4.lammps
    tail -23 log_real4.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies4_$O.dat

    lammps_executable < input-intra2.dat >> log_intra2_$O
    \cp log.lammps log_intra2.lammps
    tail -23 log_intra2.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies_intra2_$O.dat

    lammps_executable < input-intra4.dat >> log_intra4_$O
    \cp log.lammps log_intra4.lammps
    tail -23 log_intra4.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies_intra4_$O.dat

done)

\cp $node/* $wd 
rm -rf $node 
cd $wd
\cp old_config_1.dat old_config_1_$O.dat
\cp data_restart_continue data_restart_continue_$O
\mv energies_id_$O.dat energies_id.dat
\mv energies3_$O.dat energies3.dat
\mv energies4_$O.dat energies4.dat
\mv energies_intra2_$O.dat energies_intra2.dat
\mv energies_intra4_$O.dat energies_intra4.dat
\mv log_continue_$O log_continue
\mv log_real3_$O log_real3
\mv log_real4_$O log_real4
\mv log_intra2_$O log_intra2
\mv log_intra4_$O log_intra4

