pipeline {
    agent any
    
    stages {
        // Étape 1: Vérification du code
        stage('Checkout') {
            steps {
                echo "1. Récupération du code depuis GitHub"
                git branch: 'main', 
                url: 'https://github.com/stanilpaul/docker-getting-started-devops-enhanced.git'
                
                sh 'ls -la'  // Vérifier les fichiers récupérés
            }
        }
        
        // Étape 2: Vérification Docker
        stage('Docker Check') {
            steps {
                echo "2. Vérification de l'environnement Docker"
                sh 'docker --version'
                sh 'docker-compose --version'
                sh 'docker images'
            }
        }
        
        // Étape 3: Test d'exécution
        stage('Dry Run') {
            steps {
                echo "3. Test d'exécution sans déploiement"
                sh 'docker-compose config'  // Valide la syntaxe
                sh 'docker-compose build'   // Test de construction
            }
        }
    }
    
    post {
        always {
            echo "Nettoyage temporaire"
            sh 'docker-compose down -v || true'  // Force le nettoyage même en cas d'erreur
        }
    }
}
