pipeline {
    agent any

    environment {
        APP_NAME = "todo-app-prod"
        APP_PORT = "3000"
        VM_IP = "172.184.141.110"  // ← Remplacez par votre IP
    }

    stages {
        // ÉTAPE 1: Préparation de l'infrastructure
        stage('🛠️ Setup Infrastructure') {
            steps {
                echo "1. Création des ressources Docker"
                sh '''
                    docker volume create mysql_data || true
                    docker network create todo_network || true
                    docker-compose down || true
                '''
            }
        }

        // ÉTAPE 2: Build de l'image
        stage('🔨 Build Image') {
            steps {
                echo "2. Construction de l'image Docker"
                sh '''
                    docker-compose build --no-cache --force-rm
                    docker images | grep ${APP_NAME}
                '''
            }
        }

        // ÉTAPE 3: Déploiement
        stage('🚀 Deploy') {
            steps {
                echo "3. Lancement des conteneurs"
                sh '''
                    docker-compose up -d
                    sleep 10  # Attente démarrage
                    docker-compose ps
                '''
            }
        }

        // ÉTAPE 4: Vérification
        stage('✅ Verify') {
            steps {
                echo "4. Contrôle de l'application"
                sh '''
                    curl -I http://localhost:${APP_PORT} || true
                    docker-compose logs --tail=20
                '''
                echo "🌐 Application disponible: http://${VM_IP}:${APP_PORT}"
            }
        }
    }

    post {
        failure {
            echo "❌ Échec du déploiement - Logs:"
            sh 'docker-compose logs || true'
        }
        success {
            echo "✅ Succès - Application en production!"
        }
    }
}
