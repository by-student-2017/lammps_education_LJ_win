#!/usr/bin/perl

###############################################################################
#
# polym.pl
# This file is part of the Polymatic distribution.
#
# Description: Performs a polymerization step for use within the Polymatic
# code. Finds the closest pair of 'linker' atoms satisfying all bonding
# criteria and adds all new bonds, angles, dihedrals, and impropers. Bonding
# criteria implemented include a maximum cutoff distance, oriential checks of
# angles between vectors and best-fit-planes for given atoms, and intra-
# molecular bonding. Options are provided in an input script. Reads in and
# writes out LAMMPS data files.
#
# Author: Lauren J. Abbott
# Version: 1.0
# Date: February 15, 2013
#
# Syntax:
#  ./polym.pl -i data.lmps
#             -t types.txt
#             -s polym.in
#             -o new.lmps
#
# Parameters:
#  1. data.lmps, LAMMPS data file of initial system (-i)
#  2. types.txt, data types text file (-t)
#  3. polym.in, input script specifying polymerization options (-l)
#  4. new.lmps, updated LAMMPS data file after polymerization step (-o)
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
my ($fileData, $fileTypes, $fileInput, $fileOut);
my ($header, $lengthA, $lengthB, $lengthC, $xLo, $xHi, $yLo, $yHi, $zLo, $zHi);

my ($numAtoms, $numBonds, $numAngles, $numDiheds, $numImprops, $numMols);
my (@atomMol, @atomType, @atomQ, @atomPos); # atomID => value
my (@bonds, @angles, @diheds, @improps, @molecules); # bondID => atoms
my (@atomBonds, @atomAngles, @atomDiheds, @atomImprops); # atomID => atoms
my (@atomBondNums, @atomAngleNums, @atomDihedNums, @atomImpropNums);

my ($numAtomTypes, $numBondTypes, $numAngleTypes);
my ($numDihedTypes, $numImpropTypes);
my (@atomTypes, @bondTypes, @angleTypes); # id => string
my (@dihedTypes, @impropTypes);
my (%atomTypesKey, %bondTypesKey, %angleTypesKey); # string => id
my (%dihedTypesKey, %impropTypesKey);

my (@masses, @pairCoeffs, @bondCoeffs);
my (@angleCoeffs, @bondBondCoeffs, @bondAngCoeffs);
my (@dihedCoeffs, @midBondTorsCoeffs, @endBondTorsCoeffs);
my (@angTorsCoeffs, @angAngTorsCoeffs, @bondBond13Coeffs);
my (@impropCoeffs, @angAngCoeffs);

my ($polymCutoff, $polymLink1, $polymLink2, $polymLinkNew1, $polymLinkNew2);
my ($polymCharge1, $polymCharge2, $polymClosest1, $polymClosest2);
my ($polymBondFlag, $polymAlignFlag, $polymChargeFlag, $polymIntraFlag);
my (@polymTypes, @polymConnect, @polymBonds, @polymPlanes, @polymVectors);

#
# Main Program
#

# Read command-line arguments
readArgs();

# Read input files
readLammps($fileData);
readTypes($fileTypes);
readPolymInput($fileInput);

# Find closest pair and make updates
findPair();
makeUpdates();

# Write updated file
writeLammps($fileOut);

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
# Read command line arguements for program
sub readArgs
{
	# Variables
	my (@args, $flag);
	@args = @ARGV;

	while(scalar(@args) > 0)
	{
		$flag = shift(@args);

		# Input file
		# LAMMPS file of system to run polymerization step
		if ($flag eq "-i")
		{
			$fileData = shift(@args);
			errExit("LAMMPS data file '$fileData' does not exist.")
				if (! -e $fileData);
		}

		# Types file
		# Text file specifying data type numerical values and strings
		elsif ($flag eq "-t")
		{
			$fileTypes = shift(@args);
			errExit("Data types file '$fileTypes' does not exist.")
				if (! -e $fileTypes);
		}

		# Input script
		# Parameters for the polymerization step
		elsif ($flag eq "-s")
		{
			$fileInput = shift(@args);
			errExit("Input script '$fileInput' does not exist.")
				if (! -e $fileInput);
		}

		# Output file
		# LAMMPS file with updated connectivity after new bond(s)
		elsif ($flag eq "-o")
		{
			$fileOut = shift(@args);
		}

		# Help/syntax
		elsif ($flag eq "-h")
		{
			printf "Syntax: ./polym.pl -i data.lmps -t types.txt -s polym.in".
				" -o new.lmps\n";

			exit 2;
		}

		# Error
		else
		{
			errExit("Did not recognize command-line flag.\n".
				"Syntax: ./polym.pl -i data.lmps -t types.txt -s polym.in".
				" -o new.lmps\n");
		}
	}

	# Check values are defined
	errExit("Output file name not properly defined.") if (!defined($fileOut));
	errExit("Data file was not properly defined.") if (!defined($fileData));
	errExit("Types file was not properly defined.") if (!defined($fileTypes));
	errExit("Input script was not properly defined.") if (!defined($fileInput));
}

