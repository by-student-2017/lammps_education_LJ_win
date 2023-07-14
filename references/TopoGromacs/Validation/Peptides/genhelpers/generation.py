#!/usr/bin/env python

import os
import subprocess
from multiprocessing import Pool
def mymkdir(s):
	if not os.path.exists(s):
		os.makedirs(s)
psfgenscript = '''package require psfgen

topology ../../../../toppar/top_all36_prot.rtf
set resname %s
set res1 [string range $resname 0 2]
set res2 [string range $resname 3 5]
set res3 [string range $resname 6 8]
if { $res1 == "GLY" } {
	set nter GLYP
} elseif { $res1 == "PRO" } {
	set nter PROP
} else {
	set nter NTER
}
segment P {
	residue 1 $res1
	residue 2 $res2
	residue 3 $res3
	first $nter
	last CTER
}
coord P 1 CA [list 1.500   0.000   0.000]
coord P 1 C [list 2.052   1.275  -0.565]
coord P 1 O [list 3.552   1.271  -0.575]

guesscoord
writepsf $resname.psf
writepdb $resname.pdb
exit
'''
minimizationscript = '''
structure %s.psf
coordinates %s.pdb

paraTypeCharmm on
parameters          ../../../../toppar/par_all36_prot.prm
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
parameters      ../../../../toppar/par_all36_prot.prm
temperature     0
# integrator params
timestep        1.0
exclude         scaled1-4
1-4scaling      1.0
rigidBonds      none
switching off
cutoff          90.0
pairlistdist    110.0

mergeCrossterms no ; #Makes CMAP seperate from dihedral terms.

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
topo writegmxtop $resname.top [list ../../../../toppar/par_all36_prot.prm ]
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
	subprocess.call("gmx grompp -f ../../../genhelpers/run.mdp -c %s.pdb -p %s.top -o %s.tpr" % (resname, resname, resname), shell=True)
	subprocess.call("gmx mdrun -s %s.tpr -o %s -e %s.edr -xvg none" % (resname, resname, resname), shell=True)
	os.chdir('../..')
if __name__ == '__main__':
	fin = open("../../toppar/top_all36_prot.rtf")
	lines = fin.readlines()
	fin.close()
	os.chdir("../")
	mymkdir("the8000")
	os.chdir("the8000")
	resnames = ["ALA", "ILE", "LEU", "MET", "PHE", "TRP", "TYR", "VAL", "SER", "THR", "ASN", "GLN", "CYS", "GLY", "PRO", "ARG", "HSD", "LYS", "ASP", "GLU"]
	resnamelist = []
	for res1 in resnames:
		for res2 in resnames:
			for res3 in resnames:
				resnamelist.append(res1 + res2 + res3)
	#resnamelist = resnamelist[:10]
	pool = Pool(4)
	pool.map(innerloop, resnamelist)
	pool.close()
	pool.join()
	#for resname in resnamelist:
	#	if not os.path.exists(resname + "/NAMD/run.log"):
	#		#print resname
	#		innerloop(resname)