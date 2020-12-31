#!/usr/bin/gnuplot
# Auther (original): Murashima @ Tohoku Univ on Dec/8/2020

set format x "10^{%L}"
set format y "10^{%L}"

set xlabel "Time [{/Symbol t}]"
set ylabel "Relaxation modulus [{/Symbol e/s^3}]"
set logscale
set xrange [1.0e-2:1.0e+3]
set yrange [1.0e-4:]
N=10
M=1000
Density=0.85
Volume=N*M/Density
Temperature=1.0
Coefficient=Density*Temperature/N
tau_R=100

Rouse(t,p)=(p>=1 ? Rouse(t,p-1)+Coefficient*exp(-2.0*t*p**2/(tau_R)) :0.0)

### Equation (7.31) p. 226 in Doi-Edwards. 

V_T=Volume/Temperature

set size square

p \
'gt.txt' u 1:($2) t 'G' w lp lw 2 lc rgb "blue",\
Rouse(x,10) t 'Rouse G' w l lw 2 lc rgb "magenta"
#pause -1

set terminal postscript enhanced color eps "Arial,24"
set output "gt.eps"
replot

set terminal png
set output "gt.png"
replot

