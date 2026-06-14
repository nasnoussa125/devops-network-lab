pipeline {
    agent any

    stages {
        stage('Install Dependencies') {
            steps {
                
                sh 'python3 -m pip install --user robotframework robotframework-requests'
            }
        }

        stage('Deploy Stack') {
            steps {
                withCredentials([string(credentialsId: 'grafana-admin-password', variable: 'GRAFANA_PASS')]) {
                   
                    sh 'docker-compose up -d'
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
            script {
                archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
                sh 'docker-compose down'
            }
        }
    }
}