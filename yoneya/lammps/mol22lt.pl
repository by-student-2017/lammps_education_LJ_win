#!/usr/bin/perl

#    mol22lt	M.Yoneya   08.17.2019 

$status = "initial";

while ( <> ) {
	$line = $_; 
	chomp $_;
	if ( $_ =~ m/^\s+(.*)/ ) {
		$_ = $1;
	}

	@_ = split (/\s+/, $_);

	if ( $_[0] eq "@<TRIPOS>MOLECULE"  ) {
		$status = "molecule";
	} elsif ( $_[0] eq "@<TRIPOS>ATOM"  ) {
		$status = "atom";
		print "  write('Data Atoms') {\n";
		print "#   atomID       molID    atomType        charge    X         Y         Z\n";
	} elsif ( $_[0] eq "@<TRIPOS>BOND"  ) {
		$status = "bond";
		print "  }\n";
		print "\n";
		print "  write('Data Bond List') {\n";
		print "#   bondID        atomID       atomID\n";
	} elsif ( $_[0] eq "@<TRIPOS>SUBSTRUCTURE"  ) {
		$status = "end";
		print "  }\n";
		print "\n";
		print "} # ".$molname."\n";
	} elsif ( $status eq "molecule" ) {
		print "\#\n";
		print "\#   This is output of mol22lt\n";
		print "\#\n";
		print "\#   import \"gaff.lt\"\n";
		print "\n";
		$molname = $_[0];
		print $molname." inherits GAFF {\n";
		print "\n";
		$status = "gap_after_molecule";
	} elsif ( $status eq "atom" ) {
		@modlin = split (/\s+/, $line);
		$atomname[$modlin[1]] = $modlin[2];
		$line = "    \$atom:".sprintf("%-7s", $modlin[2])."\$mol:".sprintf("%-4s", $modlin[7])."\@atom:".sprintf("%-7s", $modlin[6]).sprintf("%10.5f", $modlin[9]).sprintf("%10.5f", $modlin[3]).sprintf("%10.5f", $modlin[4]).sprintf("%10.5f", $modlin[5])."\n";
		print $line;
	} elsif ( $status eq "bond" ) {
		@modlin = split (/\s+/, $line);
		$line = "    \$bond:b".sprintf("%-7s", $modlin[1])."\$atom:".sprintf("%-7s", $atomname[$modlin[2]])."\$atom:".sprintf("%-7s", $atomname[$modlin[3]])."\n";
		print $line;
	}
}
