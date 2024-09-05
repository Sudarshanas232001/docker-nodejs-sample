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
        stage('Upload to S3') {
            steps {
                script {
                    def s3Upload = sh(script: "aws s3 cp app.zip s3://${S3_BUCKET}/app.zip", returnStatus: true)
                    if (s3Upload != 0) {
                        error "Failed to upload to S3"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def deploy = sh(script: "aws deploy create-deployment --application-name ${APPLICATION_NAME} --deployment-group-name ${DEPLOYMENT_GROUP} --s3-location bucket=${S3_BUCKET},key=app.zip,bundleType=zip", returnStatus: true)
                    if (deploy != 0) {
                        error "Failed to create deployment"
                    }
                }
            }
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
