mkdir Result

"C:\Program Files\LAMMPS 64-bit 18Jun2019\bin\lmp_serial.exe" -in in.uni.0.1
"C:\Program Files\LAMMPS 64-bit 18Jun2019\bin\lmp_serial.exe" -in in.uni.0.01
"C:\Program Files\LAMMPS 64-bit 18Jun2019\bin\lmp_serial.exe" -in in.uni.0.001

gnuplot uni.plt
move uni.png .\Result\uni.png
move uni.eps .\Result\uni.eps
move pressure.0.1.txt   .\Result\pressure.0.1.txt
move pressure.0.01.txt  .\Result\pressure.0.01.txt
move pressure.0.001.txt .\Result\pressure.0.001.txt
move N10M1000.0.1.res   .\Result\N10M1000.0.1.res
move N10M1000.0.01.res  .\Result\N10M1000.0.01.res
move N10M1000.0.001.res .\Result\N10M1000.0.001.res
