%make a list of coordinates for to input into LAMMPS as an FCC
%lattice of PGNPS

%PGNP variables
N = 20; %number of beads per arm
R = 44; %number of arms
d = 5; %diameter of central particles
l = 1.00; %spacing between each bead (and the first bead from the core) in r
b = 14; %number of crosslinkable beads at chain ends (less or equal to N)

%Simulation size
ux = 2; %number of lattice cells in x
uy = 2; %number of lattice cells in y
uz = 2; %number of lattice cells in z

%information for LAMMPS
atomTypes = 5;
angleTypes = 1;
dihedralTypes = 1;

c = 2*((N*l)*l+d/2)+l; %interparticle spacing
numCores = 4*ux*uy*uz; %total number of PGNPs
a = sqrt(2)*c; %fcc lattice parameter

%position particle centers on an FCC lattice (close packed)
%https://www.mathworks.com/matlabcentral/answers/348118-how-to-generate-a-%fcc-crystal-matrice
fccbase = [0 0 0; .5 .5 0; .5 0 .5; 0 .5 .5]; %for periodic boundary conditions, 4 atom fcc basis
[latx,laty,latz] = ndgrid(0:(ux-1),0:(uy-1),0:(uz-1));
latxyz = [latx(:),laty(:),latz(:)];
latxyz = repmat([latx(:),laty(:),latz(:)],4,1);
latxyz = latxyz + reshape(permute(repmat(fccbase,[1,1,prod(size(latx))]),[3 1 2]),[],3);
latxyz = unique(latxyz,'rows');
corePos = latxyz.*a ; %expand lattice to desired size based on lattice parameter

p = size(corePos,1); %equal to the number of PGNPs

%-auto evenly distribute arm seeds on Spherical Surface
seeds = ParticleSampleSphere('N', R); %See Ref. 290
%distribute N points on surface of sphere, note, R must be at least 14
seedPosSphe = zeros(R,3);
[seedPosSphe(:,1),seedPosSphe(:,2),seedPosSphe(:,3)] = cart2sph(seeds(:,1),seeds(:,2),seeds(:,3));
for i =1:size(seedPosSphe,1)
 seedPosSphe(i,3)=d/2;
end
[seeds(:,1),seeds(:,2),seeds(:,3)] = sph2cart(seedPosSphe(:,1),seedPosSphe(:,2),seedPosSphe(:,3));

%build a neighborlist for the seed points
seedDistances = zeros(nchoosek(R,2),3);
k = 1;
for i = 1:R
 for j = i+1:R
   V1 = seeds(i,:); %first seed position
   V2 = seeds(j,:); %second seed position
   dist = sqrt(sum((V1 - V2).^2)); %calculate distance
   seedDistances(k,1) = i; %index of first seed
   seedDistances(k,2) = j; %index of second seed
   seedDistances(k,3) = dist; %distance between seeds
   k = k + 1;
 end
end

[~,indeces] = sort(seedDistances(:,3));
sortedSeeds = seedDistances(indeces,:); %sort neighbor list by neighbor distance

groupDist = sortedSeeds(1,3); %first group distance set to smallest single distance
numGroups = 40; %maximum number of seed neighbor distance groups
groups = zeros(numGroups,2);
startIndex = 1;
j = 1;
i = 1;

%construct a list of groups where all lengths are not more than 0.5%

%greater than the first member of the group
while i<=size(sortedSeeds,1) && j <=numGroups
 percentIncrease = (sortedSeeds(i,3)-groupDist)/groupDist*100;
 if percentIncrease > 0.5 %if distance is more than 0.5% greater..
   endIndex = i-1; %previous distance was last in list (sorted)
   groups(j,:) = [startIndex endIndex]; %add start and end of group to group list
   startIndex = i; %reset start index
   groupDist = sortedSeeds(i,3); %reset distance to compare to
   j = j + 1;
 end
 if i == size(sortedSeeds,1)
   endIndex = i;
   groups(j,:) = [startIndex endIndex];
   j = j + 1;
 end
 i = i + 1; 
end

%calculate the average neighbor distance for each group
avgCoreBonds = zeros(numGroups,1);

i = 1;
while i <= numGroups && groups(i,1) ~= 0
 avgCoreBonds(i,1) = mean(sortedSeeds(groups(i,1):groups(i,2),3));
 i = i + 1;
end

groups = [groups avgCoreBonds]; %add the average distances to the index list

%master list of bead positions (seeds + arms)
beadPosSphe = zeros((N+1)*R, 3);

%write azimuth and elevation for all particles based on each arm's seed
for i = 0:R-1
 for j = 1:N+1
   beadPosSphe(i*(N+1)+j,1)=seedPosSphe(i+1,1);
   beadPosSphe(i*(N+1)+j,2)=seedPosSphe(i+1,2);
 end
end