# findPair( )
# Find closest pair of linker atoms meeting all bonding criteria
sub findPair
{
	# Variables
	my ($type1, $type2, $a1, $a2, $sep);
	my (@link1, @link2, @pos1, @pos2);
	my $closest = 0;

	# Get atom types of linking atoms
	$type1 = $atomTypesKey{$polymLink1};
	$type2 = $atomTypesKey{$polymLink2};
	errExit("Atom type '$polymLink1' was not found.") if (!defined($type1));
	errExit("Atom type '$polymLink2' was not found.") if (!defined($type2));

	# Get groups of linking atoms
	@link1 = group(\@atomType, $type1);
	@link2 = group(\@atomType, $type2);
	errExit("No atoms of type '$polymLink1' found.") if (scalar(@link1) == 0);
	errExit("No atoms of type '$polymLink2' found.") if (scalar(@link2) == 0);

	# Find closest pair that meets bonding criteria
	for (my $i = 0; $i < scalar(@link1); $i++)
	{
		$a1 = $link1[$i];
		@pos1 = @{$atomPos[$a1]};

		for (my $j = 0; $j < scalar(@link2); $j++)
		{
			$a2 = $link2[$j];
			@pos2 = @{$atomPos[$a2]};

			# Skip if pair is in same molecule if no intra bonding
			next if (!$polymIntraFlag && $atomMol[$a1] == $atomMol[$a2]);

			# Skip if pair is outside cutoff radius
			$sep = separation(\@pos1, \@pos2, [$lengthA, $lengthB, $lengthC]);
			next if ($sep > $polymCutoff);

			# Skip if pair doesn't meet alignment check
			next if (alignment($a1, $a2));

			# Save pair if closest
			if ($closest == 0 || $sep < $closest)
			{
				$closest = $sep;
				$polymClosest1 = $a1;
				$polymClosest2 = $a2;
			}
		}
	}

	# Stop if no pair found
	if ($closest == 0) {
		exit 3;
	} else {
		printf "  Pair: %.2f A (%d,%d)\n",
			$closest, $polymClosest1, $polymClosest2;
		return;
	}
}

# group( @array, $value )
# Return all indices of @array that have a value that matches $value
# i.e., all $i such that $array[$i] = $value
sub group
{
	# Variables
	my (@array) = @{$_[0]};
	my $value = $_[1];
	my @matches;

	for (my $i = 0; $i < scalar(@array); $i++) {
		push(@matches, $i) if ($array[$i] == $value);
	}

	return @matches;
}

# separation( \@a1, \@a2, \@boxDims )
# Calculate the separation vector between two atoms with positions @a1 and @a2
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

# alignment( $a1, $a2 )
# Perform any alignment checks between potential pair {$a1,$a2}
# Returns 1 if fail, 0 if pass
sub alignment
{
	# Variables
	my $a1 = $_[0];
	my $a2 = $_[1];
	my ($next, $set1, $set2, $set3, $theta, $atom1, $atom2);
	my (@atoms, @toDefine, @connect, @bonded);
	my (@p1, @p2, @v1, @v2);
	my (@angles, @bestFit1, @bestFit2);

	# Return 0 if no check to perform
	return 0 if ($polymAlignFlag == 0);

	# Define initial atoms
	$atoms[1] = $a1;
	$atoms[2] = $a2;
	push(@toDefine, 1);
	push(@toDefine, 2);

	# Define connected atoms
	while (scalar(@toDefine) > 0)
	{
		$next = shift(@toDefine);
		@connect = @{$polymConnect[$next]};
		@bonded = @{$atomBonds[ $atoms[$next] ]};

		for (my $i = 0; $i < scalar(@bonded); $i++)
		{
			$atom1 = $bonded[$i];

			for (my $j = 0; $j < scalar(@connect); $j++)
			{
				$atom2 = $connect[$j];

				# Check if bonded atom1 matches connect record atom2
				if ($atomTypes[$atomType[$atom1]] eq $polymTypes[$atom2])
				{
					# Quit if not a unique description
					errExit("Atom connectivity in input script is not unique.")
						if ($atoms[$atom2]);

					$atoms[$atom2] = $atom1;
					push(@toDefine, $atom2)
						if ($polymConnect[$atom2]);
				}
			}
		}
	}

	# Vector checks
	for (my $i = 0; $i < scalar(@polymVectors); $i++)
	{
		($set1, $set2, $set3) = @{$polymVectors[$i]};
		@p1 = split(',', $set1);
		@p2 = split(',', $set2);
		@angles = split(',', $set3);

		# Stop if more than 2 atoms given for vector definition
		errExit("Vector alignment check is not defined properly.")
			if (scalar(@p1) > 2 || scalar(@p2) > 2);

		# Define vector atoms
		for (my $j = 0; $j < scalar(@p1); $j++) {
			errExit("Atoms not defined properly in connectivity definition.")
				if (!$atoms[ $p1[$j] ]);
			$p1[$j] = $atoms[ $p1[$j] ];
		}
		for (my $j = 0; $j < scalar(@p2); $j++) {
			errExit("Atoms not defined properly in connectivity definition.")
				if (!$atoms[ $p2[$j] ]);
			$p2[$j] = $atoms[ $p2[$j] ];
		}

		# Vectors and angle between vectors
		@v1 = vectorSub( \@{$atomPos[ $p1[0] ]}, \@{$atomPos[ $p1[1] ]} );
		@v2 = vectorSub( \@{$atomPos[ $p2[0] ]}, \@{$atomPos[ $p2[1] ]} );
		$theta = angleBetweenVectors(\@v1, \@v2) * 180/Math::Trig::pi;

		# Reject if not in defined angle range
		if (scalar(@angles) == 1) {
			return 1 if ( !eval("$theta $angles[0]") );
		} elsif (scalar(@angles) == 3) {
			return 1
				if (!eval("$theta $angles[0] $angles[2] $theta $angles[1]"));
		} else {
			errExit("Vector alignment check is not defined properly.");
		}
	}

	# Plane checks
	for (my $i = 0; $i < scalar(@polymPlanes); $i++)
	{
		($set1, $set2, $set3) = @{$polymPlanes[$i]};
		@p1 = split(',', $set1);
		@p2 = split(',', $set2);
		@angles = split(',', $set3);

		# Define plane atoms
		for (my $j = 0; $j < scalar(@p1); $j++) {
			errExit("Atoms not defined properly in connectivity definition.")
				if (!$atoms[ $p1[$j] ]);
			$p1[$j] = $atoms[ $p1[$j] ];
		}
		for (my $j = 0; $j < scalar(@p2); $j++) {
			errExit("Atoms not defined properly in connectivity definition.")
				if (!$atoms[ $p2[$j] ]);
			$p2[$j] = $atoms[ $p2[$j] ];
		}

		# Get array of coords for each best fit
		for (my $j = 0; $j < scalar(@p1); $j++) {
			push( @bestFit1, [@{$atomPos[ $p1[$j] ]}] );
		}
		for (my $j = 0; $j < scalar(@p2); $j++) {
			push( @bestFit2, [@{$atomPos[ $p2[$j] ]}] );
		}

		# Normal vectors of best fit planes and angle between vectors
		@v1 = normalPlane(\@bestFit1);
		@v2 = normalPlane(\@bestFit2);
		$theta = angleBetweenVectors(\@v1, \@v2) * 180/Math::Trig::pi;

		# Reject if not in defined angle range
		if (scalar(@angles) == 1) {
			return 1 if ( !eval("$theta $angles[0]") );
		} elsif (scalar(@angles) == 3) {
			return 1
				if (!eval("$theta $angles[0] $angles[2] $theta $angles[1]"));
		} else {
			errExit("Plane alignment check is not defined properly.");
		}
	}

	return 0;
}

