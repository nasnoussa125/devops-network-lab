pipeline {
    agent any
    stages {
        stage('Lint & Check') {
            steps {
                echo 'Vérification de la syntaxe...'
            }
        }
        stage('Deploy Infrastructure') {
            steps {
                echo 'Démarrage de la stack...'
                sh 'docker compose up -d'
            }
        }
        stage('IVVQ Validation') {
            steps {
                echo 'Exécution des tests...'
                sh 'python3 -m robot verif_reseau.robot'
            }
        }
    }
}