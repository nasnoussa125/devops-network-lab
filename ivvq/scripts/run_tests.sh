#!/bin/bash
#
# Recette technique - Stack "simulation d'entreprise"
# (infrastructure/docker : Nginx + PostgreSQL + Jenkins)
#
# Prérequis : la stack doit être démarrée au préalable :
#   cd infrastructure/docker && docker-compose up -d
#
# Ce script effectue des vérifications LIVE (services réellement
# joignables) et un audit STATIQUE du code source (pas de secret en dur).

echo "====================================================="
echo "EXECUTION DE LA RECETTE TECHNIQUE - STACK ENTREPRISE"
echo "====================================================="

SUCCESS_COUNT=0
FAILURE_COUNT=0

# Test 1 : Disponibilite du serveur Web (Nginx)
echo -n "[TEST-APP-01] Verification du serveur Web Nginx (http://localhost:8080)... "
if curl -s --connect-timeout 3 http://localhost:8080 > /dev/null; then
    echo "[OK]"
    ((SUCCESS_COUNT++))
else
    echo "[ECHEC]"
    ((FAILURE_COUNT++))
fi

# Test 2 : Disponibilite de la base de donnees PostgreSQL (port TCP ouvert)
echo -n "[TEST-DB-01] Verification du port PostgreSQL (5433)... "
if (exec 3<>/dev/tcp/127.0.0.1/5433) 2>/dev/null; then
    exec 3>&-
    echo "[OK]"
    ((SUCCESS_COUNT++))
else
    echo "[ECHEC]"
    ((FAILURE_COUNT++))
fi

# Test 3 : Audit de securite - le mot de passe DB doit etre externalise
#          (variable d'environnement), jamais en dur dans le compose.
echo -n "[TEST-SEC-01] Audit OPSEC - secret DB externalise via variable d'env... "
if grep -q '\${DB_PASSWORD}' infrastructure/docker/docker-compose.yml 2>/dev/null; then
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