# vectorSub( \@vec1, \@vec2 )
# Vector subtraction between two vectors @vec1 and @vec2
sub vectorSub
{
	# Variables
	my (@vec1) = @{$_[0]};
	my (@vec2) = @{$_[1]};
	my @vec;

	# Check vector lengths are equal
	errExit("Vectors must be the same length for subtraction.")
		if (scalar(@vec1) != scalar(@vec2));

	for (my $i = 0; $i < scalar(@vec1); $i++) {
		$vec[$i] = $vec1[$i] - $vec2[$i];
	}

	return @vec;
}

# angleBetweenVectors( \@vec1, \@vec2 )
# Calculate the angle between two vectors @vec1 and @vec2
sub angleBetweenVectors
{
	# Variables
	my (@vec1) = @{$_[0]};
	my (@vec2) = @{$_[1]};

	return ( Math::Trig::acos( dot(\@vec1, \@vec2)
		/ (norm(\@vec1) * norm(\@vec2)) ) );
}

# dot( \@vec1, \@vec2 )
# Calculate the dot product of two vectors @vec1 and @vec2
sub dot
{
	#Variables
	my (@vec1) = @{$_[0]};
	my (@vec2) = @{$_[1]};
	my $sum = 0;

	# Check vector lengths are equal
	errExit("Vectors must be the same length for dot product.")
                if (scalar(@vec1) != scalar(@vec2));

	for (my $i = 0; $i < scalar(@vec1); $i++) {
                $sum += $vec1[$i] * $vec2[$i];
        }

	return $sum;
}

# norm( \@vec )
# Calculate the norm of a vector @vec
sub norm
{
	# Variables
	my (@vec) = @{$_[0]};
	my $sum = 0;

	for (my $i = 0; $i < scalar(@vec); $i++) {
		$sum += $vec[$i] * $vec[$i];
	}

	return sqrt($sum);
}

# normalPlane( @coords )
# Calculate the normal vector to the best-fit-plane of points with coordinates
# given as @coords
# See: www.geometrictools.com/Documentation/LeastSquaresFitting.pdf
sub normalPlane
{
	# Variables
	my (@coords) = @{$_[0]};
	my ($xi, $yi, $zi, $temp, $a, $b, $c);
	my $n = scalar(@coords);

	# Initialize sums
	my $x = 0;
	my $y = 0;
	my $z = 0;
	my $xx = 0;
	my $yy = 0;
	my $xy = 0;
	my $yz = 0;
	my $xz = 0;

	# Calculate sums
	for (my $i = 0; $i < scalar(@coords); $i++)
	{
		($xi, $yi, $zi) = @{$coords[$i]};

		$x += $xi;
		$y += $yi;
		$z += $zi;
		$xx += ($xi * $xi);
		$yy += ($yi * $yi);
		$xy += ($xi * $yi);
		$xz += ($xi * $zi);
		$yz += ($yi * $zi);
	}

	# Plane: Ax + By + C = z
	$temp = $n*$xy*$xy - 2*$x*$xy*$y + $xx*$y*$y + $x*$x*$yy - $n*$xx*$yy;
	$a = -(-$xz*$y*$y + $n*$xz*$yy - $n*$xy*$yz + $x*$y*$yz + $xy*$y*$z
		 - $x*$yy*$z) / $temp;
	$b = -(-$n*$xy*$xz + $x*$xz*$y - $x*$x*$yz + $n*$xx*$yz + $x*$xy*$z
		 - $xx*$y*$z) / $temp;
	#$c = -($xy*$xz*$y - $x*$xz*$yy + $x*$xy*$yz - $xx*$y*$yz - $xy*$xy*$z
	#     + $xx*$yy*$z) / $temp;

	# Return normal vector {a, b, -1}
	return ($a, $b, -1);
}

