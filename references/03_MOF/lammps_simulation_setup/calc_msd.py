import numpy as np
import MDAnalysis as mda
import time
import os
from numba import jit

# input information
dump_freq = 1000 # steps
dt=0.001 # ps
skip = 500 # ps
dumpfile = './dump.lammpstrj'
output = 'msd_1_H_angle_0.dat'
nblocks=1 # for block average
trajfrac = 1/2 # fraction of traj for iterating lagtimes, the rest of traj is used for averaging (1-taufrac)*nframes

# returns array of dimension N lagtimes x 1
@jit(nopython=True)
def MSD(pos,trajfrac=trajfrac):
   # function to calculate Mean Squared Displacement of selected atoms
   MSD = []
   nframes = pos.shape[0]
   maxlagtime = int(nframes*trajfrac)
   for jj in range(1,maxlagtime):
     MSD.append(np.mean(np.sum(np.square(pos[jj:-(maxlagtime-jj)]-pos[0:-maxlagtime]),axis=2)))
   return MSD

u = mda.Universe(dumpfile,format='LAMMPSDUMP',lengthunit='A',timeunit='ps',dt=(dump_freq*dt)) 
ch4 = u.select_atoms("type 7")
print('------------- system info --------------')
print('total atoms:',u.atoms.n_atoms)
print('methane atoms:',ch4.n_atoms)

initpos=[u.trajectory[0].positions/u.trajectory[0].dimensions[:3]]
natoms=int(u.trajectory[0].n_atoms)
total_nframes = len(u.trajectory)
sampled_nframes = len(u.trajectory)-int(skip/(dump_freq*dt))
nframesperblock = int(sampled_nframes/nblocks)
print('-------------- traj info ---------------')
print('total nframes:',total_nframes,'(',total_nframes*dump_freq*dt,'ps)')
print('skipped frames:',skip/(dump_freq*dt),'(',skip,'ps)')
print('sampled nframes:',sampled_nframes,'(',total_nframes*dump_freq*dt-skip,'ps)')
print('nblocks:',nblocks)
print('nframes per block:',nframesperblock)
maxlagtime = int(nframesperblock*trajfrac) 
print('--------- msd info (per block) ---------')
print('number of lagtimes frames:',maxlagtime-1) 
print('number of frames for averaging:',np.floor((1-trajfrac)*nframesperblock))
print('simulation time between frames (ps):',dump_freq*dt)
print('----------------------------------------')

# read trajectory to array
print('------------- READING TRAJ -------------')
start = time.time()
pos=np.zeros((sampled_nframes,natoms,3))
for ts in u.trajectory[:]:
    if (ts.time >= skip): # skip specified equilibration time
        pos[int(ts.frame-skip/(dump_freq*dt)),:,:]=ts.positions 
end = time.time()
print('time:', end - start)

# set up masks to isolate atom type for diffusion tracking
ch4_false = [False]*int(u.atoms.n_atoms-ch4.n_atoms)
ch4_true = [True]*int(ch4.n_atoms)
ch4_mask = np.array((ch4_false+ch4_true))

# create msd array
msd = np.zeros((nblocks,maxlagtime-1,2))
msd[:,:,0]=np.tile(np.arange(1,(maxlagtime))*dump_freq*dt, (nblocks,1)) # time in ps

# delete output file if it already exists
try:
    os.remove(output)
except OSError:
    pass

# divide in to N blocks
print('------------ CALCULATING MSD ------------')
start = time.time()
outfile = open(output,"a")
for i in range(nblocks):
    selected_block = pos[nframesperblock*i:nframesperblock*(i+1),:,:]
    if (ch4.n_atoms != 0):
        pos_ch4 = selected_block[:,ch4_mask,:]
        msd[i,:,1] = MSD(pos_ch4)
    np.savetxt(outfile,msd[i,:,:],header='lag time (ps), MSD-ch4 (A^2)')
end = time.time()
print('time:', end - start)

