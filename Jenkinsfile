pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from the repository
                git 'https://github.com/Sudarshanas232001/docker-nodejs-sample/mynodeapp.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                // Install Node.js dependencies
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                // Run tests
                sh 'npm test'
            }
        }

        stage('Build') {
            steps {
                // Perform build tasks if any, like transpiling code
                sh 'npm run build'
            }
        }

        stage('Package') {
            steps {
                // Package the application, if needed
                // For example, you might zip the build artifacts
                sh 'zip -r my-node-app.zip .'
            }
        }
    }

    post {
        always {
            // Clean up or notify upon completion
            sh 'rm -rf my-node-app.zip'
        }
    }
}