# makeUpdates( )
# Update information of system with new bond between closest reactive atoms
sub makeUpdates
{
	# Variables
	my ($b1, $b2, $a1, $a2, $a3, $a4, $t1, $t2, $t3, $t4);
	my ($type1, $type2, $type3, $type4, $num, $mol1, $mol2, $min, $max);
	my (@bondsToAdd, @anglesToAdd, @dihedsToAdd, @impropsToAdd);
	my (@updatedBonds, @updatedAngles, @updatedDiheds, @updatedImprops);
	my (@temp, @bonded1, @bonded2, @bonded3);

	# Bond between closest linker pair
	push(@bondsToAdd, [$polymClosest1, $polymClosest2]);

	# Extra bonds
	if ($polymBondFlag) {
		@temp = getExtraBonds($polymClosest1, $polymClosest2);
		for (my $i = 0; $i < scalar(@temp); $i++) {
			push(@bondsToAdd, [@{$temp[$i]}]);
			printf "  Extra bond: (%d,%d)\n", $temp[$i][0], $temp[$i][1];
		}
	}

	# Update atoms in bonds
	for (my $i = 0; $i < scalar(@bondsToAdd); $i++)
	{
		($b1, $b2) = @{$bondsToAdd[$i]};

		# Get atom types of linking atoms
		$type1 = $atomTypesKey{$polymLink1};
		$type2 = $atomTypesKey{$polymLink2};
		$type3 = $atomTypesKey{$polymLinkNew1};
		$type4 = $atomTypesKey{$polymLinkNew2};
		errExit("Atom type '$polymLinkNew1' was not found.")
			if (!defined($type3));
		errExit("Atom type '$polymLinkNew2' was not found.")
			if (!defined($type4));

		# Adjust charges if linker atoms
		if ($polymChargeFlag) {
			$atomQ[$b1] -= $polymCharge1 if ($atomType[$b1] == $type1);
			$atomQ[$b2] -= $polymCharge2 if ($atomType[$b2] == $type2);
		}

		# Change types if linker atoms
		$atomType[$b1] = $type3 if ($atomType[$b1] == $type1);
		$atomType[$b2] = $type4 if ($atomType[$b2] == $type2);

		# Add to @atomBonds
		push(@{$atomBonds[$b1]}, $b2);
		push(@{$atomBonds[$b2]}, $b1);
	}

	# Update associated bonds, angles, dihedrals
	for (my $i = 0; $i < scalar(@bondsToAdd); $i++)
	{
		($b1, $b2) = @{$bondsToAdd[$i]};

		# Bonds
		@updatedBonds = (@{$atomBondNums[$b1]}, @{$atomBondNums[$b2]});
		@updatedBonds = (uniqueArray(@updatedBonds));

		for (my $j = 0; $j < scalar(@updatedBonds); $j++)
		{
			$num = $updatedBonds[$j];
			($type1, $a1, $a2) = @{$bonds[$num]};
			$t1 = $atomTypes[$atomType[$a1]];
			$t2 = $atomTypes[$atomType[$a2]];

			$type2 = getType([$t1, $t2], \@bondTypes, 0);
			errExit("Did not find bond type 2 '$t1,$t2'.") if ($type2 == -1);

			$bonds[$num] = [$type2, $a1, $a2];
		}

		# Angles
		@updatedAngles = (@{$atomAngleNums[$b1]}, @{$atomAngleNums[$b2]});
		@updatedAngles = (uniqueArray(@updatedAngles));

		for (my $j = 0; $j < scalar(@updatedAngles); $j++)
		{
			$num = $updatedAngles[$j];
			($type1, $a1, $a2, $a3) = @{$angles[$num]};
			$t1 = $atomTypes[$atomType[$a1]];
			$t2 = $atomTypes[$atomType[$a2]];
			$t3 = $atomTypes[$atomType[$a3]];

			$type2 = getType([$t1, $t2, $t3], \@angleTypes, 0);
			errExit("Did not find angle type '$t1,$t2,$t3'.") if ($type2 == -1);

			$angles[$num] = [$type2, $a1, $a2, $a3];
		}

		# Dihedrals
		@updatedDiheds = (@{$atomDihedNums[$b1]}, @{$atomDihedNums[$b2]});
		@updatedDiheds = (uniqueArray(@updatedDiheds));

		for (my $j = 0; $j < scalar(@updatedDiheds); $j++)
		{
			$num = $updatedDiheds[$j];
			($type1, $a1, $a2, $a3, $a4) = @{$diheds[$num]};
			$t1 = $atomTypes[$atomType[$a1]];
			$t2 = $atomTypes[$atomType[$a2]];
			$t3 = $atomTypes[$atomType[$a3]];
			$t4 = $atomTypes[$atomType[$a4]];
			$type2 = getType([$t1, $t2, $t3, $t4], \@dihedTypes, 0);
			# errExit("Did not find dihedral type '$t1,$t2,$t3,$t4,$a1,$a2,$a3,$a4'.")
#			warn("Did not find dihedral type '$t1,$t2,$t3,$t4,$a1,$a2,$a3,$a4'.")
#				if ($type2 == -1);

			if ($type2 != -1){
			$diheds[$num] = [$type2, $a1, $a2, $a3, $a4];
			}
		}

		# Impropers
=a
		@updatedImprops = (@{$atomImpropNums[$b1]}, @{$atomImpropNums[$b2]});
		@updatedImprops = (uniqueArray(@updatedImprops));

		for (my $j = 0; $j < scalar(@updatedImprops); $j++)
		{
			$num = $updatedImprops[$j];
			($type1, $a1, $a2, $a3, $a4) = @{$improps[$num]};
			$t1 = $atomTypes[$atomType[$a1]];
			$t2 = $atomTypes[$atomType[$a2]];
			$t3 = $atomTypes[$atomType[$a3]];
			$t4 = $atomTypes[$atomType[$a4]];

			$type2 = getType([$t1, $t2, $t3, $t4], \@impropTypes, 1);
			errExit("Did not find improper type '$t1,$t2,$t3,$t4'.")
				if ($type2 == -1);

			$improps[$num] = [$type2, $a1, $a2, $a3, $a4];
		}
=cut
	}

	# Define new angles, dihedrals, and impropers
	for (my $i = 0; $i < scalar(@bondsToAdd); $i++)
	{
		# Atoms and their bonded atoms
		($b1, $b2) = @{$bondsToAdd[$i]};
		@bonded1 = @{$atomBonds[$b1]};
		@bonded2 = @{$atomBonds[$b2]};

		for (my $j = 0; $j < scalar(@bonded2); $j++)
		{
			$a3 = $bonded2[$j];
			next if ($a3 == $b1);
			@bonded3 = @{$atomBonds[$a3]};

			# Add angle 1,2,x
			push(@anglesToAdd, [$b1, $b2, $a3]);

			for (my $k = 0; $k < scalar(@bonded3); $k++)
			{
				$a4 = $bonded3[$k];
				next if ($a4 == $b2);

				# Add dihedrals 1,2,x,y
				push(@dihedsToAdd, [$b1, $b2, $a3, $a4]);
			}
		}

		for (my $j = 0; $j < scalar(@bonded1); $j++)
		{
			$a3 = $bonded1[$j];
			next if ($a3 == $b2);
			@bonded3 = @{$atomBonds[$a3]};

			# Add angle 2,1,x
			push(@anglesToAdd, [$b2, $b1, $a3]);

			for (my $k = 0; $k < scalar(@bonded3); $k++)
			{
				$a4 = $bonded3[$k];
				next if ($a4 == $b1);

				# Add dihedral 2,1,x,y
				push(@dihedsToAdd, [$b2, $b1, $a3, $a4]);
			}

			for (my $k = 0; $k < scalar(@bonded2); $k++)
			{
				$a4 = $bonded2[$k];
				next if ($a4 == $b1);

				# Add dihedral x,1,2,y
				push(@dihedsToAdd, [$a3, $b1, $b2, $a4]);
			}
		}

		$num = scalar(@bonded1);
		if ($num > 1)
		{
			for (my $j = 0; $j < $num-1; $j++)
			{
				$a3 = $bonded1[$j];
				next if ($a3 == $b2);

				for (my $k = $j+1; $k < $num; $k++)
				{
					$a4 = $bonded1[$k];
					next if ($a4 == $b2);

					# Add improper 2,1,x,y
					push(@impropsToAdd, [$b2, $b1, $a3, $a4]);
				}
			}
		}

		$num = scalar(@bonded2);
		if ($num > 1)
		{
			for (my $j = 0; $j < $num-1; $j++)
			{
				$a3 = $bonded2[$j];
				next if ($a3 == $b1);

				for (my $k = $j+1; $k < $num; $k++)
				{
					$a4 = $bonded2[$k];
					next if ($a4 == $b1);

					# Add improper 1,2,x,y
					push(@impropsToAdd, [$b1, $b2, $a3, $a4]);
				}
			}
		}
	}

	# Get unique arrays
	@bondsToAdd = (uniqueAofA(\@bondsToAdd, 0));
	@anglesToAdd = (uniqueAofA(\@anglesToAdd, 0));
	@dihedsToAdd = (uniqueAofA(\@dihedsToAdd, 0));
	@impropsToAdd = (uniqueAofA(\@impropsToAdd, 1));

	# Add new bonds
	for (my $i = 0; $i < scalar(@bondsToAdd); $i++)
	{
		($a1, $a2) = @{$bondsToAdd[$i]};
		$t1 = $atomTypes[$atomType[$a1]];
		$t2 = $atomTypes[$atomType[$a2]];

		$type1 = getType([$t1, $t2], \@bondTypes, 0);
		errExit("Did not find bond type 1 '$t1,$t2'.") if ($type1 == -1);

		$numBonds++;
		$bonds[$numBonds] = [$type1, $a1, $a2];
	}

	# Add new angles
	for (my $i = 0; $i < scalar(@anglesToAdd); $i++)
	{
		($a1, $a2, $a3) = @{$anglesToAdd[$i]};
		$t1 = $atomTypes[$atomType[$a1]];
		$t2 = $atomTypes[$atomType[$a2]];
		$t3 = $atomTypes[$atomType[$a3]];

		$type1 = getType([$t1, $t2, $t3], \@angleTypes, 0);
		errExit("Did not find angle type '$t1,$t2,$t3'.") if ($type1 == -1);

		$numAngles++;
		$angles[$numAngles] = [$type1, $a1, $a2, $a3];
	}

	# Add new dihedrals
	for (my $i = 0; $i < scalar(@dihedsToAdd); $i++)
	{
		($a1, $a2, $a3, $a4) = @{$dihedsToAdd[$i]};
		$t1 = $atomTypes[$atomType[$a1]];
		$t2 = $atomTypes[$atomType[$a2]];
		$t3 = $atomTypes[$atomType[$a3]];
		$t4 = $atomTypes[$atomType[$a4]];

		$type1 = getType([$t1, $t2, $t3, $t4], \@dihedTypes, 0);
		# errExit("Did not find dihedral type '$t1,$t2,$t3,$t4'.")
#		warn("Did not find dihedral type '$t1,$t2,$t3,$t4'.")
#			if ($type1 == -1);

		if ($type1 != -1) {
		$numDiheds++;
		$diheds[$numDiheds] = [$type1, $a1, $a2, $a3, $a4];
	  }
	}

	# Add new impropers
	for (my $i = 0; $i < scalar(@impropsToAdd); $i++)
	{
		($a1, $a2, $a3, $a4) = @{$impropsToAdd[$i]};
		$t1 = $atomTypes[$atomType[$a1]];
		$t2 = $atomTypes[$atomType[$a2]];
		$t3 = $atomTypes[$atomType[$a3]];
		$t4 = $atomTypes[$atomType[$a4]];

		$type1 = getType([$t1, $t2, $t3, $t4], \@impropTypes, 1);
		#errExit("Did not find improper type '$t1,$t2,$t3,$t4'.")
#		warn("Did not find improper type '$t1,$t2,$t3,$t4'.")
#			if ($type1 == -1);

		if ($type1 != -1) {
		$numImprops++;
		$improps[$numImprops] = [$type1, $a1, $a2, $a3, $a4];
		}
	}

	# Get min and max molecule numbers
	$mol1 = $atomMol[$polymClosest1];
	$mol2 = $atomMol[$polymClosest2];

	if ($mol1 > $mol2) {
		$min = $mol2;
		$max = $mol1;
	} elsif ($mol1 < $mol2) {
		$min = $mol1;
		$max = $mol2;
	} else {
		$min = 0;
		$max = 0;
	}

	# Change max molecule number to min
	if ($min > 0 && $max > 0)
	{
		@temp = @{$molecules[$max]};
		foreach my $atom (@temp) {
			$atomMol[$atom] = $min;
		}
	}

	# Move highest number molecule to max spot
	if ($max != $numMols && $min > 0 && $max > 0)
	{
		@temp = @{$molecules[$numMols]};
		foreach my $atom (@temp) {
			$atomMol[$atom] = $max;
		}
	}

	# Decrement molecules count
	$numMols-- if ($min > 0 && $max > 0);
}

