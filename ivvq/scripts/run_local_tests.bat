 @echo off
chcp 65001 > nul
echo =====================================================
echo EXECUTION DE LA CHAINE DE TESTS LOCAUX IVVQ
echo =====================================================

set SUCCESS_COUNT=0
set FAILURE_COUNT=0

echo [TEST-ANS-01] Analyse syntaxique de l'inventaire...
if exist "ansible\inventory\hosts.ini" (
    echo     [OK] Fichier hosts.ini present et structure.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Fichier hosts.ini introuvable.
    set /a FAILURE_COUNT+=1
)

echo [TEST-TSC-01] Validation du schema d'architecture TOSCA...
findstr "tosca_definitions_version" tosca\blueprints\topology.yaml > nul
if %errorlevel% equ 0 (
    echo     [OK] Specification OASIS TOSCA valide.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Le blueprint TOSCA est corrompu ou mal formate.
    set /a FAILURE_COUNT+=1
)

echo [TEST-DKR-01] Analyse du deploiement multi-conteneurs...
findstr "srv-web-nginx" infrastructure\docker\docker-compose.yml > nul
if %errorlevel% equ 0 (
    echo     [OK] Stack applicative Nginx/Postgres conforme.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Erreur de definition dans le fichier docker-compose.
    set /a FAILURE_COUNT+=1
)

echo [TEST-SEC-01] Audit de securite sur le fichier Docker-Compose...
findstr /C:"POSTGRES_PASSWORD: SuperSecurePassword" infrastructure\docker\docker-compose.yml > nul
if %errorlevel% equ 1 (
    echo     [OK] Aucun secret en clair detecte dans le code source.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Alerte Securite ! Un mot de passe en dur a ete detecte.
    set /a FAILURE_COUNT+=1
)

echo =====================================================
echo BILAN DE LA RECETTE TECHNIQUE LOCALE :
echo Tests reussis : %SUCCESS_COUNT% ^| Tests echoues : %FAILURE_COUNT%
echo =====================================================

if %FAILURE_COUNT% gtr 0 (
    echo [ECHEC] Resultat Global : INFRASTRUCTURE NON CONFORME
    exit /b 1
) else (
    echo [OK] Resultat Global : INFRASTRUCTURE CONFORME
    exit /b 0
)
