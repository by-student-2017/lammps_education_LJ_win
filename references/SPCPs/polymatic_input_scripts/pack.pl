#!/usr/bin/perl

###############################################################################
#
# pack.pl
# This file is part of the Polymatic distribution.
#
# Description: Creates a random packing of molecules in a periodic cubic cell.
# Random insertions are made for each molecule to avoid overlap of the atomic 
# radii. The molecule structures are defined in a reference LAMMPS data file
# and the final packed box is given as a LAMMPS data file.
#
# Author: Lauren J. Abbott
# Version: 1.0
# Date: February 15, 2013
#
# Syntax:
#  ./pack.pl -i num F1.lmps N1 F2.lmps N2 (...)
#            -l boxL
#            -o pack.lmps
#
# Parameters:
#  1. num, number of reference molecules (-i)
#  2. Fi.lmps, LAMMPS data file of the reference molecule (-i)
#  3. Ni, number of reference molecule Fi.lmps to pack (-i)
#  4. boxL, size of cubic box (-l)
#  5. pack.lmps, name of LAMMPS data file to output packed box (-o)
#
###############################################################################
#
# Polymatic: a general simulated polymerization algorithm
# Copyright (C) 2013 Lauren J. Abbott
#
# Polymatic is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Polymatic is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License (COPYING)
# along with Polymatic. If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################

use strict;
use Math::Trig();
use POSIX();

# Variables
my ($filePack, $boxL, $numPacked, $toPack, $numRefMols, $numCells, $cellL);
my ($header, $lengthA, $lengthB, $lengthC, $xLo, $xHi, $yLo, $yHi, $zLo, $zHi);
my (@molecules, @numbers, @newPos, @neighbors);

my ($numAtoms, $numBonds, $numAngles, $numDiheds, $numImprops);
my (@atomMol, @atomType, @atomQ, @atomPos); # atomID => value
my (@bonds, @angles, @diheds, @improps); # bondID => atoms

my ($refNumAtoms, $refNumBonds, $refNumAngles, $refNumDiheds, $refNumImprops);
my (@refAtomMol, @refAtomType, @refAtomQ, @refAtomPos);
my (@refBonds, @refAngles, @refDiheds, @refImprops);

my ($packNumAtoms, $packNumBonds, $packNumAngles);
my ($packNumDiheds, $packNumImprops);
my (@packAtomMol, @packAtomType, @packAtomQ, @packAtomPos);
my (@packBonds, @packAngles, @packDiheds, @packImprops);

my ($numAtomTypes, $numBondTypes, $numAngleTypes);
my ($numDihedTypes, $numImpropTypes);
my (@atomTypes, @bondTypes, @angleTypes, @dihedTypes, @impropTypes);

my (@masses, @pairCoeffs, @bondCoeffs);
my (@angleCoeffs, @impropCoeffs, @bondBondCoeffs, @bondAngCoeffs);
my (@dihedCoeffs, @midBondTorsCoeffs, @endBondTorsCoeffs);
my (@angTorsCoeffs, @angAngTorsCoeffs, @bondBond13Coeffs);
my (@impropCoeffs, @angAngCoeffs);

# Initialize variables
my $numMols = 0;
my $attempts = 0;
my $maxAttempts = 1000000;

#
# Main Program
#

# Read in arguments
readArgs();

# Read in and pack each reference molecule
for (my $i = 0; $i < $numRefMols; $i++)
{
	printf "Packing molecule type %d: %s\n", $i+1, $molecules[$i];
	
	readRef($molecules[$i]);
	$numPacked = 0;
	$toPack = $numbers[$i];
	
	while ($numPacked < $toPack)
	{
		generateRandomMol();
		if (checkOverlap()) {
			addMol();
			$numPacked++;
		}
	}
	
	printf "\n";
}

# Write packed box to LAMMPS data file
defineSystem();
writeLammps($filePack);

###############################################################################
# Subroutines

# errExit( $error )
# Exit program and print error
sub errExit
{
	printf "Error: %s\n", $_[0];
	exit 2;
}

# readArgs( )
# Read command line arguments for program
sub readArgs
{
	# Variables
	my (@args, $flag);
	
	@args = @ARGV;
	while(scalar(@args) > 0)
	{
		$flag = shift(@args);
		
		# Input files
		# Reference LAMMPS files for molecule(s) to pack
		if ($flag eq "-i")
		{
			$numRefMols = shift(@args);
			errExit("Number of reference molecules '$numRefMols'".
				"must be greater than 0.") if ($numRefMols <= 0);
			
			for (my $i = 0; $i < $numRefMols; $i++)
			{
				push (@molecules, shift(@args));
				push (@numbers, shift(@args));
				errExit("LAMMPS data file '$molecules[$i]' does not exist.")
					if (! -e $molecules[$i]);
				errExit("Number of molecules to pack must be greater than 0.")
					if ($numbers[$i] <= 0);
			}
		}
		
		# Output file
		# LAMMPS file with packed molecules to be created
		elsif ($flag eq "-o")
		{
			$filePack = shift(@args);
		}
		
		# Box length
		# Length of cubic box to pack into
		elsif ($flag eq "-l")
		{
			$boxL = shift(@args);
			errExit("Box length '$boxL' must be greater than 0.") 
				if ($boxL <= 0);
		}
		
		# Help/syntax
		elsif ($flag eq "-h")
		{
			printf "Syntax: ./pack.pl -i num F1.lmps N1 F2.lmps N2 (...) ".
				"-l boxL -o pack.lmps\n";
			exit 2;
		}
		
		# Error
		else 
		{
			errExit("Did not recognize command-line flag.\n".
				"Syntax: ./pack.pl -i num F1.lmps N1 F2.lmps N2 (...) ".
				"-l boxL -o pack.lmps");
		}
	}
	
	# Check required values are defined
	errExit("Output file name not properly defined.") if (!defined($filePack));
	errExit("Box size was not properly defined.") if (!defined($boxL));
	errExit("Reference molecule files were not properly defined.") 
		if (!defined($numRefMols));
}

