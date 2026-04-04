*** Settings ***
Library  OperatingSystem

*** Test Cases ***
Tester La Connexion Au Serveur
    [Documentation]    Vérifie si le serveur .10 répond au ping
    ${result}=   Run    ping -c 2 192.168.1.10
    Should Contain    ${result}    64 bytes    from
