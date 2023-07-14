#!/usr/bin/env python

import os
import subprocess
def mymkdir(s):
	if not os.path.exists(s):
		os.makedirs(s)
psfgenscript = '''package require psfgen

topology ../../../toppar/top_all36_carb.rtf
set resname %s
segment CARB {
	residue 1 $resname
	first NONE
	last NONE
}
if { [string equal $resname BFRU] || [string equal $resname AFRU] } {
	coord CARB 1 C2 [list 1.500   0.000   0.000]
	coord CARB 1 C3 [list 2.052   1.275  -0.565]
	coord CARB 1 C4 [list 3.552   1.271  -0.575]
} else {
	coord CARB 1 C1 [list 1.500   0.000   0.000]
	coord CARB 1 C2 [list 2.052   1.275  -0.565]
	coord CARB 1 C3 [list 3.552   1.271  -0.575]
}

guesscoord
writepsf $resname.psf
writepdb $resname.pdb
exit
'''
minimizationscript = '''
structure %s.psf
coordinates %s.pdb

paraTypeCharmm on
parameters           ../../../toppar/par_all36_carb.prm
exclude              scaled1-4
1-4scaling           1.0
temperature          0
switching off
cutoff 12
pairlistdist 14
outputname minimize
outputtiming         1000
outputenergies 1000
binaryoutput no
minimize 1000
'''
namdrun = '''set resname %s
coordinates ../INPUT/minimize.coor
structure ../INPUT/$resname.psf
outputname $resname

paraTypeCharmm on
parameters      ../../../toppar/par_all36_carb.prm
temperature     0
# integrator params
timestep        1.0
exclude         scaled1-4
1-4scaling      1.0
rigidBonds      none
switching off
cutoff          90.0
pairlistdist    110.0

outputTiming         1000
outputEnergies 100
restartfreq         1000
dcdfreq             100
xstFreq             1000

run 10000
'''
gmxpreptcl = '''package require topotools
set resname %s
mol load psf ../INPUT/$resname.psf pdb ../INPUT/minimize.coor
topo writegmxtop $resname.top [list ../../../toppar/par_all36_carb.prm ]
[atomselect top "all"] writepdb $resname.pdb
exit
'''

fin = open("../../toppar/top_all36_carb.rtf")
lines = fin.readlines()
fin.close()
os.chdir("../")
for line in lines:
	if line[:4] == "RESI":
		resname = line.split()[1]
		if len(resname) > 3: #Removes the ions at the end.
			print resname
			mymkdir(resname)
			os.chdir(resname)
			mymkdir("INPUT")
			mymkdir("NAMD")
			mymkdir("gmx")
			os.chdir("INPUT")
			fout = open("makeres.tcl", "w")
			fout.write(psfgenscript % resname)
			fout.close()
			subprocess.call("vmd -dispdev text -e makeres.tcl", shell=True)
			fout = open("minimize.namd", "w")
			fout.write(minimizationscript % (resname, resname))
			fout.close()
			subprocess.check_output("namd2 minimize.namd > minimize.log", shell=True)
			os.chdir('../NAMD')
			fout = open("run.namd", 'w')
			fout.write(namdrun % (resname))
			fout.close()
			subprocess.call("namd2 run.namd > run.log", shell=True)
			os.chdir("../gmx")
			fout = open("prep.tcl", 'w')
			fout.write(gmxpreptcl % (resname))
			fout.close()
			subprocess.call("vmd -dispdev text -e prep.tcl", shell=True)
			subprocess.call("gmx grompp -f ../../genhelpers/run.mdp -c %s.pdb -p %s.top -o %s.tpr" % (resname, resname, resname), shell=True)
			subprocess.call("gmx mdrun -s %s.tpr -o %s -e %s.edr -xvg none" % (resname, resname, resname), shell=True)
			os.chdir('../..')
exit()