# readRef( $file )
# Read reference molecule from LAMMPS data file and center at origin
sub readRef
{
	# Variables
	my $file = $_[0];
	my ($xC, $yC, $zC, $sumX, $sumY, $sumZ);
	
	# Initialize variables
	$sumX = 0;
	$sumY = 0;
	$sumZ = 0;
	
	# Read in data from lammps data file
	readLammps($file);
	
	$refNumAtoms = $numAtoms;
	$refNumBonds = $numBonds;
	$refNumAngles = $numAngles;
	$refNumDiheds = $numDiheds;
	$refNumImprops = $numImprops;
	@refAtomMol = @atomMol;
	@refAtomType = @atomType;
	@refAtomQ = @atomQ;
	@refAtomPos = @atomPos;
	@refBonds = @bonds;
	@refAngles = @angles;
	@refDiheds = @diheds;
	@refImprops = @improps;
	
	# Center molecule at origin (0,0,0)
	# Note: this is geometric center, add masses for center of mass
	for (my $i = 1; $i <= $refNumAtoms; $i++) {
		$sumX += $refAtomPos[$i][0];
		$sumY += $refAtomPos[$i][1];
		$sumZ += $refAtomPos[$i][2];
	}
	
	$xC = $sumX / $refNumAtoms;
	$yC = $sumY / $refNumAtoms;
	$zC = $sumZ / $refNumAtoms;
	
	for (my $i = 1; $i <= $refNumAtoms; $i++) {
		$refAtomPos[$i][0] -= $xC;
		$refAtomPos[$i][1] -= $yC;
		$refAtomPos[$i][2] -= $zC;
	}
}

# generateRandomMol( )
# Generate random molecule from reference molecule with random translation 
# vector and rotation matrix
sub generateRandomMol
{
	# Variables
	my ($xt, $yt, $zt, $a, $b, $c, $xi, $yi, $zi, $x, $y, $z);
	my ($m1, $m2, $m3, $n1, $n2, $n3, $p1, $p2, $p3);
	
	@newPos = ();
	$attempts++;
	
	# Random translation vector	
	$xt = rand($boxL);
	$yt = rand($boxL);
	$zt = rand($boxL);
	
	# Random rotation matrix
	$a = rand(2*Math::Trig::pi);
	$b = rand(2*Math::Trig::pi);
	$c = rand(2*Math::Trig::pi);
	
	$m1 = cos($b)*cos($c);
	$m2 = cos($b)*sin($c);
	$m3 = -sin($b);
	$n1 = -cos($a)*sin($c) + sin($a)*sin($b)*cos($c);
	$n2 = cos($a)*cos($c) + sin($a)*sin($b)*sin($c);
	$n3 = sin($a)*cos($b);
	$p1 = sin($a)*sin($c) + cos($a)*sin($b)*cos($c);
	$p2 = -sin($a)*cos($c) + cos($a)*sin($b)*sin($c);
	$p3 = cos($a)*cos($b);
	
	# Apply rotation and translation to each atom
	for (my $i = 1; $i <= $refNumAtoms; $i++)
	{
		($xi, $yi, $zi) = @{$refAtomPos[$i]};
	
		$x = $m1*$xi + $m2*$yi + $m3*$zi + $xt;
		$y = $n1*$xi + $n2*$yi + $n3*$zi + $yt;
		$z = $p1*$xi + $p2*$yi + $p3*$zi + $zt;
		
		$newPos[$i] = [$x, $y, $z];
	}
}

# checkOverlap( )
# Check new molecule atom positions for overlap with current system atoms
# Return 1 if no overlap, 0 if overlap
sub checkOverlap
{
	# Variables
	my ($u, $v, $w, $cellX, $cellY, $cellZ, $r1, $r2, $sep);
	my (@pos, @neighs);
	
	# Skip if first molecule
	return 1 if ($numMols == 0);
	
	# Check each atom in new molecule for overlap
	for (my $t = 1; $t <= $refNumAtoms; $t++)
	{
		@pos = @{$newPos[$t]};
		($u, $v, $w) = cell(\@pos, $numCells, $cellL);
		$r1 = $pairCoeffs[$refAtomType[$t]][1] / 2;
		
		for (my $i = $u-1; $i <= $u+1; $i++) {
			$cellX = $i - $numCells * POSIX::floor($i/$numCells);
		for (my $j = $v-1; $j <= $v+1; $j++) {
			$cellY = $j - $numCells * POSIX::floor($j/$numCells);
		for (my $k = $w-1; $k <= $w+1; $k++) {
			$cellZ = $k - $numCells * POSIX::floor($k/$numCells);
			
			# Check only atoms in nearest neighbor cells
			@neighs = @{$neighbors[$cellX][$cellY][$cellZ]};
			for (my $n = 0; $n < scalar(@neighs); $n++)
			{
				$r2 = $pairCoeffs[$packAtomType[$neighs[$n]]][1] / 2;
				$sep = separation(\@pos, \@{$packAtomPos[$neighs[$n]]}, 
					[$boxL, $boxL, $boxL]);
				
				# Return 0 if overlap occurs, quit if max attempts reached
				if ($sep < ($r1 + $r2))
				{
					errExit("Reached maximum number of attempts.")
						if ($attempts == $maxAttempts);
						
					return 0;
				}
			}
		}}}
	}
	
	# No overlaps, return 1
	return 1;
}

