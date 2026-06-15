@echo off
chcp 65001 > nul
REM =====================================================
REM Recette technique - audit statique du depot (Windows)
REM A executer depuis la racine du projet.
REM =====================================================

echo =====================================================
echo EXECUTION DE LA RECETTE TECHNIQUE - AUDIT STATIQUE
echo =====================================================

set SUCCESS_COUNT=0
set FAILURE_COUNT=0

echo [TEST-ANS-01] Presence de l'inventaire Ansible...
if exist "ansible\inventory.ini" (
    echo     [OK] Fichier ansible\inventory.ini present.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Fichier ansible\inventory.ini introuvable.
    set /a FAILURE_COUNT+=1
)

echo [TEST-TSC-01] Validation du blueprint TOSCA (topologie reseau)...
findstr "tosca_definitions_version" tosca\blueprints\topology.yaml > nul
if %errorlevel% equ 0 (
    echo     [OK] Specification OASIS TOSCA presente.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Le blueprint TOSCA est corrompu ou mal formate.
    set /a FAILURE_COUNT+=1
)

echo [TEST-DKR-01] Verification de la stack applicative (Nginx)...
findstr "srv-web-nginx" infrastructure\docker\docker-compose.yml > nul
if %errorlevel% equ 0 (
    echo     [OK] Service Nginx defini dans la stack entreprise.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Service Nginx absent du docker-compose.
    set /a FAILURE_COUNT+=1
)

echo [TEST-SEC-01] Audit de securite - secret DB externalise...
findstr /C:"${DB_PASSWORD}" infrastructure\docker\docker-compose.yml > nul
if %errorlevel% equ 0 (
    echo     [OK] Mot de passe DB injecte via variable d'environnement.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] Alerte Securite ! Secret potentiellement en dur.
    set /a FAILURE_COUNT+=1
)

echo [TEST-TF-01] Verification du provisioning Terraform...
findstr "provider" infrastructure\terraform\main.tf > nul
if %errorlevel% equ 0 (
    echo     [OK] Provider Terraform declare.
    set /a SUCCESS_COUNT+=1
) else (
    echo     [ECHEC] infrastructure\terraform\main.tf vide ou incomplet.
    set /a FAILURE_COUNT+=1
)

echo =====================================================
echo BILAN DE LA RECETTE TECHNIQUE LOCALE :
echo Tests reussis : %SUCCESS_COUNT% ^| Tests echoues : %FAILURE_COUNT%
echo =====================================================

if %FAILURE_COUNT% gtr 0 (
    echo [ECHEC] Resultat Global : DEPOT NON CONFORME
    exit /b 1
) else (
    echo [OK] Resultat Global : DEPOT CONFORME
    exit /b 0
)
