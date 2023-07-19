#!/bin/bash
#this scripts edit the input files according to "lambda3.dat" and run simulations 

module load intel
rm -rf $node 
mkdir $node
cd $node
#copy all the input files and initial configuration from "IFile_grow" here 
#location2=$location/IFile_grow --> read "submit_grow_cavity.sh"
\cp $location2/* ./

O=0       #labelling parameter
M=3500    #number of data samplings

#first-stage equilibration
\cp input_init_1.dat input_1.dat 

#second-stage equilibration (e.g. 1-4ns)
#assign the equlibrilium lambda --> "submit_grow_cavity.sh" for the meaning of lambda and other parameters
head -46 input_init_2.dat > input_2.dat 
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input_2.dat 
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input_2.dat
tail -83 input_init_2.dat >> input_2.dat

#assign the equlibrilium lambda for data samplings
head -46 input_continue.dat > input-continue
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input-continue
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input-continue
tail -83 input_continue.dat >> input-continue

#assign the equilibrium lambda for data samplings ---> no dynamics but energietic output
head -46 input_real.dat > input-real3.dat
echo "pair_coeff      1 6 born $Astart $rho $lambdastart 0 0" >> input-real3.dat
echo "pair_coeff      6 6 born $Astart $rho $lambdastart 0 0" >> input-real3.dat
tail -83 input_real.dat >> input-real3.dat

#assign the perturbed lambda for data samplings ---> no dynamics but energietic output 
head -46 input_real.dat > input-real4.dat
echo "pair_coeff      1 6 born $Astop $rho $lambdastop 0 0" >> input-real4.dat
echo "pair_coeff      6 6 born $Astop $rho $lambdastop 0 0" >> input-real4.dat
tail -83 input_real.dat >> input-real4.dat

#run simulations
#############################################
#first-stage equilibration
lammps_exectutable < input_1.dat > log_1.dat
#second-stage equilibration
lammps_exectutable < input_2.dat > log_2.dat
\cp log.lammps log_2.lammps
###################################################                                                                                                                               
#we fix the gewald faction of pppm summation for all subsequent data samplings
#for the gewald factor of pppm summation in LAMMPS, we can take the final value from log_2.lammps, so that gewald is fixed for all data samplings
#"tail -7 log_2.lammps" --> the exact line depends on lammps version, not necessarily the first line of the last 7 lines
tail -7 log_2.lammps | head -1 > gewald.dat
gcc gewald.c -o gewald -lm
./gewald gewald.dat > GE
ge=`echo $OUTPUT | awk '{print ($1)}' GE`
#rm -rf GE
######################################                                   
#assign the fixed gewald factor of pppm summation for data samplings
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
######################################

(for ((i=1; i<$M+1; i++)); do

    #"tail -32" might be different for different versions of lammps to print out the energetic output
    #similarly for "tail -23 log_real3.lammps"
    lammps_exectutable < input-continue >> log_continue_$O
    \cp log.lammps log_continue.lammps
    tail -32 log_continue.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies_id_$O.dat
    
    lammps_exectutable < input-real3.dat >> log_real3_$O
    \cp log.lammps log_real3.lammps
    tail -23 log_real3.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies3_$O.dat

    lammps_exectutable < input-real4.dat >> log_real4_$O
    \cp log.lammps log_real4.lammps
    tail -23 log_real4.lammps | head -1 |awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies4_$O.dat

done)

\cp $node/* $wd 
rm -rf $node 
cd $wd
\cp old_config_1.dat old_config_1_$O.dat
\cp data_restart_continue data_restart_continue_$O
\mv energies_id_$O.dat energies_id.dat
\mv energies3_$O.dat energies3.dat
\mv energies4_$O.dat energies4.dat
