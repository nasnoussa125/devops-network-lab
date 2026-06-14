pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {

        stage('Setup Tools') {
            steps {
                sh '''
                    pip install --quiet --break-system-packages \
                        robotframework \
                        robotframework-requests \
                    2>/dev/null || pip install --quiet \
                        robotframework \
                        robotframework-requests
                '''
            }
        }

        stage('Deploy Stack') {
            steps {
                withCredentials([string(credentialsId: 'grafana-admin-password', variable: 'GRAFANA_PASS')]) {
                    sh 'GRAFANA_ADMIN_PASSWORD=$GRAFANA_PASS docker compose up -d'
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