# addMol( )
# Add new molecule atoms to system atoms
sub addMol
{
	# Variables
	my ($init, $rMax, $u, $v, $w, $type, $a1, $a2, $a3, $a4);
	
	$numMols++;
	$init = $packNumAtoms;
	
	# Initialize neighbor list if first molecule
	if ($numMols == 1)
	{
		# Maximum sigma value
		$rMax = 0.0;
		for (my $i = 1; $i <= $numAtomTypes; $i++) {
			$rMax = $pairCoeffs[$i][1] if ($pairCoeffs[$i][1] > $rMax);
		}
		
		errExit("Could not find maximum sigma value.") if ($rMax == 0.0);
		
		# Number of cells and width
		$numCells = POSIX::floor($boxL/$rMax);
		$cellL = $boxL/$numCells;
		
		for (my $i = 0; $i < $numCells; $i++) {
		for (my $j = 0; $j < $numCells; $j++) {
		for (my $k = 0; $k < $numCells; $k++)
		{
			@{$neighbors[$i][$j][$k]} = ();
		}}}
	}
	
	# Add atoms to system
	for (my $i = 1; $i <= $refNumAtoms; $i++)
	{
		$packNumAtoms++;
		
		$packAtomMol[$packNumAtoms] = $numMols;
		$packAtomType[$packNumAtoms] = $refAtomType[$i];
		$packAtomQ[$packNumAtoms] = $refAtomQ[$i];
		$packAtomPos[$packNumAtoms] = [@{$newPos[$i]}];
		
		($u, $v, $w) = cell(\@{$newPos[$i]}, $numCells, $cellL);
		push(@{$neighbors[$u][$v][$w]}, $packNumAtoms);
	}
	
	# Add bonds
	for (my $i = 1; $i <= $refNumBonds; $i++)
	{
		$packNumBonds++;
		($type, $a1, $a2) = @{$refBonds[$i]};
		$packBonds[$packNumBonds] = [$type, $a1 + $init, $a2 + $init];
	}
	
	# Add angles
	for (my $i = 1; $i <= $refNumAngles; $i++)
	{
		$packNumAngles++;
		($type, $a1, $a2, $a3) = @{$refAngles[$i]};
		$packAngles[$packNumAngles] = [$type, $a1 + $init, $a2 + $init, 
			$a3 + $init];
	}
	
	# Add dihedrals
	for (my $i = 1; $i <= $refNumDiheds; $i++)
	{
		$packNumDiheds++;
		($type, $a1, $a2, $a3, $a4) = @{$refDiheds[$i]};
		$packDiheds[$packNumDiheds] = [$type, $a1 + $init, $a2 + $init, 
			$a3 + $init, $a4 + $init];
	}
	
	# Add impropers
	for (my $i = 1; $i <= $refNumImprops; $i++)
	{
		$packNumImprops++;
		($type, $a1, $a2, $a3, $a4) = @{$refImprops[$i]};
		$packImprops[$packNumImprops] = [$type, $a1 + $init, $a2 + $init, 
			$a3 + $init, $a4 + $init];
	}
	
	printf "  %d, %d attempts\n", $numMols, $attempts;
	$attempts = 0;
}

# cell( \@pos, $nCells, $cellW )
# Calculate neighbor list cell with nCells of width cellW for an atom with 
# coordinates @pos
sub cell
{
	# Variables
	my ($x, $y, $z) = @{$_[0]};
	my $nCells = $_[1];
	my $cellW = $_[2];
	my ($cellX, $cellY, $cellZ);
	
	$cellX = POSIX::floor($x/$cellW);
	$cellX = $cellX - $nCells * POSIX::floor($cellX/$nCells);
	$cellY = POSIX::floor($y/$cellW);
	$cellY = $cellY - $nCells * POSIX::floor($cellY/$nCells);
	$cellZ = POSIX::floor($z/$cellW);
	$cellZ = $cellZ - $nCells * POSIX::floor($cellZ/$nCells);
	
	return ($cellX, $cellY, $cellZ);
}

# separation( \@a1, \@a2, \@boxDims )
# Calculates the separation vector between two atoms with positions @a1 and @a2
# using nearest image convention for a box of size @boxDims
sub separation
{
	# Variables
	my (@a1) = @{$_[0]};
	my (@a2) = @{$_[1]};
	my (@boxDims) = @{$_[2]};
	my ($vecX, $vecY, $vecZ, $x, $y, $z);
	
	# Separation vector
	$vecX = $a1[0] - $a2[0];
	$vecY = $a1[1] - $a2[1];
	$vecZ = $a1[2] - $a2[2];
	
	# Nearest image convention
	$x = $vecX - $boxDims[0] * POSIX::floor($vecX/$boxDims[0] + 0.5);
	$y = $vecY - $boxDims[1] * POSIX::floor($vecY/$boxDims[1] + 0.5);
	$z = $vecZ - $boxDims[2] * POSIX::floor($vecZ/$boxDims[2] + 0.5);
	
	return sqrt($x*$x + $y*$y + $z*$z);
}

