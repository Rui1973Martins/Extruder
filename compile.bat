
cd c:\Users\xpta366\_DEV_\_Spectrum_\_Assembly_\_SRC_\Extruder

REM pasmo.exe    --alocal --tap Extruder.asm code.tap Extruder.symbol
pasmo.exe -d --alocal --tap Extruder.asm code.tap Extruder.symbol

@IF errorlevel 1 GOTO error

copy /b /y Init.tap+code.tap Extruder_test.tap > nul
del code.tap


start /B "C:\Users\xpta366\_DEV_\_Spectrum_\_Software_\emulator\Zero_0.6.6\Zero.exe" Extruder_test.tap

@pause

goto exit

:error
@pause
:
:exit
