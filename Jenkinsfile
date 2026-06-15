// Pipeline IVVQ : déploie la stack de supervision (Prometheus / Grafana / node-exporter)
// puis exécute les suites de Vérification et de Validation (Robot Framework).
// Les résultats sont archivés comme preuve de Qualification (EXG-06).
pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        DEBIAN_FRONTEND = 'noninteractive'
        // GRAFANA_ADMIN_PASSWORD : si défini (ex. via Jenkins Credentials avec
        //   GRAFANA_ADMIN_PASSWORD = credentials('grafana-admin-password')),
        // docker-compose l'utilisera. Sinon, docker-compose.yml retombe sur la
        // valeur par défaut 'admin' (cf. GF_SECURITY_ADMIN_PASSWORD).
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
