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
                dir('infrastructure/docker') {
                    withCredentials([string(credentialsId: 'grafana-admin-password', variable: 'GRAFANA_PASS')]) {
                        sh 'docker-compose up -d'
                        sh 'sleep 15'
                    }
                }
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
            dir('infrastructure/docker') {
                sh 'docker-compose down'
            }
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline OK - stack up, tests IVVQ passes.'
        }
        failure {
            echo 'Echec - voir les artefacts Robot Framework dans les logs.'
        }
    }
}