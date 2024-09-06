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
                    sh 'npm run build'
                    sh "rm -rf ${BUILD_DIR}"
                    sh "mkdir -p ${BUILD_DIR}"
                    sh "zip -r ${DEPLOYMENT_PACKAGE} . -x '.git' -x 'node_modules/' -x '${BUILD_DIR}/'"
                    sh "mv ${DEPLOYMENT_PACKAGE} ${BUILD_DIR}/"
                }
            }
        }

        stage('Upload to S3') {
            steps {
                withAWS(region: AWS_REGION, credentials: 'aws-credentials-id') {
                    script {
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
