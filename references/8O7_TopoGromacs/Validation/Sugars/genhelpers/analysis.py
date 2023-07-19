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
wimproper = []
woimproper = []
names1 = []
names2 = []
for d in dirs:
	if d.isupper():
		print d
		gmxdir = "../%s/gmx/" % d
		infile = "%s%s.edr" % (gmxdir,d)
		outfile = gmxdir + "energy.xvg"
		#Outfile will have timestep, bond, angle, proper, (Improper?) LJ14, Coulomb-14, LJ, and Coulomb terms
		subprocess.call("echo 1 2 3 4 5 6 7 8 | gmx energy -f %s -o %s -dp -xvg none" % (infile, outfile), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		gmxenergy = np.loadtxt(outfile)
		#print gmxenergy
		namdenergy = readNAMDlog("../%s/NAMD/run.log" % d)
		#print namdenergy
		if np.sum(namdenergy[:,4]) == 0: #No improper term.
			difference = np.zeros((len(namdenergy), 5))
			for i in range(3):
				difference[:,i] = (gmxenergy[:,i+1] / 4.184) - namdenergy[:,i+1]
			difference[:,3] = (gmxenergy[:,5]/ 4.184 + gmxenergy[:,7]/ 4.184 ) - namdenergy[:,5]
			difference[:,4] = (gmxenergy[:,4]/ 4.184 + gmxenergy[:,6]/ 4.184) - namdenergy[:,6]
			print difference[0], difference[-1]
			woimproper.append(difference)
			names1.append(d)
		else:#These also have impropers.
			difference = np.zeros((len(namdenergy), 6))
			for i in range(3):
				difference[:,i] = (gmxenergy[:,i+1] / 4.184) - namdenergy[:,i+1]
			difference[:,3] = (gmxenergy[:,6]/ 4.184 + gmxenergy[:,8]/ 4.184 ) - namdenergy[:,5]
			difference[:,4] = (gmxenergy[:,5]/ 4.184 + gmxenergy[:,7]/ 4.184) - namdenergy[:,6]
			difference[:,5] = (gmxenergy[:,4] / 4.184) - namdenergy[:,4]
			print difference[0], difference[-1]
			wimproper.append(difference)
			names2.append(d)
wimproper = np.array(wimproper)
woimproper = np.array(woimproper)
names = names1 + names2
print (((wimproper.T)[:5]).T).shape
print woimproper.shape
#energies: bonds, angles, proper, electrostatic, and LJ differences.
energies = np.abs(np.vstack((woimproper, wimproper[:,:,:5])))
impropers = np.abs(wimproper[:,:,5])
print energies.shape
print impropers.shape
mins = np.min(energies, axis=0)
mean = np.mean(energies, axis=0)
maxs = np.max(energies, axis=0)
imins = np.min(impropers, axis=0)
imean = np.mean(impropers, axis=0)
imaxs = np.max(impropers, axis=0)
x = np.linspace(0,10,len(mins))
xi = np.linspace(0,10,1000)
fig, ax = plt.subplots(1,1)
labels = ['Bond', 'Angle', 'Dihedral', 'Elect.', 'VDW']
colors = ['Indianred', 'orange', 'green', 'skyblue', 'blue']
for i in range(5):
	ax.plot(x, mean[:,i], label=labels[i], color=colors[i])
	#ax.plot(x, mins[:,i], '--', color=colors[i])
	ax.plot(x, maxs[:,i], ':', color=colors[i])
	if i == 2:
		ax.plot(x, imean, label="Improper", color='yellowgreen')
		#ax.plot(x, imins, '--', color='yellowgreen')
		ax.plot(x, imaxs, ':', color='yellowgreen')
leg = ax.legend(frameon=False, ncol=2, loc=4)
for legobj in leg.legendHandles:
	legobj.set_linewidth(2.0)
ax.set_yscale('log')
ax.set_ylabel(r"$|{\Delta} \mathrm{E}|$\,(kcal/mol)")
ax.set_xlabel(r"Time\,(ps)")
fig.savefig("deltaenergy.png", dpi=300)
print maxs[0]
print mean[0]
print imaxs[0]
print imean[0]
fig, ax = plt.subplots(1,1)

for i in range(3):
	ax.bar(i, -np.log10(mins[0][i]), color=colors[i], align='center', alpha=0.3)
ax.bar(3,-np.log10(imins[0]), color='yellowgreen', align='center', alpha=0.3)
for i in range(3,5):
	ax.bar(i+1, -np.log10(mins[0][i]), color=colors[i], align='center', alpha=0.3)
for i in range(3):
	ax.bar(i, -np.log10(mean[0][i]), color=colors[i], align='center', alpha=0.3)
ax.bar(3,-np.log10(imean[0]), color='yellowgreen', align='center', alpha=0.3)
for i in range(3,5):
	ax.bar(i+1, -np.log10(mean[0][i]), color=colors[i], align='center', alpha=0.3)
for i in range(3):
	ax.bar(i, -np.log10(maxs[0][i]), color=colors[i], align='center')
ax.bar(3,-np.log10(imaxs[0]), color='yellowgreen', align='center')
for i in range(3,5):
	ax.bar(i+1, -np.log10(maxs[0][i]), color=colors[i], align='center')
#ax.set_yscale('log')
ax.set_ylabel(r"$-\mathrm{log}_{10}|{\Delta} \mathrm{E}_{t=0}|$\,(kcal/mol)")
alllabels = ['', 'Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW']
ax.xaxis.set_ticklabels(alllabels, rotation=20, fontsize=14, ha='right')
fig.savefig("zeroenergy.png", dpi=300)
exit()
