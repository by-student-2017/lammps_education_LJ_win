This directory contains example data and input files 
and utility scripts for the oxDNA coarse-grained model 
for DNA.

/examples/duplex1:
Input, data and log files for a DNA duplex (double-stranded DNA) 
consisiting of 5 base pairs. The duplex contains two strands with 
complementary base pairs. The topology is

A - C - G - T - A
|   |   |   |   |
T - G - C - A - T     

/examples/duplex2:
Input, data and log files for a nicked DNA duplex (double-stranded DNA) 
consisiting of 8 base pairs. The duplex contains strands with 
complementary base pairs, but the backbone on one side is not continuous: 
two individual strands on one side form a duplex with a longer single 
strand on the other side. The topology is

A - C - G - T - A - C - G - T
|   |   |   |   |   |   |   |
T - G - C - A   T - G - C - A

/util:
This directory contains a simple python setup tool which creates 
single straight or helical DNA strands, DNA duplexes or arrays of DNA 
duplexes.
