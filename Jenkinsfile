pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    environment {
        GRAFANA_ADMIN_PASSWORD = credentials('grafana-admin-password')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    pip install --quiet --break-system-packages \
                        robotframework \
                        robotframework-requests \
                        || pip install --quiet \
                        robotframework \
                        robotframework-requests
                '''
            }
        }

        stage('Lint') {
            steps {
                sh 'python3 -m robot --dryrun tests/verification.robot tests/validation.robot'
            }
        }

        stage('Deploy Stack') {
            steps {
                sh '''
                    docker compose up -d
                    sleep 15
                '''
            }
        }

        stage('Verification Tests') {
            
            steps {
                sh 'python3 -m robot --outputdir results/verification tests/verification.robot'
            }
        }

        stage('Validation Tests') {
            
            steps {
                sh 'python3 -m robot --outputdir results/validation tests/validation.robot'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline OK : stack up, tests IVVQ passés.'
        }
        failure {pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    environment {
        GRAFANA_ADMIN_PASSWORD = credentials('grafana-admin-password')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    pip install --quiet --break-system-packages \
                        robotframework \
                        robotframework-requests \
                        || pip install --quiet \
                        robotframework \
                        robotframework-requests
                '''
            }
        }

        stage('Lint') {
            steps {
                sh 'python3 -m robot --dryrun tests/verification.robot tests/validation.robot'
            }
        }

        stage('Deploy Stack') {
            steps {
                sh '''
                    docker compose up -d
                    sleep 15
                '''
            }
        }

        stage('Verification Tests') {
            steps {
                sh 'python3 -m robot --outputdir results/verification tests/verification.robot'
            }
        }

        stage('Validation Tests') {
            steps {
                sh 'python3 -m robot --outputdir results/validation tests/validation.robot'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline OK : stack up, tests IVVQ passés.'
        }
        failure {
            echo 'Échec : voir rapport Robot Framework dans les artefacts.'
        }
        cleanup {
            sh 'docker compose down'
        }
    }
}
            echo 'Échec : voir rapport Robot Framework dans les artefacts.'
        }
        cleanup {
            sh 'docker compose down'
        }
    }
}
