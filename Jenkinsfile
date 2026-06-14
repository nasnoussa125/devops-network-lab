pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                // On installe tout en une seule ligne avec root, 
                // Jenkins est configuré par défaut pour permettre cela dans les conteneurs
                sh '''
                    apt-get update
                    apt-get install -y python3 python3-pip
                    python3 -m pip install robotframework --break-system-packages
                '''
            }
        }
        stage('IVVQ Validation') {
            steps {
                sh 'python3 -m robot verif_reseau.robot'
            }
        }
    }
}