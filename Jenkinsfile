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
                    # Détecter le gestionnaire de paquets disponible
                    if command -v pip3 > /dev/null 2>&1; then
                        PIP=pip3
                    elif command -v pip > /dev/null 2>&1; then
                        PIP=pip
                    elif command -v python3 > /dev/null 2>&1; then
                        python3 -m ensurepip --upgrade 2>/dev/null || true
                        PIP="python3 -m pip"
                    else
                        echo "Python non disponible, installation..."
                        apt-get update -qq && apt-get install -y -qq python3 python3-pip
                        PIP=pip3
                    fi

                    echo "Utilisation de : $PIP"
                    $PIP install --quiet --break-system-packages \
                        robotframework robotframework-requests 2>/dev/null \
                    || $PIP install --quiet \
                        robotframework robotframework-requests
                '''
            }
        }

        stage('Deploy Stack') {
            steps {
                withCredentials([string(credentialsId: 'grafana-admin-password', variable: 'GRAFANA_PASS')]) {
                    sh '''
                        export GRAFANA_ADMIN_PASSWORD=$GRAFANA_PASS

                        # Supporter docker compose (v2) ET docker-compose (v1)
                        if docker compose version > /dev/null 2>&1; then
                            COMPOSE="docker compose"
                        else
                            COMPOSE="docker-compose"
                        fi

                        echo "Compose disponible : $COMPOSE"
                        $COMPOSE up -d
                        sleep 15
                    '''
                }
            }
        }

        stage('Tests') {
            steps {
                sh '''
                    if command -v python3 > /dev/null 2>&1; then
                        python3 -m robot --outputdir results \
                            tests/verification.robot tests/validation.robot
                    else
                        robot --outputdir results \
                            tests/verification.robot tests/validation.robot
                    fi
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
            sh '''
                if docker compose version > /dev/null 2>&1; then
                    docker compose down
                else
                    docker-compose down
                fi
            '''
        }
        success {
            echo '✅ Pipeline OK : stack up, tests IVVQ passés.'
        }
        failure {
            echo '❌ Échec : voir les artefacts Robot Framework.'
        }
    }
}
