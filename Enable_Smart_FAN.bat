@echo off
::sg_scan -s to Show the device for AIC Expander Controller 

set /p SCSI=Input Expander Controller:

:: Auto-detect descriptor (CoolingElement00 or SysCoolingElement00)
set "desc=CoolingElement00"
sg_ses -p ed %SCSI% | findstr /i "SysCoolingElement00" >nul
if %errorlevel% equ 0 set "desc=SysCoolingElement00"
echo Using descriptor: %desc%

sg_ses --descriptor=%desc% --clear=1:7:1 %SCSI%

pause