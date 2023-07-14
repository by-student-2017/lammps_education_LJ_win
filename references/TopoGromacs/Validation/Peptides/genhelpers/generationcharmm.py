#!/usr/bin/env python

import os
import subprocess
from multiprocessing import Pool
def mymkdir(s):
	if not os.path.exists(s):
		os.makedirs(s)

namdrun = '''* Run the 8000 with CHARMM for comparison purposes.
*

set RESNAME %s
open unit 1 read form name "../../../../toppar/top_all36_prot.rtf"
read rtf card unit 1
close unit 1
open unit 1 read form name "../../../../toppar/par_all36_prot.prm"
read param card flex unit 1
close unit 1

read sequ pdb name "../INPUT/minimize.coor"
generate P setup first %s last cter
read coor pdb name "../INPUT/minimize.coor"
!write psf card name "@RESNAME.psf"

prnlev 3 node 0
open write unit 14 unform name run.dcd
dynamics leap start timestep 0.001 nstep 10000 nprint 1000  iprfrq 1000 -
     firstt 0 finalt 0 -
     iasors 1 iasvel 1 iscvel 0  -
     inbfrq -1 imgfrq -1 ilbfrq 0 iuncrd 14 -
     nbxmod  5 atom cdiel switch vatom vdistance vfswitch -
     cutnb 120.0 ctofnb 99.0 ctonnb 98.0 eps 1.0 e14fac 1.0 wmin 1.5 

stop
'''
#psfgen doesn't make *completely* legal CHARMM psfs. Or at least my version of CHARMM can't read them due to lone pairs not being specified.

def innerloop (resname):
	print resname
	res1 = resname[:3]
	if res1 == "GLY":
		nter = "glyp"
	elif res1 == "PRO":
		nter = "prop"
	else:
		nter = "nter"
	mymkdir(resname)
	os.chdir(resname)
	mymkdir("CHARMM")
	os.chdir("CHARMM")
	fout = open("run.inp", 'w')
	fout.write(namdrun % (resname, nter))
	fout.close()
	subprocess.call("charmm < run.inp > run.log", shell=True)
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
	#	#if not os.path.exists(resname + "/CHARMM/run.log"):
	#	print resname
	#	innerloop(resname)
	#	exit()