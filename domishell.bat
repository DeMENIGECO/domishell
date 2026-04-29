@echo off
setlocal EnableDelayedExpansion

title DomiShell - Terminale Personalizzato
color 0A

:: Controllo privilegi amministratore
net session >nul 2>&1
if %errorlevel%==0 (
    set "isAdmin=true"
) else (
    set "isAdmin=false"
)

:menu
cls
echo =====================================
echo         DomiShell Terminale
echo =====================================
echo Versione 1.0.1
if "%isAdmin%"=="true" (
    echo Modalita': Amministratore
) else (
    echo Modalita': Utente base
)
echo.
echo Comandi disponibili:
echo - help        : Mostra i comandi
echo - exit        : Chiudi DomiShell
echo - dir         : Lista file cartella
echo - echo [txt]  : Stampa testo
echo - domipptp    : Avvia Domi PPTP
echo - domishell -studio    : Avvia la modalita' studio di DomiShell
if "%isAdmin%"=="true" (
    echo - admincmd   : Comando extra admin
    echo - reboot     : Riavvia PC
    echo - netstat    : Mostra connessioni
)
echo.
set /p "cmd=>> "

:: Gestione comandi
if "%cmd%"=="help" goto help
if "%cmd%"=="exit" goto end
if "%cmd%"=="dir" goto dir
if "%cmd:~0,4%"=="echo" goto echo
if "%cmd%"=="domipptp" goto domipptp
if "%cmd%"=="domishell -studio" goto domishell_studio_mode
if "%cmd%"=="admincmd" if "%isAdmin%"=="true" goto admincmd
if "%cmd%"=="reboot" if "%isAdmin%"=="true" goto reboot
if "%cmd%"=="netstat" if "%isAdmin%"=="true" goto netstat

echo Comando non riconosciuto.
pause
goto menu

:help
echo --- HELP ---
echo help, exit, dir, echo [txt], domipptp, domishell -studio
if "%isAdmin%"=="true" (
    echo admincmd, reboot, netstat
)
pause
goto menu

:dir
dir
pause
goto menu

:echo
set "text=%cmd:~5%"
echo %text%
pause
goto menu

:admincmd
echo Questo e' un comando riservato agli admin!
pause
goto menu

:reboot
shutdown /r /t 0
goto end

:netstat
netstat -an
pause
goto menu

:end
exit

:domipptp
echo avvio Domi PPTP...
timeout /t 2 /nobreak >nul

echo -----------------------------------------------------
echo                     DOMI PPTP
echo -----------------------------------------------------

echo Versione 1.0.1
powershell -command "Write-Host 'La macchina Win11/Microsoft puo'' subire danni se Domi PPTP non e'' usato con cautela' -ForegroundColor Cyan"

:: Richiesta input
set /p "choice=Vuoi continuare l'avvio di Domi PPTP? (S/N): "

if /I "%choice%"=="S" (
    echo                   avvio risorse...
    timeout /t 2 /nobreak >nul
    echo             avvio programma di lettura...
    timeout /t 2 /nobreak >nul
    echo            avvio programma di ricezione...
    timeout /t 2 /nobreak >nul
    powershell -command "Write-Host 'Domi PPTP e'' stato avviato con successo.' -ForegroundColor Green"
    set /p "let=Digita il nome, la directory o il programma datrattare in Domi PPTP: "

    if "!let!"=="" (
        echo ERRORE: input vuoto!
        pause
        goto menu
    )

    set "INPUT_RAW=!let!"

    mkdir !let!\.domipptp 2>nul
    powershell -command "$expanded = [Environment]::ExpandEnvironmentVariables($env:INPUT_RAW); $dest = Join-Path $expanded '.domipptp'; New-Item -ItemType Directory -Force -Path $dest | Out-Null; Expand-Archive -Path 'i4SHA\pptp_res.zip' -DestinationPath $dest -Force; Write-Host 'DEST = ' $dest"
    echo Trattato in Domi PPTP.
    pause
    goto menu
) else (
    powershell -command "Write-Host 'Avvio annullato dall''utente.' -ForegroundColor Red" 
    pause
    goto menu
)

:domishell_studio_mode
cls
echo =====================================
echo    DOMISHELL - MODALITA' STUDIO
echo =====================================
echo Qui puoi simulare un ambiente di studio.
echo.
echo Comandi disponibili in Studio:
echo - status  : Informazioni su DomiShell
echo - back    : Torna al menu principale
echo - test domipptp : Testa il PPTP
echo.
set /p "studioCmd=studio>> "

if /I "%studioCmd%"=="status" goto studiocmd_status
if /I "%studioCmd%"=="back" goto menu
if /I "%studioCmd%"=="test domipptp" goto test_pptp

echo Comando Studio non riconosciuto.
pause
goto domishell_studio_mode

:studiocmd_status
echo Ecco le informazioni su DomiShell:
echo Versione: 1.0.1
echo Autore: DomeniGeco
pause
goto domishell_studio_mode

:test_pptp
cls
echo =====================================
echo        TEST MODULO DOMI PPTP
echo =====================================

set "testdir=%LOCALAPPDATA%\dgeco_apps\domishell\studio\domipptp\test_env"
set "zipfile=i4SHA/studio_TESTCOM.zip"

echo Creazione cartella di test: %testdir%
mkdir "%testdir%" 2>nul

echo Inizializzando i componenti in %testdir%...
echo I componenti verranno estratti da %zipfile%.

rem --- Controllo ZIP ---
if not exist "%zipfile%" (
    echo ERRORE: Il file %zipfile% non esiste.
    echo Impossibile continuare il test.
    pause
    goto studio
)

rem --- Estrazione ZIP ---
echo Estrazione dei file...
powershell -command "Expand-Archive -Path '%zipfile%' -DestinationPath '%testdir%' -Force"

echo Test in corso...
ping localhost -n 2 >nul

echo Il test e' andato a buon fine.
pause
goto domishell_studio_mode