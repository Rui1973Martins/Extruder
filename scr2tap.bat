REM NOt setting output extension, to get a correct header block name
pasmo.exe --tap %1.asm %1

del %1.tap

ren %1 %1.tap



