#!/bin/bash
#$ -M jcarpen3@nd.edu
#$ -m abe
#$ -q hpc@@colon
#$ -pe smp 32

###############################################################################
#
# polym_loop.sh
# This file is part of the Polymatic distribution.
#
# Description: Controls the simulated polymerization loop of the Polymatic
# algorithm. Polymerization steps are performed in cycles. After each bond is
# made, an energy minimization is performed in LAMMPS. After each cycle, a
# molecular dynamics step is performed in LAMMPS.
#
# Author: Lauren J. Abbott
# Version: 1.0
# Date: February 15, 2013
#
# Syntax:
#  ./polym_loop.sh
#
# User parameters and file paths necessary for the polymerization should be
# specified at the beginning of this script.
#
# LAMMPS instances can be found on lines 69, 155, and 185.
#
###############################################################################
#
# Polymatic: a general simulated polymerization algorithm
# Copyright (C) 2013 Lauren J. Abbott
#
# Polymatic is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Polymatic is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License (COPYING)
# along with Polymatic. If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################

#
# User parameters
#

bonds=0         # initial number of bonds (0 unless restart)
bondsTotal=800    # total number of bonds to form
bondsCycle=2     # bonds to form per cycle
mdMax=160         # maximum number of MD steps on bond attempts
cycleMd=3        # number of cycles between md steps of type 2
#lowT_switch=15   # number of bonds to make before switching to low T MD steps

#
# File paths (relative to base directory of run)
#

inputMd0="scripts/md0.in"              # LAMMPS input script, bond MD
inputMd1="scripts/md1.in"              # LAMMPS input script, cycle MD type 1
inputMd2="scripts/md2.in"              # LAMMPS input script, cycle MD type 2
inputMin="scripts/min.in"              # LAMMPS input script, minimization

#inputMd0_lT="scripts/md0_lT.in"        # LAMMPS input script, bond MD low T
#inputMd2_lT="scripts/md1_lT.in"        # LAMMPS input script, cycle MD type 1 low T
#inputMd3_lT="scripts/md2_lT.in"        # LAMMPS input script, cycle MD type 2 low T

inputPolym="scripts/polym.in"          # Polymatic input script
scriptPolym="scripts/polym.pl"         # Polymerization step script
scriptInit="scripts/polym_init.pl"     # Polymerization initializaiton script
scriptFinal="scripts/polym_final.pl"   # Polymerization finalization script

# LAMMPS
#module load lammps/17Feb12
module load lammps
module load python
#
# Functions
#

# Print error and exit
function errExit
{
	echo "polym_loop.sh: ${1:-'Unknown Error'}" 1>&2
	exit 2
}

# Error if copy fails
function cpErr
{
	cp $1 $2 || errExit "Could not copy '$1'."
}

# Make directory for polym step
function mkdirStep
{
	echo "Step ${bonds}:"
	directory=step_$(printf "%03d" $bonds)
	mkdir $directory || errExit "Could not make directory '$directory'."
	cd $directory
	cpErr ../scripts/fix_data.py fix_data.py
	cpErr ../scripts/fix_coeffs.py fix_coeffs.py
}

# Make directory for MD step
function mkdirMd
{
        if [[ $1 -eq 1 ]]; then
                directory=step_$(printf "%03d" $bonds)_md1
        elif [[ $1 -eq 2 ]]; then
                directory=step_$(printf "%03d" $bonds)_md2
	elif [[ $1 -eq 0 ]]; then
		directory=md_$polymMD
		[[ polymMD -gt 1 ]] && rm -r md_*
	fi

	mkdir $directory || errExit "Could not make directory '$directory'."
        cd $directory
}

# Polymerization initialization
function polymInit
{
	echo "Polymerization initialization"
	./$scriptInit -i data.lmps -t types.txt -s $inputPolym -o temp.lmps
	[[ $? -ne 0 ]] && errExit "Polymerization initialization script did" \
		"not complete properly."
	[[ -a temp.lmps ]] || errExit "File 'temp.lmps' not found."
	#cpErr data.lmps temp.lmps
}

# Polymerization finalization
function polymFinal
{
        echo "Polymerization finalization"
        ./$scriptFinal -i temp.lmps -t types.txt -s $inputPolym -o final.lmps
        [[ $? -ne 0 ]] && errExit "Polymerization finalization script did" \
                "not complete properly."
        [[ -a final.lmps ]] || errExit "File 'final.lmps' not found."
	#cpErr temp.lmps final.lmps
}

# Polymerization step
function polymStep
{
	# Copy files
	cpErr ../temp.lmps init.lmps

	# Polymerization step
	./../$scriptPolym -i init.lmps -t ../types.txt -s ../$inputPolym \
		-o data.lmps
	status=$?
}

