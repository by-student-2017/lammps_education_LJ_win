mkdir cfg

"C:\Program Files\LAMMPS 64-bit 18Jun2019\bin\lmp_serial.exe" -in in3.lmp

copy restart3.*       ..\step4-analysis\restart3.*

copy restart3.*       ..\..\tutorial_4_correlation\data.in3.restart

copy corr.long.*.dat  ..\..\tutorial_5_G1G2\corr.long.*.dat

copy data.in3.restart ..\..\tutorial_6_shear\data.in3.restart

copy data.in3.restart ..\..\tutorial_7_uni\data.in3.restart