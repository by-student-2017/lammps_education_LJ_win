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
def readNAMDlog (logfile):
	datalist = []
	with open(logfile) as f:
		for line in f:
			if line[:6] == 'ENERGY':
				s = line.split()
				#This will return timestep, bond, angle, proper, CMAP, improper, elect, and VDW
				dat = np.array(s[1:9], dtype=np.float)
				datalist.append(dat)
	return np.vstack(datalist)

data = []
energylogs = []
names = []
d = 'memb'
#print d
gmxdir = "../gmx/"
infile = "%s%s.edr" % (gmxdir,d)
outfile = gmxdir + "energy.xvg"
#Outfile will have timestep, bond, angle, proper, improper, CMAP, LJ14, Coulomb-14, LJ, and Coulomb terms. Ewald contributions are in 10.
subprocess.call("echo 1 2 3 4 5 6 7 8 9 10 | gmx energy -f %s -o %s -dp -xvg none" % (infile, outfile), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
gmxenergy = np.loadtxt(outfile)
print gmxenergy[0]
print gmxenergy.shape
namdenergy = readNAMDlog("../NAMD/run.log")
print namdenergy[0]
print namdenergy.shape
#exit()
names.append(d)
energylog = np.zeros((2,len(gmxenergy), 8), dtype=np.float)
differences = np.zeros((len(gmxenergy), 7), dtype=np.float)
namdenergy[:,[4,5]] = namdenergy[:,[5,4]] #Now both are bond, angle, proper, improper, CMAP
#Swap elect and vdw.
namdenergy[:,[6,7]] = namdenergy[:,[7,6]]
energylog[0] = namdenergy
energylog[1,:,0] = gmxenergy[:,0]
for i in range(5):
	differences[:,i] = gmxenergy[:,i+1]/4.184 - namdenergy[:,i+1]
	energylog[1,:,i+1] = gmxenergy[:,i+1]/4.184
if np.abs(differences[0][2]) > 1e-2:
	print d, differences[0][2]
#VDW
differences[:,5] = (gmxenergy[:,6] + gmxenergy[:,8]) / 4.184 - namdenergy[:,7]
energylog[1,:,6] = (gmxenergy[:,6] + gmxenergy[:,8]) / 4.184
#Elect.
differences[:,6] = (gmxenergy[:,7] + gmxenergy[:,9] + gmxenergy[:,10]) / 4.184 - namdenergy[:,6]
energylog[1,:,7] = (gmxenergy[:,7] + gmxenergy[:,9] + gmxenergy[:,10]) / 4.184
#Switch Elect and CMAP
differences[:,[4,6]] = differences[:,[6,4]]
energylog[:,:,[5,7]] = energylog[:,:,[7,5]]
#Final order is bond, angle, proper, improper, Elect, VDW, CMAP
data.append(differences)
energylogs.append(energylog)
energies = np.array(energylogs)
print energies.shape
print energies[:,:,0]
energieszero = energies[:,:,0]

#print np.mean(namdcharmmdiff, axis=0)
namdgmxdiff = np.abs(energieszero[:,0] - energieszero[:,1])
#print np.mean(namdgmxdiff, axis=0)
fig, axes = plt.subplots(1,1, figsize=(5.6, 4.2), sharey=True)
fig.subplots_adjust(hspace=0, wspace=0)
labels = ['Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW', 'CMAP']
colors = ['Indianred', 'orange', 'green', 'yellowgreen', 'skyblue', 'blue', 'magenta']
#axlabels = ['NAMD vs. CHARMM', 'NAMD vs. Gromacs', 'CHARMM vs. Gromacs']
for j, diff in enumerate([ namdgmxdiff]):
	ax = axes
	mins = np.min(diff, axis=0)
	mean = np.mean(diff, axis=0)
	#print dirs[np.argmax(diff[:,6])], diff[np.argmax(diff[:,6])]
	maxs = np.max(diff, axis=0)
	print mins.shape
	for i in range(7):
		ax.bar(i, -np.log10(mins[i+1]), color=colors[i], align='center', alpha=0.3)
	for i in range(7):
		ax.bar(i, -np.log10(mean[i+1]), color=colors[i], align='center', alpha=0.3)
	for i in range(7):
		ax.bar(i, -np.log10(maxs[i+1]), color=colors[i], align='center')
	#ax.set_yscale('log')
	if j == 0:
		ax.set_ylabel(r"$-\mathrm{log}_{10}|{\Delta} \mathrm{E}_{t=0}|$\,(kcal/mol)")
	alllabels = ['', 'Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW', 'CMAP']
	ax.xaxis.set_ticklabels(alllabels, rotation=20, fontsize=10, ha='right')
	#ax.text(0.1, 0.9, axlabels[j], transform=ax.transAxes, fontsize=14)
fig.savefig("zeroenergycompare.png", dpi=300)

#namdcharmmrelative = np.abs(energieszero[:,0] - energieszero[:,2]) / np.abs(energieszero[:,0])
#print np.mean(namdcharmmrelative, axis=0)
#namdcharmmrelative[namdcharmmrelative < 1e-8] = 1e-8
namdgmxrelative = np.abs(energieszero[:,0] - energieszero[:,1]) / np.abs(energieszero[:,0])
#print np.mean(namdgmxrelative, axis=0)
#charmmgmxrelative = np.abs(energieszero[:,2] - energieszero[:,1]) / np.abs(energieszero[:,2])

fig, axes = plt.subplots(1,1, figsize=(5.6, 4.2), sharey=True)
fig.subplots_adjust(hspace=0, wspace=0)
labels = ['Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW', 'CMAP']
colors = ['Indianred', 'orange', 'green', 'yellowgreen', 'skyblue', 'blue', 'magenta']
#axlabels = ['NAMD vs. CHARMM', 'NAMD vs. Gromacs', 'CHARMM vs. Gromacs']
for j, diff in enumerate([namdgmxrelative]):
	ax = axes
	mins = np.min(diff, axis=0)
	mean = np.mean(diff, axis=0)
	maxs = np.max(diff, axis=0)
	print mins.shape
	for i in range(7):
		ax.bar(i, -np.log10(mins[i+1]), color=colors[i], align='center', alpha=0.3)
	for i in range(7):
		ax.bar(i, -np.log10(mean[i+1]), color=colors[i], align='center', alpha=0.3)
	for i in range(7):
		ax.bar(i, -np.log10(maxs[i+1]), color=colors[i], align='center')
	#ax.set_yscale('log')
	if j == 0:
		ax.set_ylabel(r"$-\mathrm{log}_{10}|\frac{{\Delta} \mathrm{E}_{t=0}}{\mathrm{E}_{t=0}}|$")
	alllabels = ['', 'Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW', 'CMAP']
	ax.xaxis.set_ticklabels(alllabels, rotation=20, fontsize=10, ha='right')
	#ax.text(0.1, 0.9, axlabels[j], transform=ax.transAxes, fontsize=14)
fig.savefig("zeroenergycomparerelative.png", dpi=300)
exit()


#energies: bonds, angles, proper, electrostatic, and LJ differences.
energies = np.abs(np.array(data))
print energies.shape
mins = np.min(energies, axis=0)
mean = np.mean(energies, axis=0)
maxs = np.max(energies, axis=0)

x = np.linspace(0,10,len(mins))
print x.shape
fig, ax = plt.subplots(1,1)
labels = ['Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW', 'CMAP']
colors = ['Indianred', 'orange', 'green', 'yellowgreen', 'skyblue', 'blue', 'magenta']
for i in range(7):
	print i
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

for i in range(7):
	ax.bar(i, -np.log10(mins[0][i]), color=colors[i], align='center', alpha=0.3)
for i in range(7):
	ax.bar(i, -np.log10(mean[0][i]), color=colors[i], align='center', alpha=0.3)
for i in range(7):
	ax.bar(i, -np.log10(maxs[0][i]), color=colors[i], align='center')
#ax.set_yscale('log')
ax.set_ylabel(r"$-\mathrm{log}_{10}|{\Delta} \mathrm{E}_{t=0}|$\,(kcal/mol)")
alllabels = ['', 'Bond', 'Angle', 'Dihedral', 'Improper', 'Elect.', 'VDW', 'CMAP']
ax.xaxis.set_ticklabels(alllabels, rotation=20, fontsize=14, ha='right')
fig.savefig("zeroenergy.png", dpi=300)

exit()
