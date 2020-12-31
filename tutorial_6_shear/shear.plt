#!/usr/bin/gnuplot
# Auther (original): Murashima @ Tohoku Univ on Dec/8/2020

set size square
set xlabel "Time [{/Symbol t}]"
set ylabel "Shear stress [{/Symbol e/s^3}]"
set xrange[0:1.0e+3]
set key outside

dt=0.01

p \
'pressure.0.001.txt' u (dt*$1):(-$5) t '0.001' w l,\
'pressure.0.01.txt' u (dt*$1):(-$5) t '0.01' w l,\
'pressure.0.1.txt' u (dt*$1):(-$5) t '0.1' w l



#pause -1

set terminal postscript enhanced color eps "Arial,24"
set output "shear.eps"
replot

set terminal png
set output "shear.png"
replot

