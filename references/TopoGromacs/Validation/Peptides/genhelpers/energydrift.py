#!/usr/bin/env python

import numpy as np
import subprocess
import os
import matplotlib
from scipy import stats
matplotlib.use('Cairo')
matplotlib.rcParams['text.latex.preamble']=[r"\usepackage{amsmath}",r"\renewcommand{\seriesdefault}{\bfdefault}",
r"\usepackage{amsfonts}",
r"\usepackage{fixltx2e}", r'\boldmath'] #Using \boldmath makes the axis label numbers bold as well! Looks good.
params = {'text.usetex' : True,
          'font.family' : 'lmodern',
          'font.size' : 16,
          'text.latex.unicode': True,
          'figure.figsize' : (5.6, 4.2),
          'figure.dpi' : 200,
          'legend.fontsize' : 12,
          'legend.handletextpad' : 0.1,
          'legend.labelspacing' : 0.4,
          #'figure.autolayout' : True
          }
matplotlib.rcParams.update(params)
import matplotlib.pyplot as plt
def readDriftNAMD (logfile):
	data = np.empty(11, dtype=np.float)
	i = 0
	with open(logfile) as f:
		for line in f:
			if line[:6] == 'ENERGY':
				s = line.split()
				#This will return timestep, bond, angle, proper, CMAP, improper, elect, and VDW
				data[i] = float(s[12])
				i+=1
	#print data
	return np.amax(np.abs(data-data[0]))
def readDriftCHARMM (logfile):
	data = np.empty(11, dtype=np.float)
	i = 0
	fin = open(logfile)
	lines = fin.readlines()
	fin.close()
	lineno = 0
	while lineno < len(lines):
		line = lines[lineno]
		if line[:5] == "DYNA>":
			s = line.split()
			data[i] = float(s[3])
			i += 1
			lineno += 4
		lineno += 1
	return np.amax(np.abs(data-data[0]))
dirs = os.walk('../the8000').next()[1]
data = np.empty((len(dirs),3), dtype=np.float)
for i,d in enumerate(dirs):
	if d.isupper():
		#print d
		gmxdir = "../the8000/%s/gmx/" % d
		infile = "%s%s.edr" % (gmxdir,d)
		outfile = gmxdir + "energy-total.xvg"
		#Outfile will have timestep, bond, angle, proper, improper, CMAP, LJ14, Coulomb-14, LJ, and Coulomb terms
		subprocess.call("echo 12 | gmx energy -f %s -o %s -dp -xvg none" % (infile, outfile), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		gmxenergy = np.loadtxt(outfile)[:,1]
		gmxenergy = np.amax(np.abs(gmxenergy-gmxenergy[0])) / 4.184
		#print gmxenergy.shape
		namdenergy = readDriftNAMD("../the8000/%s/NAMD/run.log" % d)
		#print namdenergy.shape
		charmmenergy = readDriftCHARMM("../the8000/%s/CHARMM/run.log" % d)
		data[i] = np.array([charmmenergy, namdenergy, gmxenergy])
np.save("energydrift.npy", data)