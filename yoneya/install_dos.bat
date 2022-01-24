@echo off

if exist "C:\Program Files\University of Illinois" (
	SET VMD_ROOT="C:\Program Files\University of Illinois"
	echo VMD        was found in %VMD_ROOT%
) else if exist "C:\Program Files (x86)\University of Illinois" (
	SET VMD_ROOT="C:\Program Files (x86)\University of Illinois"
	echo VMD        was found in %VMD_ROOT%
) else (
	echo Warning! VMD installation was not found.
	echo Install  VMD and try again.
	exit /b 1
)

if exist "C:\Program Files (x86)\Gow" (
	SET GOW_ROOT="C:\Program Files (x86)\Gow"
	echo Gow        was found in %GOW_ROOT%
) else if exist "C:\Program Files\Gow" (
	SET GOW_ROOT="C:\Program Files\Gow"
	echo Gow        was found in %GOW_ROOT%
) else (
	echo Warning! Gow installation was not found.
	echo Install  Gow and try again.
	exit /b 1
)

if exist "C:\Program Files (x86)\OpenBabel-2.4.1" (
	SET BABELHOME="C:\Program Files (x86)\OpenBabel-2.4.1"
	echo OpenBabel  was found in %BABELHOME%
) else if exist "C:\Program Files\OpenBabel-2.4.1" (
	SET BABELHOME="C:\Program Files\OpenBabel-2.4.1"
	echo OpenBabel  was found in %BABELHOME%
) else (
	echo Warning! OpenBabel installation was not found.
	echo Install  OpenBabel-2.4.1 and try again.
	exit /b 1
)

SET MAIN_ROOT=C:\opt

if not exist %MAIN_ROOT% (
	echo * creating  %MAIN_ROOT%
	mkdir %MAIN_ROOT%
)

if exist %MAIN_ROOT%\topolbuild (
	echo topolBuild was found in %MAIN_ROOT%\topolbuild
) else (
	echo ** installing topolBuild
	%GOW_ROOT%\bin\wget -nv https://github.com/makoto-yoneya/topolbuild-nohrenum/releases/download/1.3.1/topolbuild-1.3-mingw.zip
	%GOW_ROOT%\bin\unzip -q topolbuild-1.3-mingw.zip -d %MAIN_ROOT%
	del topolbuild-1.3-mingw.zip
)

if exist %MAIN_ROOT%\gromacs (
	echo gromacs    was found in %MAIN_ROOT%\gromacs
) else (
	echo *** installing gromacs
	%GOW_ROOT%\bin\wget -nv https://github.com/makoto-yoneya/gromacs-MSVC/releases/download/2019.6.win32/gromacs-2019.6-win32.zip
	%GOW_ROOT%\bin\unzip -q gromacs-2019.6-win32.zip -d %MAIN_ROOT%
	del gromacs-2019.6-win32.zip
)

REM echo moving to home
chdir %HOMEPATH%

if exist GMXRC.bat (
	echo deleating old GMXRC.bat
	del GMXRC.bat
)

if not exist GMXRC.bat (
	echo creating  new GMXRC.bat
	echo @echo off > GMXRC.bat
	echo REM >> GMXRC.bat
	echo REM Open DOS window with specified PATH setting. >> GMXRC.bat
	echo REM >> GMXRC.bat
	echo SET MAIN_ROOT=%MAIN_ROOT%>> GMXRC.bat
	echo SET VMD_ROOT=%VMD_ROOT%>> GMXRC.bat
	echo SET BABELHOME=%BABELHOME%>> GMXRC.bat
	echo SET VMDDIR=%VMD_ROOT%\VMD>> GMXRC.bat
	echo SET TBHOME=%%MAIN_ROOT%%\topolbuild>> GMXRC.bat
	echo SET GMXHOME=%%MAIN_ROOT%%\gromacs>> GMXRC.bat
	echo SET GMXDATA=%%GMXHOME%%\share\gromacs;%%TBHOME%%\water_and_ions>> GMXRC.bat
	echo SET GMXLIB=%%GMXHOME%%\share\gromacs\top;%%TBHOME%%\water_and_ions>> GMXRC.bat
	echo SET PATH=%%GMXHOME%%\bin;%%TBHOME%%;%%VMDDIR%%;%%BABELHOME%%;%%PATH%%>> GMXRC.bat
	echo IF "%%1" EQU "" %%windir%%\system32\cmd.exe>> GMXRC.bat
)
