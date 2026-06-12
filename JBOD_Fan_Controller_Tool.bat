@echo off
title AIC JBOD Fan Controller Tool
setlocal EnableDelayedExpansion

:MENU
cls
echo ===================================================
echo             AIC JBOD Fan Controller Tool
echo ===================================================
echo  [1] Enable Smart Fan (Auto Detect)
echo  [2] Disable Smart Fan and Set Fan Duty (Auto Detect)
echo  [3] Exit
echo ===================================================
set /p Choice=Select option (1-3): 

if "%Choice%"=="1" goto AUTO_ENABLE
if "%Choice%"=="2" goto AUTO_DISABLE_AND_SET
if "%Choice%"=="3" goto EXIT
echo.
echo Error: Please enter a number between 1 and 3.
pause
goto MENU

:AUTO_ENABLE
echo.
echo === Enabling Smart Fan for all detected AIC enclosures ===
set "found=0"
for /F %%i in ('sg_scan -s ^| find "AIC"') do (
    set "found=1"
    echo ---------------------------------------------------
    echo Setting Enclosure: "%%i"
    
    :: Auto-detect descriptor (CoolingElement00 or SysCoolingElement00)
    set "desc=CoolingElement00"
    sg_ses -p ed %%i | findstr /i "SysCoolingElement00" >nul
    if !errorlevel! equ 0 set "desc=SysCoolingElement00"
    echo Using descriptor: !desc!

    sg_ses --descriptor=!desc! --clear=1:7:1 %%i
    
    :: Verify status
    sg_ses --descriptor=!desc! --get=1:7:1 %%i > info_A.tmp
    for /f %%a in (info_A.tmp) do (
        if "%%a"=="0" echo GET 0 : Enable Smart Fan - Success
        if "%%a"=="1" echo GET 1 : Enable Smart Fan - FAILED
    )
)
if "%found%"=="0" echo No AIC Expander devices detected.
if exist *.tmp del /Q *.tmp
echo.
pause
goto MENU

:AUTO_DISABLE_AND_SET
echo.
echo === Disabling Smart Fan for all detected AIC enclosures ===
set "found=0"
for /F %%i in ('sg_scan -s ^| find "AIC"') do (
    set "found=1"
    echo ---------------------------------------------------
    echo Disabling Smart Fan on Enclosure: "%%i"
    
    :: Auto-detect descriptor (CoolingElement00 or SysCoolingElement00)
    set "desc=CoolingElement00"
    sg_ses -p ed %%i | findstr /i "SysCoolingElement00" >nul
    if !errorlevel! equ 0 set "desc=SysCoolingElement00"
    echo Using descriptor: !desc!

    sg_ses --descriptor=!desc! --set=1:7:1 %%i
    
    :: Verify status
    sg_ses --descriptor=!desc! --get=1:7:1 %%i > info_A.tmp
    for /f %%a in (info_A.tmp) do (
        if "%%a"=="0" echo GET 0 : Disable Smart Fan - FAILED
        if "%%a"=="1" echo GET 1 : Disable Smart Fan - Success
    )
)
if exist *.tmp del /Q *.tmp

if "%found%"=="0" (
    echo No AIC Expander devices detected.
    echo.
    pause
    goto MENU
)

echo.
set /p FAN=Input Fan duty level (7=Max, 1=Min): 

echo.
echo === Setting Fan Duty for all detected AIC enclosures ===
for /F %%i in ('sg_scan -s ^| find "AIC"') do (
    set "device=%%i"
    set "exp=!device:~0,17!"
    echo ---------------------------------------------------
    
    :: Auto-detect descriptor (CoolingElement00 or SysCoolingElement00)
    set "desc=CoolingElement00"
    sg_ses -p ed !exp! | findstr /i "SysCoolingElement00" >nul
    if !errorlevel! equ 0 set "desc=SysCoolingElement00"
    echo Using descriptor: !desc!

    echo Setting fan duty to !FAN! for !exp!...
    sg_ses --descriptor=!desc! --set 3:2:3=!FAN! !exp!
)
echo.
echo Done setting all enclosures.
echo.
pause
goto MENU

:EXIT
echo.
echo Thank you for using! Exiting...
timeout /t 2 >nul
exit
