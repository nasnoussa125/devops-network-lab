#!/bin/bash

echo "====================================================="
echo "EXECUTION DE LA CHAINE DE TESTS AUTOMATISES IVVQ"
echo "====================================================="

export SUCCESS_COUNT=0
export FAILURE_COUNT=0

# Test 1: Verification de la connectivite avec le Switch Cisco Core
echo -n "[TEST-NET-01] Ping de la passerelle switch-core... "
ping -c 2 192.168.1.254 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[OK]"
    ((SUCCESS_COUNT++))
else
    echo "[ECHEC]"
    ((FAILURE_COUNT++))
fi

# Test 2: Verification de la disponibilite du serveur Web de Production
echo -n "[TEST-APP-01] Verification du port HTTP (80) sur srv-web-prod... "
curl -s --connect-timeout 3 http://192.168.20.10 > /dev/null
if [ $? -eq 0 ]; then
    echo "[OK]"
    ((SUCCESS_COUNT++))
else
    echo "[ECHEC]"
    ((FAILURE_COUNT++))
fi

# Test 3: Audit de securite - Verification de fuite de mot de passe en clair
echo -n "[TEST-SEC-01] Audit OPSEC sur fichier docker-compose... "
grep -q "POSTGRES_PASSWORD: SuperSecurePassword" infrastructure/docker/docker-compose.yml 2>/dev/null
if [ $? -eq 1 ]; then
    echo "[OK]"
    ((SUCCESS_COUNT++))
else
    echo "[ECHEC]"
    ((FAILURE_COUNT++))
fi

echo "====================================================="
echo "BILAN DE LA RECETTE TECHNIQUE :"
echo "Tests reussis : $SUCCESS_COUNT | Tests echoues : $FAILURE_COUNT"
echo "====================================================="

if [ $FAILURE_COUNT -gt 0 ]; then
    exit 1
else
    exit 0
fi