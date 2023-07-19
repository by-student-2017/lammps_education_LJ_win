#!/bin/bash
#$ -M jcarpen3@nd.edu
#$ -m abe
#$ -q hpc@@colon
 

module load python

array=( 
 3.0
 4.0
 5.0
 6.0
 6.8)

array2=(
 3_0
 4_0
 5_0
 6_0
 6_8)

for index in ${!array[*]}
do
	func=${array[$index]}
	func_str=${array2[$index]}
	step_num=`python3 finalize.py ${func}`
	mkdir NPT_f${func_str}_H2O
	cd NPT_f${func_str}_H2O

	cp ../Finalization_f${func_str}_H2O/step_800/min.lmps finalized_glass_hardcore.lmps 
	sed -i '/Pair Coeffs/,/Atoms/c\Atoms\ # Full' finalized_glass_hardcore.lmps
	cp ../run_glass_H2O.job .
	cp ../NPT_switch_pot.in .
	cp ../NPT_T-ramp.in .
	cp ../NPT_hard.in .
	cp ../NPT_eqm_dyn_900K.in .
	cp ../fix_dat_molecules.py .
	cp ../ZnMOP-bix_potential.mod .
	sed -i 's/pair_coeff    9 9        0.069000        3.260689            # N_x N_x/pair_coeff    9 9        0.069000        3.260689            # N_x N_x \npair_coeff    10 10        0.060000        3.118146            # O_x O_x/g' ZnMOP-bix_potential.mod
	cp ../ZnMOP-bix_soft-pot.mod .
	cp ../NPT_glass_ramp_5Kps.in .
	cp ../NPT_glass_ramp_10Kps.in .
	cp ../NPT_glass_ramp_20Kps.in .
	cp ../NPT_glass_ramp_40Kps.in .
	cp ../run_glass_ramp_5Kps.job .
	cp ../run_glass_ramp_10Kps.job .
	cp ../run_glass_ramp_20Kps.job .
	cp ../run_glass_ramp_40Kps.job .

	cp finalized_glass_hardcore.lmps NPT_100K_polym_soft.lmps	
	qsub run_glass_H2O.job

	cd ..
done
