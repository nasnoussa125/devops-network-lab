pipeline {
    agent {
        docker { 
            image 'python:3.11-slim' 
            
            args '-u root' 
        }
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'pip install robotframework'
            }
        }
        stage('IVVQ Validation') {
            steps {
                sh 'python -m robot verif_reseau.robot'
            }
        }
    }
}