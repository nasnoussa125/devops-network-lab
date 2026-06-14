pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install --quiet robotframework robotframework-requests'
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
            node {
                archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
                sh 'docker compose down'
            }
        }
    }
}