pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        DEBIAN_FRONTEND = 'noninteractive'
        GRAFANA_ADMIN_PASSWORD = credentials('grafana-admin-password')
    }

    stages {
        stage('Setup Tools') {
            steps {
                sh '''
                    apt-get update -qq
                    apt-get install -y -qq --no-install-recommends python3-pip
                    pip3 install --quiet --break-system-packages \
                        --root-user-action=ignore \
                        robotframework robotframework-requests
                '''
            }
        }

        stage('Deploy Stack') {
            steps {
                sh '''
                    docker compose down || true
                    docker compose up -d
                    sleep 30
                    docker compose ps
                '''
            }
        }

        stage('Verification') {
            steps {
                sh '''
                    mkdir -p results/verification
                    python3 -m robot --outputdir results/verification tests/verification.robot
                '''
            }
        }

        stage('Validation') {
            steps {
                sh '''
                    mkdir -p results/validation
                    python3 -m robot --outputdir results/validation tests/validation.robot
                '''
            }
        }
    }

    post {
        always {
            sh 'docker compose down || true'
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'results/verification',
                reportFiles: 'report.html',
                reportName: 'Verification Report'
            ])
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'results/validation',
                reportFiles: 'report.html',
                reportName: 'Validation Report'
            ])
        }
        success {
            echo 'Pipeline OK - stack up, tests IVVQ passed.'
        }
        failure {
            echo 'Pipeline Failed - see Robot Framework reports in artifacts.'
        }
    }
}