%add radial value for each bead based on the set spacing and core diameter
for i = 0:R-1
 for j = 1:N+1
   beadPosSphe(i*(N+1)+j,3)=d/2+(j-1)*l;
 end
end

%convert spherical to cartesian
beadPosCart = zeros((N+1)*R,3);
[beadPosCart(:,1),beadPosCart(:,2),beadPosCart(:,3)]=sph2cart(beadPosSphe(:,1),beadPosSphe(:,2),beadPosSphe(:,3));

%translate particles based on core positions
beadPosCartAll = zeros((N+1)*R*p,3);
for k = 1:p
 for i = 1:3
   for j = 1:size(beadPosCart,1)
     beadPosCartAll(j+(k-1)*R*(N+1),i)=beadPosCart(j,i)+corePos(k,i);
   end
 end
end

atomInfo = ones((N+1)*R*p,3); 
for i = 1:size(atomInfo,1)
 atomInfo(i,1)=i;
 w = mod(i, (N+1));
 if w==1
   atomInfo(i,2) = 1 + floor((i-1)/((N+1)*R)); %molecule ID increment for core seed beads
   atomInfo(i,3) = 2; %set to second atom type for start of arm
 else
   atomInfo(i,2) = 1 + p + floor((i-1)/(N+1)); %molecule ID increment for each arm
   end
 
 if w > (N+1-b) || w == 0
   atomInfo(i,3)=5; %set to 5th atom type if end of bcp (reactive)
 end 
end

coreAtomInfo = zeros(p,3); %single core particle at PGNP center
for i = 1:size(coreAtomInfo,1)
 coreAtomInfo(i,1)=i+size(atomInfo,1); %list to append to other atoms
 coreAtomInfo(i,2)=i; %each core particle is part of the particle's seed group
 coreAtomInfo(i,3)=4; %core particle is 4th atom type
end

%determine simulation box size
margin = a/2; %periodic
xlo = min(corePos(:,1));
xhi = max(corePos(:,1)) + margin;
ylo = min(corePos(:,2));
yhi = max(corePos(:,2)) + margin;
zlo = min(corePos(:,3));
zhi = max(corePos(:,3)) + margin;

atoms = [atomInfo, beadPosCartAll]; 
%this is the matrix of atom numbers, molecule IDs, atom types and cart coordinates for LAMMPS
cores = [coreAtomInfo, corePos];
atoms = [atoms; cores]; %append cores particles to end of atom li

bonds = ones(N*R*p, 4);
for i = 1:size(bonds,1)
 bonds(i,1)=i;
end
for i = 0:R*p-1
 for j = 1:N
   bonds(i*N+j,3:4) = [i*(N+1)+j i*(N+1)+j+1]; 
   %bond to next atom in arm (note N+1 atoms per arm)
 end
end

%create bond data for one core, then use known offset to concatenate other cores

%add bonds between the equidistant pairs (groups) until every atom is bonded to at least three other 
%atoms

coreBonds = zeros(groups(1,1)-groups(1,2)+1,4);
k = 1;
for i = groups(1,1):groups(1,2)
 sn1 = sortedSeeds(i,1); %index of first seed
 sn2 = sortedSeeds(i,2); %index of second seed
 an1 = (sn1-1)*(N+1) + 1; %spaced by number of beads in an arm
 an2 = (sn2-1)*(N+1) + 1;
 coreBonds(k,2) = 3; %start at 3rd bond type
 coreBonds(k,3) = an1;
 coreBonds(k,4) = an2;
 k = k + 1;
end

%create list to track how many other seeds each seed is bonded to
bondCounting = zeros(R, 2);
for i = 1:size(bondCounting,1)
 bondCounting(i,1)=i;
end

for i = 1:size(coreBonds,1) %read thru coreBonds
 coreIndex1 = floor(coreBonds(i,3)/(N+1))+1; %account for number of beads per arm
 coreIndex2 = floor(coreBonds(i,4)/(N+1))+1;
 bondCounting(coreIndex1,2) = bondCounting(coreIndex1,2) + 1;
 bondCounting(coreIndex2,2) = bondCounting(coreIndex2,2) + 1;
end

i = 2;
while min(bondCounting(:,2)) < 3 %continue adding equidistant groups until at least 3 bonds per seed
 coreBondBlock = zeros(groups(i,1)-groups(i,2)+1,4); %block of bonds to add
 k = 1;
 for j = groups(i,1):groups(i,2)
 sn1 = sortedSeeds(j,1);
 sn2 = sortedSeeds(j,2);
 an1 = (sn1-1)*(N+1) + 1;
 an2 = (sn2-1)*(N+1) + 1;
 coreBondBlock(k,2) = i+2; %new bond type for each group
 coreBondBlock(k,3) = an1;
 coreBondBlock(k,4) = an2;
 k = k+1;
 end
 coreBonds = [coreBonds; coreBondBlock]; %add block of new bonds
 for q = 1:size(coreBondBlock,1) %update bond counts
 coreIndex1 = floor(coreBondBlock(q,3)/(N+1))+1;
 coreIndex2 = floor(coreBondBlock(q,4)/(N+1))+1;
 bondCounting(coreIndex1,2) = bondCounting(coreIndex1,2) + 1;
 bondCounting(coreIndex2,2) = bondCounting(coreIndex2,2) + 1;
 end
 i = i + 1;
