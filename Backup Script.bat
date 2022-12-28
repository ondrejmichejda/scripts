@echo off

echo **********************************************************
echo **********************************************************
echo 	Zalohovani PROFIT databaze.
echo 	Prosim, nevypinejte pocitac!
echo 	Program se automaticky zavre.
echo **********************************************************
echo **********************************************************

REM Main definitions
set "src=Z:\Profit"
set "dest=D:\Profit Zaloha"
set /A max=60

rem Datetime stamp creation
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

rem Create backup folder and copy actual data
set "backupdest=%dest%\backup_%fullstamp%"
rem mkdir %backupdest%
rem robocopy %src% %backupdest% /E

rem Compress the file
"C:\Program Files\7-Zip\7z.exe" a -tzip "%backupdest%.zip" %src%

rem Delete old backups
set "delMsg="
for /f "skip=%max% delims=" %%a in (
  'dir "%dest%" /t:c /o:-d /b' 
) do (
  if not defined delMsg (
    set delMsg=1
    echo More than %max% found - only the %max% most recent folders will be preserved.
  )
  del /q "%dest%\%%a"
)