# getExtraBonds( $a1, $a2 )
# Gets atom numbers of extra bonds to be added during the polymerization step,
# given the atom numbers of the closest pair of linkers
sub getExtraBonds
{
	# Variables
	my $a1 = $_[0];
	my $a2 = $_[1];
	my ($next, $atom1, $atom2, $a3, $a4);
	my (@atoms, @toDefine, @connect, @bonded, @bondsToAdd);

	# Return if no extra bonds to add
	return if ($polymBondFlag == 0);

	# Define initial atoms
	$atoms[1] = $a1;
	$atoms[2] = $a2;
	push(@toDefine, 1);
	push(@toDefine, 2);

	# Define connected atoms
	while (scalar(@toDefine) > 0)
	{
		$next = shift(@toDefine);
		@connect = @{$polymConnect[$next]};
		@bonded = @{$atomBonds[ $atoms[$next] ]};

		for (my $i = 0; $i < scalar(@bonded); $i++)
		{
			$atom1 = $bonded[$i];

			for (my $j = 0; $j < scalar(@connect); $j++)
			{
				$atom2 = $connect[$j];

				# Check if bonded atom1 matches connect record atom2
				if ($atomTypes[$atomType[$atom1]] eq $polymTypes[$atom2])
				{
					# Quit if not a unique description
					errExit("Atom connectivity in input script is not unique.")
						if ($atoms[$atom2]);

					$atoms[$atom2] = $atom1;
					push(@toDefine, $atom2)
						if ($polymConnect[$atom2]);
				}
			}
		}
	}

	# Add bonds to array
	for (my $i = 0; $i < scalar(@polymBonds); $i++)
	{
		($a3, $a4) = @{$polymBonds[$i]};
		errExit("Atoms not defined properly in connectivity definition.")
			if (!$atoms[$a3] || !$atoms[$a4]);
		push(@bondsToAdd, [$atoms[$a3], $atoms[$a4]]);
	}

	return @bondsToAdd;
}

