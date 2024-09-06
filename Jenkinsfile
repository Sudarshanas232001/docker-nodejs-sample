pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        S3_BUCKET = 'my-node-appbucket'
        BUILD_DIR = 'build'
        DEPLOYMENT_PACKAGE = 'nodejs-app.zip'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Use the GitHub credentials for checkout
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], 
                              userRemoteConfigs: [[url: 'https://github.com/Sudarshanas232001/docker-nodejs-sample.git', 
                              credentialsId: 'github-access-token']]])
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install'
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    // Define the ZIP file name and build directory
                    def zipFileName = 'app.zip'
                    def buildDir = 'build'

                    // Remove any existing build directory and create a new one
                    sh "rm -rf ${buildDir}"
                    sh "mkdir -p ${buildDir}"

                    // Zip the application files excluding .git, node_modules, and the build directory
                    sh "zip -r ${zipFileName} . -x '*.git/*' -x 'node_modules/*' -x '${buildDir}/*'"

                    // Move the ZIP file to the build directory
                    sh "mv ${zipFileName} ${buildDir}/"
                }
            }
        }

        stage('Upload to S3') {
            steps {
                withAWS(region: AWS_REGION, credentials: 'cfbe332e-6e2d-4b2c-b788-d922b36c9852') {
                    script {
                            echo "AWS_REGION=${AWS_REGION}"
                            echo "BUILD_DIR=${BUILD_DIR}"
                            echo "DEPLOYMENT_PACKAGE=${DEPLOYMENT_PACKAGE}"
                            echo "S3_BUCKET=${S3_BUCKET}"
                        sh "aws s3 cp ${BUILD_DIR}/${DEPLOYMENT_PACKAGE} s3://${S3_BUCKET}/${DEPLOYMENT_PACKAGE}"
                    }
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
