#!/bin/bash
#this is the script to edit input files according to "k_TI.dat"

rm -rf $node 
mkdir $node
cd $node
#this is to copy all the input files from "IFile_A1_vdwl_EA1" here
\cp $location2/* ./

N=400 #number of data samplings
M=240 #number of molecules in the crystal  
#We need M=240 to sample the intramolecular vdwl energies one molecule by one molecule
#so that we can add them up to substract the sum from the total electrotatic energy, in order to obtain the total intermolecular vdwl energy of the whole crystal at each sampling step 

#"fixed" --> Orientational + Central Atoms/Springs 
#"pair_coeff" --> atomic vdwl paramters
#read "submit_A1_vdwl_EA1.sh" for "$e11", "$e12" and "$e22".
#read input files in "IFile_A1_vdwl_EA1" for more details
################################  
head -94 input_init.dat > input_init_1.dat
echo "fix            2 fixed spring/self $kmax" >> input_init_1.dat
tail -17 input_init.dat >> input_init_1.dat

head -35 input_init_1.dat > input_init_2.dat
echo "pair_coeff      1 1 $e11 $s11" >> input_init_2.dat
echo "pair_coeff      1 2 $e12 $s12" >>input_init_2.dat
echo "pair_coeff      2 2 $e22 $s22" >>input_init_2.dat
echo "" >>input_init_2.dat
echo "pair_coeff      1 3 $e11 $s11" >>input_init_2.dat
echo "pair_coeff      2 3 $e12 $s12" >>input_init_2.dat
echo "pair_coeff      3 3 $e11 $s11" >>input_init_2.dat
echo "" >>input_init_2.dat
echo "pair_coeff      1 4 $e11 $s11" >>input_init_2.dat
echo "pair_coeff      2 4 $e12 $s12" >>input_init_2.dat
echo "pair_coeff      3 4 $e11 $s11" >>input_init_2.dat
echo "pair_coeff      4 4 $e11 $s11" >>input_init_2.dat
echo "" >>input_init_2.dat
echo "pair_coeff      1 5 $e11 $s11" >>input_init_2.dat
echo "pair_coeff      2 5 $e12 $s12" >>input_init_2.dat
echo "pair_coeff      3 5 $e11 $s11" >>input_init_2.dat
echo "pair_coeff      4 5 $e11 $s11" >>input_init_2.dat
echo "pair_coeff      5 5 $e11 $s11" >>input_init_2.dat
tail -59 input_init_1.dat >> input_init_2.dat 

head -61 input_init_2.dat > input_init.dat
echo "pair_coeff      1 7 $e11 $s11" >> input_init.dat
echo "pair_coeff      2 7 $e12 $s12" >> input_init.dat
echo "pair_coeff      3 7 $e11 $s11" >> input_init.dat
echo "pair_coeff      4 7 $e11 $s11" >> input_init.dat
echo "pair_coeff      5 7 $e11 $s11" >> input_init.dat
echo "pair_coeff      6 7 0.000 0.000" >> input_init.dat
echo "pair_coeff      7 7 $e11 $s11" >> input_init.dat
tail -44 input_init_2.dat >> input_init.dat
#rm -rf input_init_2.dat input_init_1.dat
################################ 

#edit the input files accoriding to "k_TI.dat" for data samplings
################################ 
head -94 input_continue.dat > input_1.dat
echo "fix            2 fixed spring/self $kmax" >> input_1.dat
tail -17 input_continue.dat >> input_1.dat

head -35 input_1.dat > input_2.dat
echo "pair_coeff      1 1 $e11 $s11" >> input_2.dat
echo "pair_coeff      1 2 $e12 $s12" >>input_2.dat
echo "pair_coeff      2 2 $e22 $s22" >>input_2.dat
echo "" >>input_2.dat
echo "pair_coeff      1 3 $e11 $s11" >>input_2.dat
echo "pair_coeff      2 3 $e12 $s12" >>input_2.dat
echo "pair_coeff      3 3 $e11 $s11" >>input_2.dat
echo "" >>input_2.dat
echo "pair_coeff      1 4 $e11 $s11" >>input_2.dat
echo "pair_coeff      2 4 $e12 $s12" >>input_2.dat
echo "pair_coeff      3 4 $e11 $s11" >>input_2.dat
echo "pair_coeff      4 4 $e11 $s11" >>input_2.dat
echo "" >>input_2.dat
echo "pair_coeff      1 5 $e11 $s11" >>input_2.dat
echo "pair_coeff      2 5 $e12 $s12" >>input_2.dat
echo "pair_coeff      3 5 $e11 $s11" >>input_2.dat
echo "pair_coeff      4 5 $e11 $s11" >>input_2.dat
echo "pair_coeff      5 5 $e11 $s11" >>input_2.dat
tail -59 input_1.dat >> input_2.dat

head -61 input_2.dat > input.dat
echo "pair_coeff      1 7 $e11 $s11" >> input.dat
echo "pair_coeff      2 7 $e12 $s12" >> input.dat
echo "pair_coeff      3 7 $e11 $s11" >> input.dat
echo "pair_coeff      4 7 $e11 $s11" >> input.dat
echo "pair_coeff      5 7 $e11 $s11" >> input.dat
echo "pair_coeff      6 7 0.000 0.000" >> input.dat
echo "pair_coeff      7 7 $e11 $s11" >> input.dat
tail -44 input_2.dat >> input.dat
rm -rf input_1.dat input_2.dat 
################################ 

#edit the input files accoriding to "k_TI.dat" for data samplings of intramolecular vdwl energies 
################################                                                                                                                                                                                                                          
head -94 input_continue_single2.dat > input_single2_1.dat
echo "fix            2 fixed spring/self $kmax" >> input_single2_1.dat
tail -17 input_continue_single2.dat >> input_single2_1.dat

head -35 input_single2_1.dat > input_single2_2.dat
echo "pair_coeff      1 1 $e11 $s11" >> input_single2_2.dat
echo "pair_coeff      1 2 $e12 $s12" >>input_single2_2.dat
echo "pair_coeff      2 2 $e22 $s22" >>input_single2_2.dat
echo "" >>input_single2_2.dat
echo "pair_coeff      1 3 $e11 $s11" >>input_single2_2.dat
echo "pair_coeff      2 3 $e12 $s12" >>input_single2_2.dat
echo "pair_coeff      3 3 $e11 $s11" >>input_single2_2.dat
echo "" >>input_single2_2.dat
echo "pair_coeff      1 4 $e11 $s11" >>input_single2_2.dat
echo "pair_coeff      2 4 $e12 $s12" >>input_single2_2.dat
echo "pair_coeff      3 4 $e11 $s11" >>input_single2_2.dat
echo "pair_coeff      4 4 $e11 $s11" >>input_single2_2.dat
echo "" >>input_single2_2.dat
echo "pair_coeff      1 5 $e11 $s11" >>input_single2_2.dat
echo "pair_coeff      2 5 $e12 $s12" >>input_single2_2.dat
echo "pair_coeff      3 5 $e11 $s11" >>input_single2_2.dat
echo "pair_coeff      4 5 $e11 $s11" >>input_single2_2.dat
echo "pair_coeff      5 5 $e11 $s11" >>input_single2_2.dat
tail -59 input_single2_1.dat >> input_single2_2.dat

head -61 input_single2_2.dat > input_single2_3.dat
echo "pair_coeff      1 7 $e11 $s11" >> input_single2_3.dat
echo "pair_coeff      2 7 $e12 $s12" >> input_single2_3.dat
echo "pair_coeff      3 7 $e11 $s11" >> input_single2_3.dat
echo "pair_coeff      4 7 $e11 $s11" >> input_single2_3.dat
echo "pair_coeff      5 7 $e11 $s11" >> input_single2_3.dat
echo "pair_coeff      6 7 0.000 0.000" >> input_single2_3.dat
echo "pair_coeff      7 7 $e11 $s11" >> input_single2_3.dat
tail -44 input_single2_2.dat >> input_single2_3.dat
rm -rf input_single2_2.dat input_single2_1.dat
################################                                                                                                                                                                                                                           

#equilibration run
################################
lammps_executable < input_init.dat > log_init_$O.dat
\cp log.lammps log_init_$O.lammps
################################ 
#we fix the gewald faction of pppm summation for all subsequent data samplings
#for the gewald factor of pppm summation in LAMMPS, we can take the final value from log_init_$O.lammps 
#below we descibe how to get the gewald factor from log_init_$O.lammps and assign to all input files (if this is desired) for further data samplings 
################################
#"tail -7 log_init_$O.lammps" --> the exact line depends on lammps version, not necessarily the first line of the last 7 lines
tail -7 log_init_$O.lammps | head -1 > gewald.dat
gcc gewald.c -o gewald -lm 
./gewald gewald.dat > GE
ge=`echo $OUTPUT | awk '{print ($1)}' G`
#rm -rf GE
################################
#assign the fixed gewald factor of pppm summation for data samplings
head -70 input.dat > input_1.dat
echo "kspace_modify  gewald $ge" >> input_1.dat
tail -41 input.dat >> input_1.dat
\mv input_1.dat input.dat

head -70 input_single2_3.dat > input_single2_3_1.dat
echo "kspace_modify  gewald $ge" >> input_single2_3_1.dat
tail -41 input_single2_3.dat >> input_single2_3_1.dat
\mv input_single2_3_1.dat input_single2_3.dat
################################

#data samplings
################################

(for((i=1; i<$N+1; i++)); do

    #"tail -32 log_$O.lammps" --> the exact line depends on the lammps version, not necessarily the first line of the last 32 lines
    #similarly for "tail -23 log_single2_$O.lammps"
    lammps_executable < input.dat >> log_$O.dat
    \cp log.lammps log_$O.lammps 
    tail -32 log_$O.lammps | head -1 | awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies_$O.dat 


    (for((j=1; j<$M+1; j++)); do

	#sample N = 240 sample intramolecular vdwl energies one molecule by one molecule
	####################################### 
	head -94 input_single2_3.dat > input_single2.dat
        echo "fix            2 fixed spring/self $kmax" >> input_single2.dat
        tail -17 input_single2_3.dat >> input_single2.dat

        head -25 input_single2.dat > input_single2_2.dat
        echo "group           single molecule != $j" >> input_single2_2.dat
        tail -86 input_single2.dat >> input_single2_2.dat
        \cp input_single2_2.dat input_single2.dat

        lammps_executable < input_single2.dat > log_single2_$O.dat
        \cp log.lammps log_single2_$O.lammps
        tail -23 log_single2_$O.lammps | head -1 | awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31}' >> energies_single2_$O.dat
        #######################################                                                                                                                                                                                                            
        done)

    done)

\cp $node/* $wd 
rm -rf $node 
cd $wd
\cp old_config_1.dat old_config_1_$O.dat
cat energies_$O.dat >> energies.dat 
cat energies_single2_$O.dat >> energies_single2.dat
rm -rf energies_$O.dat energies_single2_$O.dat
