@echo off
::sg_scan -s to Show the device for AIC Expander Controller 

::set /p SCSI=Input Expander Controller:
set /p FAN=Input Fan duty(7,6,5,4,3,2,1):
for /F %%i IN ('sg_scan -s ^| find "AIC"') DO set expaddress=%%i
set exp=%expaddress:~0,17%

:: Auto-detect descriptor (CoolingElement00 or SysCoolingElement00)
set "desc=CoolingElement00"
sg_ses -p ed %exp% | findstr /i "SysCoolingElement00" >nul
if %errorlevel% equ 0 set "desc=SysCoolingElement00"
echo Using descriptor: %desc%

sg_ses --descriptor=%desc% --set 3:2:3=%FAN% %exp%

pause