# Energy minimization
function energyMin
{
	# Copy files
	[[ bonds -eq 0 ]] &&	cpErr ../temp.lmps data.lmps
	cpErr ../$inputMin min.in
	cpErr ../scripts/fix_data.py fix_data.py

	# Run energy minimization
	mpirun -np 32 lmp_mpi -in min.in > out
	[[ -a log.lammps && -a out ]] \
		|| errExit "Minimization did not complete properly 1."
#	[[ `tail -2 log.lammps | head -1` == "# DONE" ]] \
#		|| errExit "Minimization did not complete properly 2."

	# Convert restart to data
#	./../scripts/restart2data restart.* min.lmps > restart.out
#	[[ -a min.lmps ]] || errExit "Restart file was not converted properly."
	python fix_data.py ./min.lmps
	cpErr min.lmps ../temp.lmps
}

# Molecular dynamics
function molDyn
{
	# Copy files
	if [[ $1 -eq 0 ]]; then
		cpErr ../init.lmps data.lmps
		cpErr ../../$inputMd0 md.in
		cpErr ../../scripts/fix_data.py fix_data.py
		cpErr ../../scripts/fix_coeffs.py fix_coeffs.py
		cpErr ../../ref.lmps ../ref.lmps
	elif [[ $1 -eq 1 ]]; then
		cpErr ../temp.lmps data.lmps
		cpErr ../$inputMd1 md.in
		cpErr ../scripts/fix_data.py fix_data.py
		cpErr ../scripts/fix_coeffs.py fix_coeffs.py
	elif [[ $1 -eq 2 ]]; then
		cpErr ../temp.lmps data.lmps
		cpErr ../$inputMd2 md.in
		cpErr ../scripts/fix_data.py fix_data.py
		cpErr ../scripts/fix_coeffs.py fix_coeffs.py
	else
		errExit "MD type was not specified."
	fi

	# Run molecular dynamics
	mpirun -np 32 lmp_mpi -in md.in > out
	[[ -a log.lammps && -a out ]] \
		|| errExit "Molecular dynamics did not complete properly."
#	[[ `tail -1 log.lammps` == "# DONE" ]] \
#                || errExit "Molecular dynamics did not complete properly."

	# Convert restart to data
	if [[ $1 -eq 0 ]]; then
#		./../../scripts/restart2data restart.* md.lmps > restart.out
		[[ -a md.lmps ]] \
			|| errExit "Restart file was not converted properly."
		python fix_data.py ./md.lmps
		cpErr md.lmps ../../temp.lmps
	else
#		./../scripts/restart2data restart.* md.lmps > restart.out
		[[ -a md.lmps ]] \
                        || errExit "Restart file was not converted properly."
					cpErr ./../scripts/fix_data.py fix_data.py
					python fix_data.py ./md.lmps
        	cpErr md.lmps ../temp.lmps
	fi
}

#
# Initialization
#

# Output header
echo "Polymatic Simulated Polymerization"
echo ""
echo "Parameters"
echo "----------"
echo "Initial bonds:             ${bonds}"
echo "Total bonds:               ${bondsTotal}"
echo "Bonds per cycle:           ${bondsCycle}"
echo "Period of MD type 2:       ${cycleMd}"
echo ""
echo "Polymerization Loop"
echo "-------------------"

# Polymerization initialization
#polymInit

#
# Step 0
#
# Energy minimization
if [[ bonds -eq 0 ]]; then
	cpErr data.lmps ref.lmps
	cpErr data.lmps temp.lmps
	mkdirStep
	energyMin
	cd ..
fi

#
# Steps 1-N
#

# Continue loop until total bonds reached
while [[ bonds -lt bondsTotal ]]; do

	# Initialize
	(( bonds++ ))
	flag=0
	polymFlag=0
	polymMD=0

	mkdirStep

	# Attempt bonds until successful
	while [[ polymFlag -eq 0 ]]; do

		polymStep

		# status=0: normal
		if [[ status -eq 0 ]]; then
			polymFlag=1
			echo "  Attempts:" $(( polymMD + 1 ))
			python fix_coeffs.py ./data.lmps

		# status=3: no pair found
		elif [[ status -eq 3 ]]; then

			# Quit if maximum attempts reached
			if [[ polymMD -eq mdMax ]]; then
				echo "Reached maximum number of MD steps. " \
					"No pair found within cutoff."
				(( bonds-- ))
				flag=1
				cd ..
				break 2
			fi

			# Bond molecular dynamics
			(( polymMD++ ))
			mkdirMd 0
			molDyn 0
			cd ..

		# otherwise: error
		else
			errExit "Polymerization step did not complete properly."
		fi

	done

	# Energy minimization
	energyMin
	cd ..

	# Stop if total bonds reached
	[[ bonds -eq bondsTotal ]] && break

	# Cycle molecular dynamics
	if [[ $((bonds % bondsCycle)) -eq 0 ]]; then

		if [[ $(( (bonds / bondsCycle) % cycleMd)) -eq 0 ]]; then
			mkdirMd 2
			molDyn 2
			cd ..
		else
			mkdirMd 1
			molDyn 1
			cd ..
		fi
	fi

done

# Polymerization finalization
#polymFinal

# Percent complete
percent=`echo "scale=10; $bonds/$bondsTotal * 100" | bc`
percent=`printf '%.1f\n' $percent`

# Output summary
echo ""
echo "Summary"
echo "-------"
echo "Bonds completed:           ${bonds}"
echo "Percent complete:          ${percent}%"

exit