end

numGroupsUsed = i-1;
bondTypes = 2 + numGroupsUsed; %info for LAMMPS

staticCopyCoreBonds = coreBonds;

%copy seed-seed bonds from one PGNP to all PGNPs in sim
for i = 1:numCores-1
 copyCoreBonds = staticCopyCoreBonds;
 for j = 1:size(copyCoreBonds,1)
   copyCoreBonds(j,3) = copyCoreBonds(j,3) + i*(N+1)*R; %offset by number of atoms in a PGNP
   copyCoreBonds(j,4) = copyCoreBonds(j,4) + i*(N+1)*R; %note, central atoms at end of atom list
 end
 coreBonds = [coreBonds; copyCoreBonds]; %append each group of bonds
end

for i = 1:size(coreBonds,1)
 coreBonds(i,1)=size(bonds,1)+i; %add bond IDs for seed-seed bonds
end

bonds2core = zeros(R*p,4); %bonds between seeds and core central particle
for i = 1:size(bonds2core,1)
 bonds2core(i,1) = size(bonds,1)+size(coreBonds,1)+i; %add to end of list 
 bonds2core(i,2)=2; %second bond type
end

for i = 1:p
 for j = 1:R
   q = j+(i-1)*R;
   bonds2core(q,3) = size(atoms,1)-p+i; %core central particle
   bonds2core(q,4) = 1 + (j-1)*(N+1) + (i-1)*(N+1)*R; %seed particle
 end
end

bonds = [bonds; coreBonds; bonds2core]; %combine all bond lists

%create text file for data input into lammps
atomst = transpose(atoms);
fileID = fopen('JA_BXNP6.txt', 'w'); %file name
fprintf(fileID, '%s\r\n\r\n','# PGNP Model');
fprintf(fileID, '%8.0f %s\r\n', size(atoms,1), 'atoms');
fprintf(fileID, '%8.0f %s\r\n', size(bonds,1), 'bonds');
fprintf(fileID, '%8.0f %s\r\n', 2, 'extra bond per atom');
fprintf(fileID, '%8.0f %s\r\n\r\n', 100, 'extra special per atom');
fprintf(fileID, '%10.0f %s\r\n', atomTypes, 'atom types');
fprintf(fileID, '%10.0f %s\r\n\r\n', bondTypes, 'bond types'); 
fprintf(fileID, '%10.4f%10.4f %s %s\r\n', xlo, xhi, 'xlo', 'xhi');
fprintf(fileID, '%10.4f%10.4f %s %s\r\n', ylo, yhi, 'ylo', 'yhi');
fprintf(fileID, '%10.4f%10.4f %s %s\r\n\r\n', zlo, zhi, 'zlo', 'zhi');
fprintf(fileID, '%s\r\n\r\n', 'Masses');
fprintf(fileID, '%10.0f %.2f\r\n', 1, 1.0); %polymer bead
fprintf(fileID, '%10.0f %.2f\r\n', 2, 10.0); %seed bead
fprintf(fileID, '%10.0f %.2f\r\n', 3, 1.0); %crosslinked polymer bead
fprintf(fileID, '%10.0f %.2f\r\n', 4, 800.0); %core center bead
fprintf(fileID, '%10.0f %.2f\r\n\r\n', 5, 1.0); %BCP outer bead
fprintf(fileID, '%s\r\n\r\n', 'Bond Coeffs');
fprintf(fileID, '%10.0f %s %13.2f%10.2f%10.2f%10.2f\r\n', 1, 'fene', 30.0, 1.5, 1.0, 1.0); %polymer %bonds
fprintf(fileID, '%10.0f %s%10.2f%10.2f\r\n', 2, 'harmonic', 1000.0, d/2); %seed-core bonds

for i = 1:numGroupsUsed
 fprintf(fileID, '%10.0f %s%10.2f%10.4f\r\n', i+2, 'harmonic', 1000.0, groups(i,3)); %seed-seed %bonds
end

fprintf(fileID, '\r\n%s\r\n\r\n', 'Atoms');
fprintf(fileID, '%10.0f%10.0f%10.0f%10.4f%10.4f%10.4f\r\n', atomst); 
fprintf(fileID, '\r\n%5s\r\n', 'Bonds');
bondst = transpose(bonds);
fprintf(fileID, '\r\n%10.0f%10.0f%10.0f%10.0f', bondst);