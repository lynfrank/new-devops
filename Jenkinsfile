pipeline {
    agent any
    
    environment {
        APP_NAME = "todo-app"
        APP_PORT = "3000"
        VM_IP = "172.184.141.110"  // ← Remplacez par votre IP
    }
    
    stages {
        // ÉTAPE 1: Récupération du code
        stage('Checkout') {
            steps {
                echo "1️⃣ Récupération du code"
                git branch: 'main', 
                url: 'https://github.com/stanilpaul/docker-getting-started-devops-enhanced.git'
            }
        }
        
        // ÉTAPE 2: Arrêt des conteneurs existants
        stage('Stop Existing') {
            steps {
                echo "2️⃣ Arrêt des conteneurs actuels"
                // Stop SANS supprimer les volumes !
                sh 'docker-compose down || true'
            }
        }
        
        // ÉTAPE 3: Reconstruction de l'image
        stage('Rebuild') {
            steps {
                echo "3️⃣ Reconstruction de l'image"
                // Force le rebuild et écrase l'ancienne image
                sh '''
                    docker-compose build --no-cache --force-rm
                    docker tag ${APP_NAME}:latest ${APP_NAME}:previous || true
                    docker rmi ${APP_NAME}:latest || true
                '''
            }
        }
        
        // ÉTAPE 4: Redémarrage
        stage('Restart') {
            steps {
                echo "4️⃣ Redémarrage de l'application"
                sh 'docker-compose up -d'
                
                // Vérification
                sh '''
                    sleep 5  # Attente démarrage
                    docker ps
                    curl -I http://localhost:${APP_PORT} || true
                '''
            }
        }
    }
    
    post {
        success {
            echo "✅ SUCCÈS : Application disponible sur http://${VM_IP}:${APP_PORT}"
        }
        failure {
            echo "❌ ÉCHEC : Consultez les logs avec 'docker-compose logs'"
        }
    }
}
