pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // Set your AWS region
        S3_BUCKET = 'my-node-appbucket' // Replace with your S3 bucket name
        CODEDEPLOY_APPLICATION_NAME = 'NodeJsApp' // Replace with your CodeDeploy application name
        CODEDEPLOY_DEPLOYMENT_GROUP_NAME = 'YourDeploymentGroup' // Replace with your CodeDeploy deployment group name
        DEPLOYMENT_PACKAGE = 'nodejs-app.zip'
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository
                git 'https://github.com/Sudarshanas232001/docker-nodejs-sample'
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

        stage('Package Application') {
            steps {
                script {
                    // Create a zip file of the application
                    sh "zip -r ${DEPLOYMENT_PACKAGE} . -x '*.git*' -x 'scripts/*'"
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    // Upload the zip file to S3
                    sh "aws s3 cp ${DEPLOYMENT_PACKAGE} s3://${S3_BUCKET}/${DEPLOYMENT_PACKAGE}"
                }
            }
        }

        stage('Deploy to CodeDeploy') {
            steps {
                script {
                    // Trigger a deployment with CodeDeploy
                    sh """
                    aws deploy create-deployment \
                        --application-name ${CODEDEPLOY_APPLICATION_NAME} \
                        --deployment-group-name ${CODEDEPLOY_DEPLOYMENT_GROUP_NAME} \
                        --s3-location bucket=${S3_BUCKET},key=${DEPLOYMENT_PACKAGE},bundleType=zip
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully'
        }
        failure {
            echo 'Deployment failed'
        }
    }
}
