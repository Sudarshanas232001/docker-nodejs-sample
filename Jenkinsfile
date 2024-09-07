pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        S3_BUCKET = 'my-node-appbucket'
        BUILD_DIR = 'build'
        DEPLOYMENT_PACKAGE = 'nodejs-app.zip'
        CODEDEPLOY_APPLICATION = 'NodejsApp'
        CODEDEPLOY_DEPLOYMENT_GROUP = 'my-deployment-group'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], 
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

        stage('Prepare Deployment Package') {
            steps {
                script {
                    // Ensure scripts are executable
                    sh 'chmod +x scripts/*.sh'

                    // Clean up and prepare build directory
                    sh "rm -rf ${BUILD_DIR}"
                    sh "mkdir -p ${BUILD_DIR}"

                    // Package application
                    sh "zip -r ${DEPLOYMENT_PACKAGE} . -x '*.git/*' -x 'node_modules/*' -x '${BUILD_DIR}/*'"
                    sh "mv ${DEPLOYMENT_PACKAGE} ${BUILD_DIR}/"
                }
            }
        }

        stage('Upload to S3') {
            steps {
                withAWS(region: AWS_REGION, credentials: 'cfbe332e-6e2d-4b2c-b788-d922b36c9852') {
                    script {
                        sh "aws s3 cp ${BUILD_DIR}/${DEPLOYMENT_PACKAGE} s3://${S3_BUCKET}/${DEPLOYMENT_PACKAGE}"
                    }
                }
            }
        }

        stage('Deploy to EC2 with CodeDeploy') {
            steps {
                withAWS(region: AWS_REGION, credentials: 'cfbe332e-6e2d-4b2c-b788-d922b36c9852') {
                    script {
                        try {
                            def deploymentId = sh(script: """
                                aws deploy create-deployment \
                                    --application-name ${CODEDEPLOY_APPLICATION} \
                                    --deployment-group-name ${CODEDEPLOY_DEPLOYMENT_GROUP} \
                                    --s3-location bucket=${S3_BUCKET},key=${DEPLOYMENT_PACKAGE},bundleType=zip \
                                    --deployment-config-name CodeDeployDefault.AllAtOnce \
                                    --description "Deployment triggered by Jenkins" \
                                    --query 'deploymentId' \
                                    --output text
                            """, returnStdout: true).trim()

                            echo "Deployment ID: ${deploymentId}"
                        } catch (Exception e) {
                            error "Deployment failed: ${e.message}"
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment completed successfully'
        }
        failure {
            echo 'Build or deployment failed'
        }
    }
}
