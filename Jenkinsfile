pipeline {
    agent any
    stages {
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
               
            }
        }
    }
} 
