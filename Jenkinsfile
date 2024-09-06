pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // Set your AWS region
        S3_BUCKET = 'my-node-appbucket' // Replace with your S3 bucket name
        BUILD_DIR = 'build' // Directory to hold build artifacts
        DEPLOYMENT_PACKAGE = 'nodejs-app.zip'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub
                git 'https://github.com/Sudarshanas232001/docker-nodejs-sample.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Install Node.js dependencies
                    sh 'npm install'
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    // Run the build script (if any)
                    // Assuming your build command is 'npm run build'
                    sh 'npm run build'
                    
                    // Create the build directory
                    sh "mkdir -p ${BUILD_DIR}"
                    
                    // Package the application into a zip file
                    sh "zip -r ${DEPLOYMENT_PACKAGE} . -x '*.git*' -x 'node_modules/*' -x '${BUILD_DIR}/*'"
                    
                    // Move the zip file to the build directory
                    sh "mv ${DEPLOYMENT_PACKAGE} ${BUILD_DIR}/"
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    // Upload the zip file to S3
                    sh "aws s3 cp ${BUILD_DIR}/${DEPLOYMENT_PACKAGE} s3://${S3_BUCKET}/${DEPLOYMENT_PACKAGE}"
                }
            }
        }
    }

    post {
        success {
            echo 'Build and upload completed successfully'
        }
        failure {
            echo 'Build or upload failed'
        }
    }
}
