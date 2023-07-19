#!/usr/bin/env python

import numpy as np
import subprocess
import os
import matplotlib
from scipy import stats
#import rpy2
#import rpy2.robjects as robjects
#from rpy2.robjects.packages import importr
#from rpy2.robjects.numpy2ri import numpy2ri
#pspline = importr ("pspline")
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
          'figure.autolayout' : True
          }
matplotlib.rcParams.update(params)
import matplotlib.pyplot as plt
def readNAMDlog (logfile):
	datalist = []
	with open(logfile) as f:
		for line in f:
			if line[:6] == 'ENERGY':
				s = line.split()
				#This will return timestep, bond, angle, proper, improper, elect, and VDW
				dat = np.array(s[1:8], dtype=np.float)
				datalist.append(dat)
	return np.vstack(datalist)
dirs = os.walk('..').next()[1]
data = []
names = []
for d in dirs:
	if d.isupper():
		print d
		gmxdir = "../%s/gmx/" % d
		infile = "%s%s.edr" % (gmxdir,d)
		outfile = gmxdir + "energy.xvg"
		#Outfile will have timestep, bond, angle, proper, improper, LJ14, Coulomb-14, LJ, and Coulomb terms
		subprocess.call("echo 1 2 3 4 5 6 7 8 | gmx energy -f %s -o %s -dp -xvg none" % (infile, outfile), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		gmxenergy = np.loadtxt(outfile)
		#print gmxenergy
		namdenergy = readNAMDlog("../%s/NAMD/run.log" % d)
		#print namdenergy
		difference = np.zeros((len(namdenergy), 6))
		for i in range(4):
			difference[:,i] = (gmxenergy[:,i+1] / 4.184) - namdenergy[:,i+1]
		difference[:,4] = (gmxenergy[:,6]/ 4.184 + gmxenergy[:,8]/ 4.184 ) - namdenergy[:,5]
		difference[:,5] = (gmxenergy[:,5]/ 4.184 + gmxenergy[:,7]/ 4.184) - namdenergy[:,6]
		data.append(difference)
		names.append(d)
energies = np.abs(np.array(data))
print energies.shape
mins = np.min(energies, axis=0)
mean = np.mean(energies, axis=0)
maxs = np.max(energies, axis=0)
x = np.linspace(0,10,len(mins))
fig, ax = plt.subplots(1,1)
labels = ['Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW']
colors = ['Indianred', 'orange', 'green', 'yellowgreen', 'skyblue', 'blue']
for i in range(6):
	ax.plot(x, mean[:,i], label=labels[i], color=colors[i])
	#ax.plot(x, mins[:,i], '--', color=colors[i])
	ax.plot(x, maxs[:,i], ':', color=colors[i])
leg = ax.legend(frameon=False, ncol=2, loc=4)
for legobj in leg.legendHandles:
	legobj.set_linewidth(2.0)
ax.set_yscale('log')
ax.set_ylabel(r"$|{\Delta} \mathrm{E}|$\,(kcal/mol)")
ax.set_xlabel(r"Time\,(ps)")
fig.savefig("deltaenergy.png", dpi=300)
print maxs[0]
print mean[0]
fig, ax = plt.subplots(1,1)

for i in range(6):
	print mins[0][i]
	ax.bar(i, -np.log10(mins[0][i]), color=colors[i], align='center', alpha=0.3)
for i in range(6):
	ax.bar(i, -np.log10(mean[0][i]), color=colors[i], align='center', alpha=0.3)
for i in range(6):
	ax.bar(i, -np.log10(maxs[0][i]), color=colors[i], align='center')
#ax.set_yscale('log')
ax.set_ylabel(r"$-\mathrm{log}_{10}|{\Delta} \mathrm{E}_{t=0}|$\,(kcal/mol)")
alllabels = ['', 'Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW']
ax.xaxis.set_ticklabels(alllabels, rotation=20, fontsize=14, ha='right')
fig.savefig("zeroenergy.png", dpi=300)
exit()
