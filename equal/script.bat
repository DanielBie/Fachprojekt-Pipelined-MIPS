@ECHO OFF
:Loop
IF "%1"=="" GOTO Continue
ghdl -s %1 
if %ERRORLEVEL% neq 0 GOTO ERRORs
ECHO Syntax-Check OK
ghdl -a %1
if %ERRORLEVEL% neq 0 GOTO ERRORa
ECHO Analysis OK
ghdl -e %~n1
if %ERRORLEVEL% neq 0 GOTO ERRORe
ECHO Build OK
rem n1_ist_der_dateiname_(der_ersten_datei_)ohne_dateiendung_x1
ghdl -r %~n1 --vcd=testbench.vcd
if %ERRORLEVEL% neq 0 GOTO ERRORr
ECHO VCD-Dump OK
gtkwave testbench.vcd
if %ERRORLEVEL% neq 0 GOTO ERRORgtk
ECHO Succesfully started GTKWave
SHIFT
GOTO Loop


:ERRORs
ECHO Syntax-Check failed
GOTO Continue
:End

:ERRORa
ECHO Analysis failed
GOTO Continue
:End

:ERRORe
ECHO Build failed
GOTO Continue
:End

:ERRORr1
ECHO VCD-Dump failed
GOTO Continue
:End

:ERRORgtk
ECHO Starting GTKWave failed
GOTO Continue
:End

:Continue
pause

