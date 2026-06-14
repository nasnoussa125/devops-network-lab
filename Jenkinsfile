pipeline {
    agent any
    stages {
        stage('Deploy Infrastructure') {
            steps {
                echo 'Démarrage de la stack Docker Compose...'
            }
        }
        stage('IVVQ Validation') {
            agent {
                docker { 
                    image 'python:3.11-slim' 
                    args '-v /var/run/docker.sock:/var/run/docker.sock' 
                }
            }
            steps {
                
                sh 'pip install robotframework'
                
                sh 'python -m robot verif_reseau.robot'
            }
        }
    }
}