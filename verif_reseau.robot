*** Settings ***
Library    OperatingSystem

*** Test Cases ***
Tester La Connexion Au Serveur
    [Documentation]    Vérifie si le serveur .10 répond au ping
    ${result}=    Run    ping -n 2 192.168.1.10
    Should Contain    ${result}    octets