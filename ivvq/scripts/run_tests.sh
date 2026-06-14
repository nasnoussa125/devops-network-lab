#!/bin/bash

echo "====================================================="
echo "EXÉCUTION DE LA CHAÎNE DE TESTS AUTOMATISÉS IVVQ"
echo "====================================================="

export SUCCESS_COUNT=0
export FAILURE_COUNT=0

# Test 1: Vérification de la connectivité avec le Switch Cisco Core
echo -n "[TEST-NET-01] Ping de la passerelle switch-core... "
ping -c 2 192.168.1.254 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "PASS"
    ((SUCCESS_COUNT++))
else
    echo "FAIL"
    ((FAILURE_COUNT++))
fi

# Test 2: Vérification de la disponibilité du serveur Web de Production
echo -n "[TEST-APP-01] Vérification du port HTTP (80) sur srv-web-prod... "
curl -s --connect-timeout 3 http://192.168.20.10 > /dev/null
if [ $? -eq 0 ]; then
    echo "PASS"
    ((SUCCESS_COUNT++))
else
    echo "FAIL"
    ((FAILURE_COUNT++))
fi

echo "====================================================="
echo "BILAN DE LA RECETTE TECHNIQUE :"
echo "Tests réussis : $SUCCESS_COUNT | Tests échoués : $FAILURE_COUNT"
echo "====================================================="

if [ $FAILURE_COUNT -gt 0 ]; then
    exit 1
else
    exit 0
fi
