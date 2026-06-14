pipeline {
    agent {
        docker { 
            image 'python:3.11-slim'
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('Setup Tools') {
            steps {
                sh 'apt-get update && apt-get install -y docker.io'
                sh 'pip install robotframework robotframework-requests'
            }
        }

        stage('Deploy Stack') {
            steps {
                withCredentials([string(credentialsId: 'grafana-admin-password', variable: 'GRAFANA_PASS')]) {
                    sh 'docker compose up -d'
                    sh 'sleep 15'
                }
            }
        }

        stage('Tests') {
            steps {
                sh 'python3 -m robot --outputdir results tests/verification.robot tests/validation.robot'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
            sh 'docker compose down'
        }
    }
}