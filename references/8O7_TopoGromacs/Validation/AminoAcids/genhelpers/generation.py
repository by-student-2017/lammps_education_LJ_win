#!/usr/bin/env python

import os
import subprocess
from multiprocessing import Pool
def mymkdir(s):
	if not os.path.exists(s):
		os.makedirs(s)
psfgenscript = '''package require psfgen

topology ../../../toppar/top_all36_prot.rtf
set resname %s
if { $resname == "PRO" } {
	set nter PROP
} elseif { $resname == "GLY" } {
	set nter GLYP
} else {
	set nter NTER
}
segment P {
	residue 1 $resname
	first $nter
	last CTER
}
coord P 1 CA [list 1.500   0.000   0.000]
coord P 1 C [list 2.052   1.275  -0.565]
coord P 1 OT1 [list 3.552   1.271  -0.575]

guesscoord
writepsf $resname.psf
writepdb $resname.pdb
exit
'''
minimizationscript = '''
structure %s.psf
coordinates %s.pdb

paraTypeCharmm on
parameters           ../../../toppar/par_all36_prot.prm
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
parameters      ../../../toppar/par_all36_prot.prm
temperature     0
# integrator params
timestep        1.0
exclude         scaled1-4
1-4scaling      1.0
rigidBonds      none
switching off
cutoff          90.0
pairlistdist    110.0

mergeCrossterms yes

outputTiming         1000
outputEnergies 1000
restartfreq         1000
dcdfreq             1000
xstFreq             1000

run 10000
'''
gmxpreptcl = '''package require topotools
set resname %s
mol load psf ../INPUT/$resname.psf pdb ../INPUT/minimize.coor
topo writegmxtop $resname.top [list ../../../toppar/par_all36_prot.prm ]
[atomselect top "all"] writepdb $resname.pdb
exit
'''
def innerloop (resname):
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
if __name__ == '__main__':
	fin = open("../../toppar/top_all36_prot.rtf")
	lines = fin.readlines()
	fin.close()
	os.chdir("../")
	resnames = ["ALA", "ILE", "LEU", "MET", "PHE", "TRP", "TYR", "VAL", "SER", "THR", "ASN", "GLN", "CYS", "GLY", "PRO", "ARG", "HSD", "LYS", "ASP", "GLU"]
	resnamelist = []
	for res1 in resnames:
		resnamelist.append(res1)
	#resnamelist = resnamelist[:10]
	#pool = Pool(10)
	#pool.map(innerloop, resnamelist)
	#pool.close()
	#pool.join()
	for resname in resnamelist:
		innerloop(resname)