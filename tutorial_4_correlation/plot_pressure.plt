#!/usr/bin/gnuplot
# Auther (original): Murashima @ Tohoku Univ on Dec/8/2020
# slightly modified: By Student on Dec/31/2020

# timestep on in.lmp
dt=0.01

set terminal win font "Arial,12"

#set size square
set xlabel "Time [{/Symbol t}]"
set ylabel "Pressure [{/Symbol e/s^3}]"
#set xrange[0.0:1.0e+3]
#set yrange[-2.0:6.0]
#set key outside

set mxtics 5
set mytics 5

plot \
'pressure.txt' u (dt*$1):($2) t 'pxx' w l,\
'pressure.txt' u (dt*$1):($3) t 'pyy' w l,\
'pressure.txt' u (dt*$1):($4) t 'pzz' w l,\
'pressure.txt' u (dt*$1):($5) t 'pxy' w l,\
'pressure.txt' u (dt*$1):($6) t 'pxz' w l,\
'pressure.txt' u (dt*$1):($7) t 'pyz' w l

#pause -1

set terminal postscript enhanced color eps "Arial,24"
set output "pressure.eps"
replot

set terminal png
set output "pressure.png"
replot

set terminal postscript color enhanced lw 2
set out "pressure.ps"
replot
