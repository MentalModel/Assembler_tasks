@echo off
cls
C:\DOS\BP\bin\tasm /zi /la /c /m2  %1
if errorlevel 1 goto ert
C:\DOS\BP\bin\tlink /t /v /m /i /l /s /n %1
if errorlevel 1 goto erl
echo ***********GOOD*************
goto end
:ert
echo *********** There are some errors found by translator!!!!*********
goto end
:erl
echo *********** The Editor of Links found some errors!!!!*****
:end
pause