# defineSystem( )
# Define system of packed molecules
sub defineSystem
{
	$header = "Random packing of ".$numbers[0]." x ".$molecules[0];
	for (my $i = 1; $i < $numRefMols; $i++) {
		$header = $header.", ".$numbers[$i]." x ".$molecules[$i];
	}
	
	$header = $header;
	$lengthA = $boxL;
	$lengthB = $boxL;
	$lengthC = $boxL;
	$xLo = 0;
	$yLo = 0;
	$zLo = 0;
	$xHi = $boxL;
	$yHi = $boxL;
	$zHi = $boxL;
	$numAtoms = $packNumAtoms;
	$numBonds = $packNumBonds;
	$numAngles = $packNumAngles;
	$numDiheds = $packNumDiheds;
	$numImprops = $packNumImprops;
	@atomMol = @packAtomMol;
	@atomType = @packAtomType;
	@atomQ = @packAtomQ;
	@atomPos = @packAtomPos;
	@bonds = @packBonds;
	@angles = @packAngles;
	@diheds = @packDiheds;
	@improps = @packImprops;
}

# readLammps( $file )
# Read LAMMPS data file
sub readLammps
{
	# Variables
	my $file = $_[0];
	my ($num, $mol, $type, $q, $x, $y, $z);
	my ($secMasses, $secPairCoeff, $secBondCoeff, $secAngleCoeff);
	my ($secBondBondCoeff, $secBondAngleCoeff, $secDihedCoeff);
	my ($secMidBondTorsCoeff, $secEndBondTorsCoeff, $secAngTorsCoeff);
	my ($secAngAngTorsCoeff, $secBondBond13Coeff, $secImpropCoeff);
	my ($secAngleAngleCoeff, $secAtoms, $secBonds, $secAngles);
	my ($secDiheds, $secImprops);
	my @temp;
	my $emptyLine = 2;
	my $bodyStart = 13;
	
	# Initialize
	$header = "";
	$lengthA = 0;
	$lengthB = 0;
	$lengthC = 0;
	$xLo = 0;
	$xHi = 0;
	$yLo = 0;
	$yHi = 0;
	$zLo = 0;
	$zHi = 0;
	$numAtoms = 0;
	$numBonds = 0;
	$numAngles = 0;
	$numDiheds = 0;
	$numImprops = 0;
	@atomMol = ();
	@atomType = ();
	@atomQ = ();
	@atomPos = ();
	@bonds = ();
	@angles = ();
	@diheds = ();
	@improps = ();
	
	# Open and read from file
	open INLMPS, "< $file" or die "Error opening file '$file': $!";
	
	my $i = 0;
	while (my $line = <INLMPS>)
	{
		chomp($line);
		$line =~ s/^\s+//;
		$i++;
		
		# Header
		if ($i == 1) {
			$header = $line;
			next;
		}
		
		# Counts
		elsif ($i == 3) {
			@temp = split(' ', $line);
			errExit("Atoms count not on proper line.") 
				if ($temp[1] ne "atoms");
			$numAtoms = $temp[0];
			$bodyStart++ if ($numAtoms > 0);
			next;
		} elsif ($i == 4) {
			@temp = split(' ', $line);
			errExit("Bonds count not on proper line.") 
				if ($temp[1] ne "bonds");
			$numBonds = $temp[0];
			$bodyStart++ if ($numBonds > 0);
			next;
		} elsif ($i == 5) {
			@temp = split(' ', $line);
			errExit("Angles count not on proper line.") 
				if ($temp[1] ne "angles");
			$numAngles = $temp[0];
			$bodyStart++ if ($numAngles > 0);
			next;
		} elsif ($i == 6) {
			@temp = split(' ', $line);
			errExit("Dihedrals count not on proper line.") 
				if ($temp[1] ne "dihedrals");
			$numDiheds = $temp[0];
			$bodyStart++ if ($numDiheds > 0);
			next;
		} elsif ($i == 7) {
			@temp = split(' ', $line);
			errExit("Impropers count not on proper line.") 
				if ($temp[1] ne "impropers");
			$numImprops = $temp[0];
			$bodyStart++ if ($numImprops > 0);
			next;
		}
		
		# Data type counts and box size
		elsif ($i < $bodyStart)
		{
			@temp = split(' ', $line);
			
			# Check counts against types file
			if ($temp[2] eq "types")
			{
				if ($temp[1] eq "atom") {
					if (!defined($numAtomTypes)) {
						$numAtomTypes = $temp[0];
					} elsif ($temp[0] != $numAtomTypes) {
						errExit("Number of atom types not consistent.");
					}
				}
				
				elsif ($temp[1] eq "bond") {
					if (!defined($numBondTypes)) {
						$numBondTypes = $temp[0];
					} elsif ($temp[0] != $numBondTypes) {
						errExit("Number of bond types not consistent.");
					}
				}
				
				elsif ($temp[1] eq "angle") {
					if (!defined($numAngleTypes)) {
						$numAngleTypes = $temp[0];
					} elsif ($temp[0] != $numAngleTypes) {
						errExit("Number of angle types not consistent.");
					}
				}
				
				elsif ($temp[1] eq "dihedral") {
					if (!defined($numDihedTypes)) {
						$numDihedTypes = $temp[0];
					} elsif ($temp[0] != $numDihedTypes) {
						errExit("Number of dihedral types not consistent.");
					}
				}
				
				elsif ($temp[1] eq "improper") {
					if (!defined($numImpropTypes)) {
						$numImpropTypes = $temp[0];
					} elsif ($temp[0] != $numImpropTypes) {
						errExit("Number of improper types not consistent.");
					}
				}
			}
			
			elsif ($temp[2] eq "xlo") {
				$xLo = $temp[0];
				$xHi = $temp[1];
				$lengthA = $xHi - $xLo;
			} elsif ($temp[2] eq "ylo") {
				$yLo = $temp[0];
				$yHi = $temp[1];
				$lengthB = $xHi - $xLo;
			} elsif ($temp[2] eq "zlo") {
				$zLo = $temp[0];
				$zHi = $temp[1];
				$lengthC = $xHi - $xLo;
			}
			
			next;
		} 
		
		# Flag sections
		if (substr($line,0,6) eq "Masses" || 
			substr($line,0,11) eq "Pair Coeffs" ||
			substr($line,0,11) eq "Bond Coeffs" || 
			substr($line,0,12) eq "Angle Coeffs" ||
			substr($line,0,15) eq "BondBond Coeffs" || 
			substr($line,0,16) eq "BondAngle Coeffs" ||
			substr($line,0,15) eq "Dihedral Coeffs" || 
			substr($line,0,24) eq "MiddleBondTorsion Coeffs" || 
			substr($line,0,21) eq "EndBondTorsion Coeffs" || 
			substr($line,0,19) eq "AngleTorsion Coeffs" || 
			substr($line,0,24) eq "AngleAngleTorsion Coeffs" || 
			substr($line,0,17) eq "BondBond13 Coeffs" || 
			substr($line,0,15) eq "Improper Coeffs" || 
			substr($line,0,17) eq "AngleAngle Coeffs" || 
			substr($line,0,5) eq "Atoms" ||
			substr($line,0,10) eq "Velocities" || 
			substr($line,0,5) eq "Bonds" ||
			substr($line,0,6) eq "Angles" || 
			substr($line,0,9) eq "Dihedrals" ||
			substr($line,0,9) eq "Impropers" )
		{
			$secMasses = 0;
			$secPairCoeff = 0; 
			$secBondCoeff = 0;
			$secAngleCoeff = 0;
			$secBondBondCoeff = 0;
			$secBondAngleCoeff = 0;
			$secDihedCoeff = 0;
			$secMidBondTorsCoeff = 0;
			$secEndBondTorsCoeff = 0;
			$secAngTorsCoeff = 0;
			$secAngAngTorsCoeff = 0;
			$secBondBond13Coeff = 0;
			$secImpropCoeff = 0;
			$secAngleAngleCoeff = 0;
			$secAtoms = 0;
			$secBonds = 0;
			$secAngles = 0;
			$secDiheds = 0;
			$secImprops = 0;
			
			$secMasses = 1 
				if (substr($line,0,6) eq "Masses");
			$secPairCoeff = 1 
				if (substr($line,0,11) eq "Pair Coeffs"); 
			$secBondCoeff = 1 
				if (substr($line,0,11) eq "Bond Coeffs");
			$secAngleCoeff = 1 
				if (substr($line,0,12) eq "Angle Coeffs");
			$secBondBondCoeff = 1 
				if (substr($line,0,15) eq "BondBond Coeffs");
			$secBondAngleCoeff = 1 
				if (substr($line,0,16) eq "BondAngle Coeffs");
			$secDihedCoeff = 1 
				if (substr($line,0,15) eq "Dihedral Coeffs");
			$secMidBondTorsCoeff = 1 
				if (substr($line,0,24) eq "MiddleBondTorsion Coeffs");
			$secEndBondTorsCoeff = 1 
				if (substr($line,0,21) eq "EndBondTorsion Coeffs");
			$secAngTorsCoeff = 1 
				if (substr($line,0,19) eq "AngleTorsion Coeffs");
			$secAngAngTorsCoeff = 1 
				if (substr($line,0,24) eq "AngleAngleTorsion Coeffs");
			$secBondBond13Coeff = 1 
				if (substr($line,0,17) eq "BondBond13 Coeffs");
			$secImpropCoeff = 1 
				if (substr($line,0,15) eq "Improper Coeffs");
			$secAngleAngleCoeff = 1 
				if (substr($line,0,17) eq "AngleAngle Coeffs");
			$secAtoms = 1 
				if (substr($line,0,5) eq "Atoms");
			$secBonds = 1 
				if (substr($line,0,5) eq "Bonds");
			$secAngles = 1 
				if (substr($line,0,6) eq "Angles");
			$secDiheds = 1 
				if (substr($line,0,9) eq "Dihedrals");
			$secImprops = 1 
				if (substr($line,0,9) eq "Impropers");
			
			next;
		}
		
		@temp = split(' ', $line);
		
		# Mass section
		if ($secMasses && length($line) > $emptyLine) {
			$num = shift(@temp);
			$masses[$num] = [@temp];
		}
		
		# Nonbond Coeffs section
		elsif ($secPairCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$pairCoeffs[$num] = [@temp];
		}
		
		# Bond Coeffs section
		elsif ($secBondCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$bondCoeffs[$num] = [@temp];
		}
		
		# Angle Coeffs section
		elsif ($secAngleCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$angleCoeffs[$num] = [@temp];
		}
		
		# Bond Bond Coeffs section
		elsif ($secBondBondCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$bondBondCoeffs[$num] = [@temp];
		}
		
		# Bond Angle Coeffs section
		elsif ($secBondAngleCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$bondAngCoeffs[$num] = [@temp];
		}
		
		# Dihedral Coeffs section
		elsif ($secDihedCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$dihedCoeffs[$num] = [@temp];
		}
		
		# Middle Bond Torsion Coeffs section
		elsif ($secMidBondTorsCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$midBondTorsCoeffs[$num] = [@temp];
		}
		
		# End Bond Torsion Coeffs section
		elsif ($secEndBondTorsCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$endBondTorsCoeffs[$num] = [@temp];
		}
		
		# Angle Torsion Coeffs section
		elsif ($secAngTorsCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$angTorsCoeffs[$num] = [@temp];
		}
		
		# Angle Angle Torsion Coeffs section
		elsif ($secAngAngTorsCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$angAngTorsCoeffs[$num] = [@temp];
		}
		
		# Bond Bond 1-3 Torsion Coeffs section
		elsif ($secBondBond13Coeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$bondBond13Coeffs[$num] = [@temp];
		}
		
		# Improper Coeffs section
		elsif ($secImpropCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$impropCoeffs[$num] = [@temp];
		}
		
		# Angle Angle Coeffs section
		elsif ($secAngleAngleCoeff && length($line) > $emptyLine) {
			$num = shift(@temp);
			$angAngCoeffs[$num] = [@temp];
		}
		
		# Atoms section
		elsif ($secAtoms && length($line) > $emptyLine)
		{
			($num, $mol, $type, $q, $x, $y, $z) = @temp;
			$atomMol[$num] = $mol;
			$atomType[$num] = $type;
			$atomQ[$num] = $q;
			$atomPos[$num] = [$x,$y,$z];
		}

		# Bonds section
		elsif ($secBonds && length($line) > $emptyLine)
		{
			$num = shift(@temp);
			$bonds[$num] = [@temp];
		}

		# Angles section
		elsif ($secAngles && length($line) > $emptyLine)
		{
			$num = shift(@temp);
			$angles[$num] = [@temp];
		}

		# Dihedrals section
		elsif ($secDiheds && length($line) > $emptyLine)
		{
			$num = shift(@temp);
			$diheds[$num] = [@temp];
		}

		# Impropers section
		elsif ($secImprops && length($line) > $emptyLine)
		{
			$num = shift(@temp);
			$improps[$num] = [@temp];
		}
	}
	
	close INLMPS;
	
	# Check for errors
	errExit("Length of atom data does not match atom count.")
		if (scalar(@atomMol) - 1 != $numAtoms ||	
			scalar(@atomType) - 1 != $numAtoms ||
			scalar(@atomQ) - 1 != $numAtoms ||
			scalar(@atomPos) - 1 != $numAtoms);
	
	errExit("Length of bond data does not match bond count.")
		if (@bonds && scalar(@bonds) - 1 != $numBonds);
		
	errExit("Length of angle data does not match angle count.")
		if (@angles && scalar(@angles) - 1 != $numAngles);
		
	errExit("Length of dihedral data does not match dihedral count.")
		if (@diheds && scalar(@diheds) - 1 != $numDiheds);
	
	errExit("Length of improper data does not match improper count.")
		if (@improps && scalar(@improps) - 1 != $numImprops);
	
	errExit("Length of atom types data does not match atom types count.")
		if (scalar(@masses) - 1 != $numAtomTypes ||
			scalar(@pairCoeffs) - 1 != $numAtomTypes);
	
	errExit("Length of bond types data does not match bond types count.")
		if (@bondCoeffs && scalar(@bondCoeffs) - 1 != $numBondTypes);
		
	errExit("Length of angle types data does not match angle types count.")
		if (@angleCoeffs && scalar(@angleCoeffs) - 1 != $numAngleTypes);
		
	errExit("Length of dihedral types data does not match dihedral types count.")
		if (@dihedCoeffs && scalar(@dihedCoeffs) - 1 != $numDihedTypes);
		
	errExit("Length of improper types data does not match improper types count.")
		if (@impropCoeffs && scalar(@impropCoeffs) - 1 != $numImpropTypes);
}

