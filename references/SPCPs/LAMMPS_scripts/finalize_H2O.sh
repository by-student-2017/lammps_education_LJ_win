#!/bin/bash
#$ -M jcarpen3@nd.edu
#$ -m abe
#$ -q hpc@@colon
#$ -pe smp 8
 

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
	old_step_num=1000
	mkdir Finalization_f${func_str}_H2O
	cd Finalization_f${func_str}_H2O

	if [ ${step_num} -lt 100 ]
	then
		old_step_num=${step_num}
		step_num="0${step_num}"
		echo ${step_num}
	fi

	cp ../step_${step_num}/init.lmps data.lmps
	sed -i 's/9    14.006700000 # N_x/9    14.006700000 # N_x\n10   15.999400000 # O_x/g' data.lmps
	sed -i 's/9 atom types/10 atom types/g' data.lmps
	sed -i 's/9        0.069000        3.260689 # N_x N_x/9        0.069000        3.260689 # N_x N_x\n10        0.060000        3.118146 # O_x O_x/g' data.lmps
	cp ../ref.lmps .
	sed -i 's/9    14.006700000 # N_x/9    14.006700000 # N_x\n10   15.999400000 # O_x/g' ref.lmps
	sed -i 's/9 atom types/10 atom types/g' ref.lmps
	sed -i 's/9        0.069000        3.260689 # N_x N_x/9        0.069000        3.260689 # N_x N_x\n10        0.060000        3.118146 # O_x O_x/g' ref.lmps
	cp data.lmps temp.lmps
	cp ../polym_loop_finalize_H2O.sh .
	cp ../H2O.lmps .
	cp ../add1linker.py .
	cp ../types_H2O.txt ./types.txt
	cp -r ../scripts_H2O/ ./scripts

	if [ ${old_step_num} -lt 100 ]
	then
		source polym_loop_finalize_H2O.sh ${old_step_num}
	else
		source polym_loop_finalize_H2O.sh ${step_num}
	fi

	cd ..
done
