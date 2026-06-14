pipeline {
    agent any

    stages {
        stage('Deploy Infrastructure') {
            steps {
                echo 'Démarrage de la stack via le dossier docker...'
                dir('infrastructure/docker') {
                    sh 'docker compose up -d'
                }
            }
        }

        stage('IVVQ Validation') {
            steps {
                echo 'Exécution des tests Robot Framework...'
                sh 'python3 -m robot verif_reseau.robot'
            }
        }
    }
}