# uniqueArray( @array )
# Return array with only the unique values
sub uniqueArray
{
	# Variables
	my @array = @_;

	my %hash = map { $_ => 1 } @array;
	my @unique = keys %hash;

	return @unique;
}

# uniqueAofA( \@array, $imp )
# Return array of arrays with only unique sub arrays
# For bonds, angles, and dihedrals, two arrays within @array are not unique if
# they have the same values in reverse order
# For impropers, two arrays within @array are not unique if they have the same
# j value and the same i,k,l values in any order
sub uniqueAofA
{
	# Parameters
	my @array = @{$_[0]};
	my $imp = $_[1];
	my ($s0, $s1, $s2, $s3, $s4, $s5, $s6, $num1, $num2, $flag);
	my (@unique, @a1, @a2);

	# Return if empty
	$num1 = scalar(@array);
	return @array if ($num1 == 0);

	# First is unique
	push (@unique, [@{$array[0]}]);

	# Check remaining
	for (my $i = 1; $i < $num1; $i++)
	{
		@a1 = @{$array[$i]};
		$num2 = scalar(@unique);
		$flag = 0;

		# Impropers
		if ($imp) {
			$s1 = join (',', @a1);
			$s2 = $a1[0].','.$a1[1].','.$a1[3].','.$a1[2];
			$s3 = $a1[2].','.$a1[1].','.$a1[0].','.$a1[3];
			$s4 = $a1[2].','.$a1[1].','.$a1[3].','.$a1[0];
			$s5 = $a1[3].','.$a1[1].','.$a1[0].','.$a1[2];
			$s6 = $a1[3].','.$a1[1].','.$a1[2].','.$a1[0];
		}

		# Bonds, angles, or dihedrals
		else {
			$s1 = join (',', @a1);
			$s2 = join (',', reverse(@a1));
		}

		# Check against unique arrays
		for (my $j = 0; $j < $num2; $j++)
		{
			@a2 = @{$unique[$j]};
			$s0 = join (',', @a2);

			# Impropers
			if ($imp)
			{
				last if ($s1 eq $s0 || $s2 eq $s0 || $s3 eq $s0 ||
						 $s4 eq $s0 || $s5 eq $s0 || $s6 eq $s0);
				$flag++;
			}

			# Bonds, angles, or dihedrals
			else
			{
				last if ($s1 eq $s0 || $s2 eq $s0);
				$flag++;
			}
		}

		# Add if unique
		if ($flag == $num2) {
			push ( @unique, [@a1] );
		}
	}

	return @unique;
}