# writeLammps( $file )
# Write LAMMPS data file
sub writeLammps
{
	# Variables
	my $file = $_[0];
	my @values;
	
	# Check for necessary information
	errExit("LAMMPS file cannot be written, box dimensions not defined.")
		if (!defined($xLo) || !defined($xHi) || 
			!defined($yLo) || !defined($yHi) || 
			!defined($zLo) || !defined($zHi));
	
	errExit("Cannot write LAMMPS file, atoms not defined properly.")
		if ($numAtoms == 0 ||
			scalar(@atomMol)-1 != $numAtoms ||
			scalar(@atomType)-1 != $numAtoms ||
			scalar(@atomQ)-1 != $numAtoms ||
			scalar(@atomPos)-1 != $numAtoms);
	
	errExit("Cannot write LAMMPS file, bonds not defined properly.")
		if ($numBonds > 0 && scalar(@bonds)-1 != $numBonds);
	
	errExit("Cannot write LAMMPS file, angles not defined properly.")
		if ($numAngles > 0 && scalar(@angles)-1 != $numAngles);
	
	errExit("Cannot write LAMMPS file, dihedrals not defined properly.")
		if ($numDiheds > 0 && scalar(@diheds)-1 != $numDiheds);
	
	errExit("Cannot write LAMMPS file, impropers not defined properly.")
		if ($numImprops > 0 && scalar(@improps)-1 != $numImprops);
	
	errExit("Cannot write LAMMPS file, atom types not defined properly.")
		if ($numAtomTypes == 0 || scalar(@masses)-1 != $numAtomTypes ||
			scalar(@pairCoeffs)-1 != $numAtomTypes);
	
	errExit("Cannot write LAMMPS file, bond types not defined properly.")
		if ($numBondTypes > 0 && scalar(@bondCoeffs)-1 != $numBondTypes);
	
	errExit("Cannot write LAMMPS file, angle types not defined properly.")
		if ($numAngleTypes > 0 && scalar(@angleCoeffs)-1 != $numAngleTypes);
	
	errExit("Cannot write LAMMPS file, dihedral types not defined properly.")
		if ($numDihedTypes > 0 && scalar(@dihedCoeffs)-1 != $numDihedTypes);
	
	errExit("Cannot write LAMMPS file, bond types not defined properly.")
		if ($numImpropTypes > 0 && 
			scalar(@impropCoeffs)-1 != $numImpropTypes);
	
	# Open and write to file
	open FILE, "> $file" or die "Error opening file '$file': $!";
	
	# Heading
	printf FILE "$header\n";
	printf FILE "\n";

	printf FILE "%d atoms\n", $numAtoms;
	printf FILE "%d bonds\n", $numBonds;
	printf FILE "%d angles\n", $numAngles;
	printf FILE "%d dihedrals\n", $numDiheds;
	printf FILE "%d impropers\n", $numImprops;
	printf FILE "\n";

	printf FILE "%d atom types\n", $numAtomTypes 
		if ($numAtomTypes > 0);
	printf FILE "%d bond types\n", $numBondTypes 
		if ($numBondTypes > 0);
	printf FILE "%d angle types\n", $numAngleTypes 
		if ($numAngleTypes > 0);
	printf FILE "%d dihedral types\n", $numDihedTypes 
		if ($numDihedTypes > 0);
	printf FILE "%d improper types\n", $numImpropTypes 
		if ($numImpropTypes > 0);
	printf FILE "\n";
	
	printf FILE "%10.6f %10.6f xlo xhi \n", $xLo, $xHi;
	printf FILE "%10.6f %10.6f ylo yhi \n", $yLo, $yHi;
	printf FILE "%10.6f %10.6f zlo zhi \n", $zLo, $zHi;
	printf FILE "\n";
	
	# Atom Coeffs
	if ($numBondTypes > 0)
	{
		# Masses
		printf FILE "Masses\n\n";
		for (my $i = 1; $i <= $numAtomTypes; $i++)
		{
			errExit("Did not find mass for atom type $i.")
				if (!$masses[$i]);
			@values = @{$masses[$i]};
			
			printf FILE "  %-7d %11.6f\n",
				$i, $values[0];
		}
		printf FILE "\n";
		
		# Pair Coeffs
		printf FILE "Pair Coeffs\n\n";
		for (my $i = 1; $i <= $numAtomTypes; $i++)
		{
			errExit("Did not find pair coeffs for atom type $i.")
				if (!$pairCoeffs[$i]);
			@values = @{$pairCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f\n", 
				$i, $values[0], $values[1];
		}
		printf FILE "\n";
	}
	
	# Bond Coeffs
	if ($numBondTypes > 0)
	{
		# Bond Coeffs
		printf FILE "Bond Coeffs\n\n";
		for (my $i = 1; $i <= $numBondTypes; $i++)
		{
			errExit("Did not find bond coeffs for bond type $i.")
				if (!$bondCoeffs[$i]);
			@values = @{$bondCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3];
		}
		printf FILE "\n";
	}
	
	# Angle Coeffs
	if ($numAngleTypes > 0)
	{
		# Angle Coeffs
		printf FILE "Angle Coeffs\n\n";
		for (my $i = 1; $i <= $numAngleTypes; $i++)
		{
			errExit("Did not find angle coeffs for angle type $i.")
				if (!$angleCoeffs[$i]);
			@values = @{$angleCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3];
		}
		printf FILE "\n";
		
		# BondBond Coeffs
		printf FILE "BondBond Coeffs\n\n";
		for (my $i = 1; $i <= $numAngleTypes; $i++)
		{
			errExit("Did not find bond bond coeffs for angle type $i.")
				if (!$bondBondCoeffs[$i]);
			@values = @{$bondBondCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2];
		}
		printf FILE "\n";
		
		# BondAngle Coeffs
		printf FILE "BondAngle Coeffs\n\n";
		for (my $i = 1; $i <= $numAngleTypes; $i++)
		{
			errExit("Did not find bond angle coeffs for angle type $i.")
				if (!$bondAngCoeffs[$i]);
			@values = @{$bondAngCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3];
		}
		printf FILE "\n";
	}
	
	if ($numDihedTypes > 0)
	{
		# Dihed Coeffs
		printf FILE "Dihedral Coeffs\n\n";
		for (my $i = 1; $i <= $numDihedTypes; $i++)
		{
			errExit("Did not find dihedral coeffs for dihedral type $i.")
				if (!$dihedCoeffs[$i]);
			@values = @{$dihedCoeffs[$i]};
			
			printf FILE 
				"  %-7d %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3], $values[4],
				$values[5];
		}
		printf FILE "\n";
		
		# MiddleBondTorsion Coeffs
		printf FILE "MiddleBondTorsion Coeffs\n\n";
		for (my $i = 1; $i <= $numDihedTypes; $i++)
		{
			errExit("Did not find mbt coeffs for dihedral type $i.")
				if (!$midBondTorsCoeffs[$i]);
			@values = @{$midBondTorsCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3];
		}
		printf FILE "\n";
		
		# EndBondTorsion Coeffs
		printf FILE "EndBondTorsion Coeffs\n\n";
		for (my $i = 1; $i <= $numDihedTypes; $i++)
		{
			errExit("Did not find ebt coeffs for dihedral type $i.")
				if (!$endBondTorsCoeffs[$i]);
			@values = @{$endBondTorsCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f ".
				"%11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3], $values[4], 
				$values[5], $values[6], $values[7];
		}
		printf FILE "\n";
		
		# AngleTorsion Coeffs
		printf FILE "AngleTorsion Coeffs\n\n";
		for (my $i = 1; $i <= $numDihedTypes; $i++)
		{
			errExit(
				"Did not find angle torsion coeffs for dihedral type $i.")
				if (!$angTorsCoeffs[$i]);
			@values = @{$angTorsCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f ".
				"%11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3], $values[4],
				$values[5], $values[6], $values[7];
		}
		printf FILE "\n";
		
		# AngleAngleTorsion Coeffs
		printf FILE "AngleAngleTorsion Coeffs\n\n";
		for (my $i = 1; $i <= $numDihedTypes; $i++)
		{
			errExit("Did not find angle angle torsion coeffs for dihedral ".
				"type $i.")
				if (!$angAngTorsCoeffs[$i]);
			@values = @{$angAngTorsCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2];
		}
		printf FILE "\n";
		
		# BondBond13 Coeffs
		printf FILE "BondBond13 Coeffs\n\n";
		for (my $i = 1; $i <= $numDihedTypes; $i++)
		{
			errExit("Did not find bond bond 13 coeffs for dihedral type $i.")
				if (!$bondBond13Coeffs[$i]);
			@values = @{$bondBond13Coeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2];
		}
		printf FILE "\n";
	}
	
	if ($numImpropTypes > 0)
	{
		# Improper Coeffs
		printf FILE "Improper Coeffs\n\n";
		for (my $i = 1; $i <= $numImpropTypes; $i++)
		{
			errExit("Did not find improper coeffs for improper type $i.")
				if (!$impropCoeffs[$i]);
			@values = @{$impropCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f\n", 
				$i, $values[0], $values[1];
		}
		printf FILE "\n";
		
		# AngleAngle Coeffs
		printf FILE "AngleAngle Coeffs\n\n";
		for (my $i = 1; $i <= $numImpropTypes; $i++)
		{
			errExit("Did not find angle angle coeffs for improper type $i.")
				if (!$angAngCoeffs[$i]);
			@values = @{$angAngCoeffs[$i]};
			
			printf FILE "  %-7d %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f\n", 
				$i, $values[0], $values[1], $values[2], $values[3], $values[4],
				$values[5];
		}
		printf FILE "\n";
	}
	
	if ($numAtoms > 0)
	{
		# Atoms
		printf FILE "Atoms\n\n";
		for (my $i = 1; $i <= $numAtoms; $i++)
		{
			errExit("Did not find atom '$i'.")
				if (!$atomPos[$i] || !$atomMol[$i] || !$atomType[$i] || 
					!defined($atomQ[$i]));
			@values = @{$atomPos[$i]};
			
			printf FILE "  %-7d %-4d %-4d %10.6f %13.6f %13.6f %13.6f\n",
				$i, $atomMol[$i], $atomType[$i], $atomQ[$i], 
				$values[0], $values[1], $values[2];
		}
		printf FILE "\n";
	}
	
	if ($numBonds > 0)
	{
		# Bonds
		printf FILE "Bonds\n\n";
		for (my $i = 1; $i <= $numBonds; $i++)
		{
			errExit("Did not find bond '$i'.") if (!$bonds[$i]);
			@values = @{$bonds[$i]};
			
			printf FILE "  %-7d %-4d %-7d %-7d\n",
				$i, $values[0], $values[1], $values[2];
		}
		printf FILE "\n";
	}
	
	if ($numAngles > 0)
	{
		# Angles
		printf FILE "Angles\n\n";
		for (my $i = 1; $i <= $numAngles; $i++)
		{
			errExit("Did not find angle '$i'.") if (!$angles[$i]);
			@values = @{$angles[$i]};
			
			printf FILE "  %-7d %-4d %-7d %-7d %-7d\n",
				$i, $values[0], $values[1], $values[2], $values[3];
		}
		printf FILE "\n";
	}
	
	if ($numDiheds > 0)
	{
		# Dihedrals
		printf FILE "Dihedrals\n\n";
		for (my $i = 1; $i <= $numDiheds; $i++)
		{
			errExit("Did not find dihedral '$i'.") if (!$diheds[$i]);
			@values = @{$diheds[$i]};
			
			printf FILE "  %-7d %-4d %-7d %-7d %-7d %-7d\n",
				$i, $values[0], $values[1], $values[2], $values[3], $values[4];
		}
		printf FILE "\n";
	}
	
	if ($numImprops > 0)
	{
		# Impropers
		printf FILE "Impropers\n\n";
		for (my $i = 1; $i <= $numImprops; $i++)
		{
			errExit("Did not find improper '$i'.") if (!$improps[$i]);
			@values = @{$improps[$i]};
			
			printf FILE "  %-7d %-4d %-7d %-7d %-7d %-7d\n",
				$i, $values[0], $values[1], $values[2], $values[3], $values[4];
		}
		printf FILE "\n";
	}
	# Close file
	close FILE;
}