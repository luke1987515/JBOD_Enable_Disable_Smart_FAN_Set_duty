@echo off
::sg_scan -s to Show the device for AIC Expander Controller 

set /p SCSI=Input Expander Controller:

sg_ses --descriptor=CoolingElement00 --clear=1:7:1 %SCSI%

pause