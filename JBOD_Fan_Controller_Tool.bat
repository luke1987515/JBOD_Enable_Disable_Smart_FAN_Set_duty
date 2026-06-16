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
    set "device=%%i"
    set "exp=!device:~0,17!"
    echo ---------------------------------------------------
    echo Enclosure: "!exp!"
    
    set "applied=0"

    :: 1. 檢查並設定 CoolingElement00
    sg_ses -p ed !exp! 2>nul | findstr /R /C:"Element 0 descriptor: CoolingElement00" >nul
    if !errorlevel! equ 0 (
        sg_ses --descriptor=CoolingElement00 --clear=1:7:1 !exp! >nul 2>&1
        sg_ses --descriptor=CoolingElement00 --get=1:7:1 !exp! > info_A.tmp 2>nul
        for /f %%a in (info_A.tmp) do (
            if "%%a"=="0" echo CoolingElement00    : [Enable Smart Fan] -^> Success
            if "%%a"=="1" echo CoolingElement00    : [Enable Smart Fan] -^> FAILED
        )
        set "applied=1"
    ) else (
        echo CoolingElement00    : [Not Supported]
    )

    :: 2. 檢查並設定 SysCoolingElement00
    sg_ses -p ed !exp! 2>nul | findstr /R /C:"SysCoolingElement00" >nul
    if !errorlevel! equ 0 (
        sg_ses --descriptor=SysCoolingElement00 --clear=1:7:1 !exp! >nul 2>&1
        sg_ses --descriptor=SysCoolingElement00 --get=1:7:1 !exp! > info_A.tmp 2>nul
        for /f %%a in (info_A.tmp) do (
            if "%%a"=="0" echo SysCoolingElement00 : [Enable Smart Fan] -^> Success
            if "%%a"=="1" echo SysCoolingElement00 : [Enable Smart Fan] -^> FAILED
        )
        set "applied=1"
    ) else (
        echo SysCoolingElement00 : [Not Supported]
    )

    :: 3. 檢查並設定 HubCoolingElement00
    sg_ses -p ed !exp! 2>nul | findstr /R /C:"HubCoolingElement00" >nul
    if !errorlevel! equ 0 (
        sg_ses --descriptor=HubCoolingElement00 --clear=1:7:1 !exp! >nul 2>&1
        sg_ses --descriptor=HubCoolingElement00 --get=1:7:1 !exp! > info_A.tmp 2>nul
        for /f %%a in (info_A.tmp) do (
            if "%%a"=="0" echo HubCoolingElement00 : [Enable Smart Fan] -^> Success
            if "%%a"=="1" echo HubCoolingElement00 : [Enable Smart Fan] -^> FAILED
        )
        set "applied=1"
    ) else (
        echo HubCoolingElement00 : [Not Supported]
    )

    if "!applied!"=="0" echo [Warning] No matching fan descriptors found on !exp!.
)
if "%found%"=="0" echo No AIC Expander devices detected.
if exist *.tmp del /Q *.tmp
echo.
pause
goto MENU

:AUTO_DISABLE_AND_SET
echo.
set "found=0"
:: 先行檢查是否有設備，避免輸入了轉速才發現沒設備
for /F %%i in ('sg_scan -s ^| find "AIC"') do ( set "found=1" )

if "%found%"=="0" (
    echo No AIC Expander devices detected.
    echo.
    pause
    goto MENU
)

set /p FAN=Input Fan duty level (7=Max, 1=Min): 
echo.
echo === Disabling Smart Fan and Setting Duty ===

for /F %%i in ('sg_scan -s ^| find "AIC"') do (
    set "device=%%i"
    set "exp=!device:~0,17!"
    echo ---------------------------------------------------
    echo Enclosure: "!exp!"
    
    :: 1. 檢查、停用並設定 CoolingElement00
    sg_ses -p ed !exp! 2>nul | findstr /R /C:"Element 0 descriptor: CoolingElement00" >nul
    if !errorlevel! equ 0 (
        sg_ses --descriptor=CoolingElement00 --set=1:7:1 !exp! >nul 2>&1
        sg_ses --descriptor=CoolingElement00 --set 3:2:3=!FAN! !exp! >nul 2>&1
        
        sg_ses --descriptor=CoolingElement00 --get=1:7:1 !exp! > info_A.tmp 2>nul
        for /f %%a in (info_A.tmp) do (
            if "%%a"=="0" echo CoolingElement00    : [Disable Smart Fan] -^> FAILED
            if "%%a"=="1" echo CoolingElement00    : [Disable Smart Fan] -^> Success
        )
    ) else (
        echo CoolingElement00    : [Not Supported]
    )

    :: 2. 檢查、停用並設定 SysCoolingElement00
    sg_ses -p ed !exp! 2>nul | findstr /R /C:"SysCoolingElement00" >nul
    if !errorlevel! equ 0 (
        sg_ses --descriptor=SysCoolingElement00 --set=1:7:1 !exp! >nul 2>&1
        sg_ses --descriptor=SysCoolingElement00 --set 3:2:3=!FAN! !exp! >nul 2>&1
        
        sg_ses --descriptor=SysCoolingElement00 --get=1:7:1 !exp! > info_A.tmp 2>nul
        for /f %%a in (info_A.tmp) do (
            if "%%a"=="0" echo SysCoolingElement00 : [Disable Smart Fan] -^> FAILED
            if "%%a"=="1" echo SysCoolingElement00 : [Disable Smart Fan] -^> Success
        )
    ) else (
        echo SysCoolingElement00 : [Not Supported]
    )

    :: 3. 檢查、停用並設定 HubCoolingElement00
    sg_ses -p ed !exp! 2>nul | findstr /R /C:"HubCoolingElement00" >nul
    if !errorlevel! equ 0 (
        sg_ses --descriptor=HubCoolingElement00 --set=1:7:1 !exp! >nul 2>&1
        sg_ses --descriptor=HubCoolingElement00 --set 3:2:3=!FAN! !exp! >nul 2>&1
        
        sg_ses --descriptor=HubCoolingElement00 --get=1:7:1 !exp! > info_A.tmp 2>nul
        for /f %%a in (info_A.tmp) do (
            if "%%a"=="0" echo HubCoolingElement00 : [Disable Smart Fan] -^> FAILED
            if "%%a"=="1" echo HubCoolingElement00 : [Disable Smart Fan] -^> Success
        )
    ) else (
        echo HubCoolingElement00 : [Not Supported]
    )
)
if exist *.tmp del /Q *.tmp
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