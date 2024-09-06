pipeline{
    agent any{
        tools{
            nodejs '20.7.0'
        }
        stages{
            stage('print versions'){
                steps{
                    sh 'npm version'
                }
            }
            stage('install'){
                steps{
                    sh 'npm install'
                }
            }
            stage('Install'){
                steps{
                    sh 'npm install'
                }
            }
            stage('Build'){
                steps{
                    sh 'npm run build'
                }
            }
            stage('zip Artifacts'){
                steps{
                    sh 'zip -r $GIT_COMMIT.zip dist/'
                }
            }
            stage('upload to s3'){
                steps{
                    sh 'aws s3 cp $GIT_COMMIT.zip s3://my-node-appbucket/'
                }
            }
        }
    }
}
