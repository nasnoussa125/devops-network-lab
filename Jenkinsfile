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
                    apt-get install -y -qq --no-install-recommends python3-pip docker-compose
                    pip3 install --quiet --break-system-packages \
                        --root-user-action=ignore \
                        robotframework robotframework-requests
                '''
            }
        }

        stage('Deploy Stack') {
            steps {
                sh '''
                    docker-compose down -v || true
                    docker container prune -f || true
                    docker-compose up -d
                    sleep 40
                    docker-compose ps
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
            sh 'docker-compose down || true'
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
        success {
            echo 'Build successful - all tests passed'
        }
        failure {
            echo 'Build failed - check Robot Framework reports'
        }
    }
}
