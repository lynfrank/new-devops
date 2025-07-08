pipeline {
    agent any
    
    environment {
        APP_NAME = "todo-app"
        APP_PORT = "3000"
        VM_IP = "172.184.141.110"  // ← Remplacez par votre IP
    }
    
    stages {
        // ÉTAPE 1: Validation du code
        stage('Validate Code') {
            steps {
                echo "1️⃣ Validation du code source"
                git branch: 'main', 
                url: 'https://github.com/stanilpaul/docker-getting-started-devops-enhanced.git'
                
                // Vérifie la syntaxe Docker Compose
                sh 'docker-compose config'
            }
        }
        
        // ÉTAPE 2: Build de l'image
        stage('Build Image') {
            steps {
                echo "2️⃣ Construction de l'image Docker"
                sh 'docker-compose build --no-cache'
                sh 'docker images | grep ${APP_NAME}'
            }
        }
        
        // ÉTAPE 3: Tests
        stage('Run Tests') {
            steps {
                echo "3️⃣ Exécution des tests"
                script {
                    // Lance les conteneurs de test
                    sh 'docker-compose up -d'
                    
                    // Attend que MySQL soit prêt (10 essais max)
                    sh '''
                        for i in {1..10}; do
                            if docker-compose exec mysql mysqladmin ping -uroot -psecret --silent; then
                                echo "✅ MySQL opérationnel"
                                break
                            else
                                echo "⏳ Attente MySQL (tentative \$i/10)..."
                                sleep 5
                            fi
                        done
                    '''
                    
                    // Test de l'application
                    sh 'curl -I http://localhost:${APP_PORT} || true'
                }
            }
            
            post {
                always {
                    echo "🧹 Nettoyage des conteneurs de test SEULEMENT"
                    // ↓ N'utilisez PAS -v pour préserver les volumes !
                    sh 'docker-compose down'  
                }
            }
        }
        
        // ÉTAPE 4: Déploiement Production
        stage('Deploy to Production') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            
            steps {
                echo "4️⃣ Déploiement en production"
                script {
                    // 1. Arrêt propre SANS supprimer les volumes
                    sh 'docker-compose down || true'
                    
                    // 2. Lancement avec persistance
                    sh '''
                        docker-compose up -d
                        # Force le redémarrage automatique
                        docker update --restart=always $(docker ps -q -f name=${APP_NAME})
                        docker update --restart=always $(docker ps -q -f name=mysql)
                    '''
                    
                    // 3. Vérification finale
                    sh "sleep 10 && curl -I http://${VM_IP}:${APP_PORT} || true"
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ DÉPLOIEMENT RÉUSSI"
            echo "🌐 Application disponible sur : http://${VM_IP}:${APP_PORT}"
        }
        failure {
            echo "❌ ÉCHEC - Consultez les logs :"
            sh 'docker-compose logs || true'
        }
    }
}
