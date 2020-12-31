#!/usr/bin/gnuplot
# Auther (original): Murashima @ Tohoku Univ on Dec/8/2020

set size square
set xlabel "Time [{/Symbol t}]"
set ylabel "Normal stress difference [{/Symbol e/s^3}]"
set logscale 
set key outside

dt=0.01 

p \
'pressure.0.001.txt' u (dt*$1):(-($2-0.5*($3+$4))) t '0.001' w l,\
'pressure.0.01.txt' u (dt*$1):(-($2-0.5*($3+$4))) t '0.01' w l,\
'pressure.0.1.txt' u (dt*$1):(-($2-0.5*($3+$4))) t '0.1' w l



#pause -1

set terminal postscript enhanced color eps "Arial,24"
set output "uni.eps"
replot

set terminal png
set output "uni.png"
replot

