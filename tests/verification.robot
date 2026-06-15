*** Settings ***
Documentation     Tests de VÉRIFICATION (EXG-01 à EXG-03)
...               Vérifie que chaque composant fonctionne individuellement.
...               Ces tests s'exécutent sur les conteneurs Docker locaux
...               (pas de dépendance à une IP externe).
Library           OperatingSystem
Library           RequestsLibrary

*** Variables ***
${PROMETHEUS_URL}     http://localhost:9090
${NODE_EXPORTER_URL}  http://localhost:9100

*** Test Cases ***

EXG-01 Prometheus Est Joignable
    [Documentation]    Prometheus doit répondre sur son endpoint de santé.
    [Tags]    EXG-01    verification
    Create Session    prom    ${PROMETHEUS_URL}    verify=False
    ${resp}=    GET On Session    prom    /-/healthy    expected_status=200
    Should Be Equal As Strings    ${resp.status_code}    200

EXG-02 Node Exporter Est Joignable
    [Documentation]    node-exporter doit exposer ses métriques sur /metrics.
    [Tags]    EXG-02    verification
    Create Session    ne    ${NODE_EXPORTER_URL}    verify=False
    ${resp}=    GET On Session    ne    /metrics    expected_status=200
    Should Contain    ${resp.text}    node_cpu_seconds_total

EXG-03 Prometheus Scrappe Node Exporter
    [Documentation]    Prometheus doit avoir détecté node-exporter comme cible active.
    [Tags]    EXG-03    verification
    Create Session    prom    ${PROMETHEUS_URL}    verify=False
    ${resp}=    GET On Session    prom    /api/v1/targets    expected_status=200
    Should Contain    ${resp.text}    node-exporter
