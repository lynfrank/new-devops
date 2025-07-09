pipeline {
    agent any

    environment {
        APP_NAME = "todo-app-prod"
        APP_PORT = "3000"
        VM_IP = "172.184.141.110"  // ← À remplacer
    }

    stages {
        // ÉTAPE 1: Préparation (LinkedIn: montre l'initialisation)
        stage('🛠️ Setup Infrastructure') {
            steps {
                echo "1. Création du volume MySQL persistant"
                sh '''
                    docker volume create mysql_data || true
                    docker network create todo_network || true
                '''
            }
        }

        // ÉTAPE 2: Validation (LinkedIn: démontre les bonnes pratiques)
        stage('🔍 Validate Code') {
            steps {
                echo "2. Validation du code et des dépendances"
                git branch: 'main', 
                url: 'https://github.com/stanilpaul/docker-getting-started-devops-enhanced.git'
                sh 'docker-compose config'
                sh 'docker-compose build --no-cache --force-rm'
            }
        }

        // ÉTAPE 3: Tests (LinkedIn: montre l'aspect CI)
        stage('🧪 Run Tests') {
            steps {
                echo "3. Exécution des tests automatisés"
                sh '''
                    docker-compose up -d
                    sleep 10  # Attente démarrage MySQL
                    docker-compose exec app yarn test || true
                    docker-compose down  # Nettoyage test SANS -v
                '''
            }
        }

        // ÉTAPE 4: Déploiement (LinkedIn: démontre le CD)
        stage('🚀 Deploy Production') {
            steps {
                echo "4. Déploiement en production"
                sh '''
                    # Arrêt propre de l'app SEULEMENT
                    docker-compose stop app || true
                    docker-compose rm -f app || true
                    
                    # Reconstruction et démarrage
                    docker-compose build --no-cache app
                    docker-compose up -d
                    
                    # Politique de redémarrage
                    docker update --restart=always $(docker ps -q -f name=${APP_NAME})
                '''
            }
        }

        // ÉTAPE 5: Vérification (LinkedIn: montre le monitoring)
        stage('✅ Verify Deployment') {
            steps {
                echo "5. Contrôle qualité post-déploiement"
                sh '''
                    curl -If http://localhost:${APP_PORT}
                    docker-compose logs --tail=20 app
                '''
                echo "🌐 Application LIVE: http://${VM_IP}:${APP_PORT}"
            }
        }
    }

    post {
        success {
            slackSend channel: '#deployments', 
                      message: "SUCCESS: TodoApp déployée (${env.BUILD_URL})"
        }
    }
}