# getType( \@list, \@types, flag )
# Get data type for bond, angle, dihedral, improper with atom types in @list
# for types defined as @types {typeID => typeString}
# Impropers do not have reversible orders, so they are flagged 1
# Return -1 if no match is found
sub getType
{
	# Variables
	my (@list) = @{$_[0]};
	my (@types) = @{$_[1]};
	my $flag = $_[2];
	my $string;

	# Search for list in original order
	$string = join(',', @list);
	for (my $i = 0; $i < scalar(@types); $i++) {
		return $i if ($types[$i] eq $string);
	}

	if ($flag == 1)
	{
		# Search for other improper orders
		$string = $list[0].','.$list[1].','.$list[3].','.$list[2];
		for (my $i = 0; $i < scalar(@types); $i++) {
			return $i if ($types[$i] eq $string);
		}

		$string = $list[2].','.$list[1].','.$list[0].','.$list[3];
		for (my $i = 0; $i < scalar(@types); $i++) {
			return $i if ($types[$i] eq $string);
		}

		$string = $list[2].','.$list[1].','.$list[3].','.$list[0];
		for (my $i = 0; $i < scalar(@types); $i++) {
			return $i if ($types[$i] eq $string);
		}

		$string = $list[3].','.$list[1].','.$list[0].','.$list[2];
		for (my $i = 0; $i < scalar(@types); $i++) {
			return $i if ($types[$i] eq $string);
		}

		$string = $list[3].','.$list[1].','.$list[2].','.$list[0];
		for (my $i = 0; $i < scalar(@types); $i++) {
			return $i if ($types[$i] eq $string);
		}
	}
	else
	{
		# Search for list in reverse order
		$string = join(',', reverse(@list));
		for (my $i = 0; $i < scalar(@types); $i++) {
			return $i if ($types[$i] eq $string);
		}
	}

	# Return -1 if no match found
	return -1;
}

# readPolymInput( $file )
# Read input script for Polymatic polymerization step
sub readPolymInput
{
	# Variables
	my $file = $_[0];
	my ($command, $secConnect, $secTypes);
	my @params;

	# Initialize flags
	$polymBondFlag = 0;
	$polymAlignFlag = 0;
	$polymChargeFlag = 0;
	$polymIntraFlag = 0;
	$secConnect = 0;
	$secTypes = 0;

	open POLYMIN, "< $file" or die "Error opening file '$file': $!";

	while (my $line = <POLYMIN>)
	{
		chomp($line);
		$line =~ s/^\s+//;

		# Split line by spaces
		@params = split(' ', $line);
		$command = $params[0];

		# Section flags
		if ($command eq 'connect') {
			$secConnect = 1;
			$secTypes = 0;
			next;
		} elsif ($command eq 'types') {
			$secTypes = 1;
			$secConnect = 0;
			next;
		}

		# Connect records
		if ($secConnect) {
			$polymConnect[$command] = [ split(',', $params[1]) ];
		}

		# Type records
		elsif ($secTypes) {
			$polymTypes[$command] = $params[1];
		}

		# Cutoff
		elsif ($command eq 'cutoff') {
			$polymCutoff = $params[1];
		}

		# Linking atoms
		elsif ($command eq 'link') {
			($polymLink1, $polymLinkNew1) = split(',', $params[1]);
			($polymLink2, $polymLinkNew2) = split(',', $params[2]);
		}

		# Intramolecular bonding
		elsif ($command eq 'intra') {
			$polymIntraFlag = 1 if ($params[1] eq 'true');
		}

		# Linking atom charges
		elsif ($command eq 'charge') {
			$polymCharge1 = $params[1];
			$polymCharge2 = $params[2];
			$polymChargeFlag = 1;
		}

		# Additional bonds
		elsif ($command eq 'bond') {
			push( @polymBonds, [$params[1], $params[2]] );
			$polymBondFlag = 1;
		}

		# Plane alignment checks
		elsif ($command eq 'plane') {
			push ( @polymPlanes, [$params[1], $params[2], $params[3]] );
			$polymAlignFlag = 1;
		}

		# Vector alignment checks
		elsif ($command eq 'vector') {
			push ( @polymVectors, [$params[1], $params[2], $params[3]] );
			$polymAlignFlag = 1;
		}
	}

	close POLYMIN;

	# Check for required parameters
	errExit("Cutoff radius not properly defined.") if (!defined($polymCutoff));
	errExit("Reactive atoms not properly defined.")
		if (!defined($polymLink1) || !defined($polymLinkNew1)
			|| !defined($polymLink2) || !defined($polymLinkNew2));
}

