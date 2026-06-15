*** Settings ***
Documentation     Tests de VALIDATION (EXG-04, EXG-05)
...               Vérifie que le système répond au besoin opérationnel global :
...               supervision accessible et panne détectable.
Library           RequestsLibrary

*** Variables ***
${GRAFANA_URL}        http://localhost:3000
${PROMETHEUS_URL}     http://localhost:9090

*** Test Cases ***

EXG-04 Grafana Est Accessible
    [Documentation]    Le dashboard de supervision doit être accessible.
    [Tags]    EXG-04    validation
    Create Session    grafana    ${GRAFANA_URL}    verify=False
    ${resp}=    GET On Session    grafana    /api/health    expected_status=200
    Should Contain    ${resp.text}    ok

EXG-05 Prometheus Expose Des Metriques CPU
    [Documentation]    Le système doit exposer des métriques temps réel (CPU).
    ...                Prouve que la chaîne de supervision est opérationnelle.
    [Tags]    EXG-05    validation
    Create Session    prom    ${PROMETHEUS_URL}    verify=False
    ${resp}=    GET On Session    prom    url=/api/v1/query?query=node_cpu_seconds_total    expected_status=200
    Should Contain    ${resp.text}    node_cpu_seconds_total