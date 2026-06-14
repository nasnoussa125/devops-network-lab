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
                echo 'Démarrage de la stack Docker Compose...'
                bat 'docker-compose up -d'
            }
        }
        stage('IVVQ Validation') {
            steps {
                echo 'Exécution des tests automatisés sur l\'hôte...'
                bat 'python -m robot verif_reseau.robot'
            }
        }
    }
}