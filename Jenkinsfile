pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    environment {
        DEBIAN_FRONTEND = 'noninteractive'
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
                    GRAFANA_ADMIN_PASSWORD=admin docker-compose up -d
                    sleep 15
                '''
            }
        }

        stage('Verification') {
            steps {
                sh 'python3 -m robot --outputdir results/verification tests/verification.robot'
            }
        }

        stage('Validation') {
            steps {
                sh 'python3 -m robot --outputdir results/validation tests/validation.robot'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
            sh 'docker-compose down'
        }
        success {
            echo 'Pipeline OK - stack up, tests IVVQ passes.'
        }
        failure {
            echo 'Echec - voir les artefacts Robot Framework dans les logs.'
        }
    }
}