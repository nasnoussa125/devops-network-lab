pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                // Installe Python et Robot dans l'agent Jenkins à la volée
                sh 'pip install robotframework'
            }
        }
        stage('Lint & Check') {
            steps {
                echo 'Vérification de la syntaxe...'
            }
        }
        stage('Deploy Infrastructure') {
            steps {
                echo 'Démarrage de la stack Docker Compose...'
             
            }
        }
        stage('IVVQ Validation') {
            steps {
                echo 'Exécution des tests automatisés...'
                sh 'python -m robot verif_reseau.robot'
            }
        }
    }
} 
