
cd c:\Users\xpta366\_DEV_\_Spectrum_\_Assembly_\_SRC_\Extruder

pasmo.exe -d --alocal --bin _data_.asm _DATA_.bin _DATA_.symbol

@IF errorlevel 1 GOTO error

@pause

goto exit

:error
@pause

:exit
