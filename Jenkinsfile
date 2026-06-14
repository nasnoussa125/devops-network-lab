pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                
                sh 'apt-get update && apt-get install -y python3-pip python3-venv'
                
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install robotframework'
            }
        }
        stage('Lint & Check') {
            steps {
                echo 'Vérification de la syntaxe...'
            }
        }
        stage('Deploy Infrastructure') {
            steps {
                echo 'Démarrage de la stack Docker Compose...'
            }
        }
        stage('IVVQ Validation') {
            steps {
                echo 'Exécution des tests automatisés...'
                
                sh './venv/bin/robot verif_reseau.robot'
            }
        }
    }
}