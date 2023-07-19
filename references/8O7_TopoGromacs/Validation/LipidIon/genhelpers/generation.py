#!/usr/bin/env python

import os
import subprocess
def mymkdir(s):
	if not os.path.exists(s):
		os.makedirs(s)
psfgenscript = '''package require psfgen

topology ../../../toppar/top_all36_lipid.rtf
topology ../../../toppar/top_water_ions.inp
set resname %s
segment LIP {
	residue 1 $resname
	first NONE
	last NONE
}

coord LIP 1 C1 [list -0.582 -2.060 -1.858]
coord LIP 1 C2 [list -0.485 -0.991 -0.751] 
coord LIP 1 C3 [list -1.731 -0.010 -0.566]
segment ION {
	residue 1 SOD
	first NONE
	last NONE
}
coord ION 1 SOD [list -5 0 0]
guesscoord
writepsf $resname.psf
writepdb $resname.pdb
exit
'''
minimizationscript = '''
structure %s.psf
coordinates %s.pdb

paraTypeCharmm on
parameters           ../../../toppar/par_all36_lipid.prm
parameters           ../../../toppar/par_water_ions.prm
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
parameters      ../../../toppar/par_all36_lipid.prm
parameters ../../../toppar/par_water_ions.prm
%s
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
topo writegmxtop $resname.top [list ../../../toppar/par_all36_lipid.prm ../../../toppar/par_water_ions.prm %s ]
[atomselect top "all"] writepdb $resname.pdb
exit
'''

fin = open("../../toppar/top_all36_lipid.rtf")
lines = fin.readlines()
fin.close()
os.chdir("../")
for line in lines:
	if line[:4] == "RESI":
		resname = line.split()[1]
		if len(resname) > 3:
			print resname
			mymkdir(resname)
			os.chdir(resname)
			mymkdir("INPUT")
			mymkdir("NAMD")
			mymkdir("gmx")
			mymkdir("NAMDnofix")
			mymkdir("gmxnofix")
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
			fout.write(namdrun % (resname, "parameters ../../../toppar/par_sodnbfix.prm"))
			fout.close()
			subprocess.call("namd2 run.namd > run.log", shell=True)
			os.chdir('../NAMDnofix')
			fout = open("run.namd", 'w')
			fout.write(namdrun % (resname, ""))
			fout.close()
			subprocess.call("namd2 run.namd > run.log", shell=True)
			os.chdir("../gmx")
			fout = open("prep.tcl", 'w')
			fout.write(gmxpreptcl % (resname, "../../../toppar/par_sodnbfix.prm"))
			fout.close()
			subprocess.call("vmd -dispdev text -e prep.tcl", shell=True)
			subprocess.call("gmx grompp -f ../../genhelpers/run.mdp -c %s.pdb -p %s.top -o %s.tpr" % (resname, resname, resname), shell=True)
			subprocess.call("gmx mdrun -s %s.tpr -o %s -e %s.edr -xvg none" % (resname, resname, resname), shell=True)
			os.chdir("../gmxnofix")
			fout = open("prep.tcl", 'w')
			fout.write(gmxpreptcl % (resname, ""))
			fout.close()
			subprocess.call("vmd -dispdev text -e prep.tcl", shell=True)
			subprocess.call("gmx grompp -f ../../genhelpers/run.mdp -c %s.pdb -p %s.top -o %s.tpr" % (resname, resname, resname), shell=True)
			subprocess.call("gmx mdrun -s %s.tpr -o %s -e %s.edr -xvg none" % (resname, resname, resname), shell=True)
			os.chdir('../..')
			#exit()
exit()