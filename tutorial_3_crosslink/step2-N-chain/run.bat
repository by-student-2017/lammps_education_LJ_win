mkdir cfg

"C:\Program Files\LAMMPS 64-bit 18Jun2019\bin\lmp_serial.exe" -in in2.lmp

rem copy restart2.* ..\step3-crosslink\restart2.*

copy data.in2.restart ..\step3-crosslink\data.in2.restart