# readTypes( $file )
# Read LAMMPS data types from a text types file
sub readTypes
{
	# Variables
	my $file = $_[0];
	my ($num, $string);

	# Section flags
	my $secAtom = 0;
	my $secBond = 0;
	my $secAngle = 0;
	my $secDihed = 0;
	my $secImprop = 0;

	open INTYPES, "< $file" or die "Error opening file '$file': $!";

	while (my $line = <INTYPES>)
	{
		chomp($line);
		$line =~ s/^\s+//;

		# Skip if commented line
		next if (substr($line,0,1) eq "#");

		# New section
		if (substr($line,0,10) eq "atom types" ||
			substr($line,0,10) eq "bond types" ||
			substr($line,0,11) eq "angle types" ||
			substr($line,0,14) eq "dihedral types" ||
			substr($line,0,14) eq "improper types")
		{
			$secAtom = 0;
			$secBond = 0;
			$secAngle = 0;
			$secDihed = 0;
			$secImprop = 0;

			$secAtom = 1 if (substr($line,0,10) eq "atom types");
			$secBond = 1 if (substr($line,0,10) eq "bond types");
			$secAngle = 1 if (substr($line,0,11) eq "angle types");
			$secDihed = 1 if (substr($line,0,14) eq "dihedral types");
			$secImprop = 1 if (substr($line,0,14) eq "improper types");

			next;
		}

		# Split line by space
		($num, $string) = split(' ', $line);

		# Atom section
		if ($secAtom) {
			$atomTypes[$num] = $string;
			$atomTypesKey{$string} = $num;
		}

		# Bond section
		elsif ($secBond) {
			$bondTypes[$num] = $string;
			$bondTypesKey{$string} = $num;
		}

		# Angle section
		elsif ($secAngle) {
			$angleTypes[$num] = $string;
			$angleTypesKey{$string} = $num;
		}

		# Dihedral section
		elsif ($secDihed) {
			$dihedTypes[$num] = $string;
			$dihedTypesKey{$string} = $num;
		}

		# Improper section
		elsif ($secImprop) {
			$impropTypes[$num] = $string;
			$impropTypesKey{$string} = $num;
		}
	}

	close INTYPES;

	# Check counts against data file
	errExit("Number of atom types in `$file' is not consistent.")
		if ($numAtomTypes != scalar(@atomTypes) - 1);
	errExit("Number of bond types in `$file' is not consistent.")
		if ($numBondTypes != scalar(@bondTypes) - 1);
	errExit("Number of angle types in `$file' is not consistent.")
		if ($numAngleTypes != scalar(@angleTypes) - 1);
	errExit("Number of dihedral types in `$file' is not consistent.")
		if ($numDihedTypes != scalar(@dihedTypes) - 1);
	errExit("Number of improper types in `$file' is not consistent.")
		if ($numImpropTypes != scalar(@impropTypes) - 1);
}

# readLammps( $file )
# Read LAMMPS data file
sub readLammps
{
	# Variables
	my $file = $_[0];
	my ($num, $mol, $type, $q, $x, $y, $z, $atom1, $atom2, $atom3, $atom4);
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
	$numMols = 0;
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

			# Save counts
			if ($temp[2] eq "types")
			{
				if ($temp[1] eq "atom") {
					$numAtomTypes = $temp[0];
				}
				elsif ($temp[1] eq "bond") {
					$numBondTypes = $temp[0];
				}
				elsif ($temp[1] eq "angle") {
					$numAngleTypes = $temp[0];
				}
				elsif ($temp[1] eq "dihedral") {
					$numDihedTypes = $temp[0];
				}
				elsif ($temp[1] eq "improper") {
					$numImpropTypes = $temp[0];
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

			$numMols = $mol if ($mol > $numMols);
			push ( @{$molecules[$mol]}, $num );
		}

		# Bonds section
		elsif ($secBonds && length($line) > $emptyLine)
		{
			($num, $type, $atom1, $atom2) = @temp;
			$bonds[$num] = [$type, $atom1, $atom2];

			push ( @{$atomBonds[$atom1]}, $atom2 );
			push ( @{$atomBonds[$atom2]}, $atom1 );
			push ( @{$atomBondNums[$atom1]}, $num );
			push ( @{$atomBondNums[$atom2]}, $num );
		}

		# Angles section
		elsif ($secAngles && length($line) > $emptyLine)
		{
			($num, $type, $atom1, $atom2, $atom3) = @temp;
			$angles[$num] = [$type, $atom1, $atom2, $atom3];

			push ( @{$atomAngles[$atom1]}, $atom2, $atom3 );
			push ( @{$atomAngles[$atom3]}, $atom2, $atom1 );
			push ( @{$atomAngleNums[$atom1]}, $num );
			push ( @{$atomAngleNums[$atom2]}, $num );
			push ( @{$atomAngleNums[$atom3]}, $num );
		}

		# Dihedrals section
		elsif ($secDiheds && length($line) > $emptyLine)
		{
			($num, $type, $atom1, $atom2, $atom3, $atom4) = @temp;
			$diheds[$num] = [$type, $atom1, $atom2, $atom3, $atom4];

			push ( @{$atomDiheds[$atom1]}, $atom2, $atom3, $atom4 );
			push ( @{$atomDiheds[$atom4]}, $atom3, $atom2, $atom1 );
			push ( @{$atomDihedNums[$atom1]}, $num );
			push ( @{$atomDihedNums[$atom2]}, $num );
			push ( @{$atomDihedNums[$atom3]}, $num );
			push ( @{$atomDihedNums[$atom4]}, $num );
		}

		# Impropers section
		elsif ($secImprops && length($line) > $emptyLine)
		{
			($num, $type, $atom1, $atom2, $atom3, $atom4) = @temp;
			$improps[$num] = [$type, $atom1, $atom2, $atom3, $atom4];

			push ( @{$atomImprops[$atom2]}, $atom1, $atom3, $atom4 );
			push ( @{$atomImpropNums[$atom1]}, $num );
			push ( @{$atomImpropNums[$atom2]}, $num );
			push ( @{$atomImpropNums[$atom3]}, $num );
			push ( @{$atomImpropNums[$atom4]}, $num );
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

=a
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
=cut
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

=a
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
=cut
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

=a
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
=cut
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
