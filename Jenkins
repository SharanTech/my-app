pipeline{
    agent any
    tools {
          maven 'maven3'
        }
    environment {
          Docker_Tag = getVersion()
        }

    stages{
        stage("SCM"){
            steps{
                git credentialsId: 'Git', url: 'https://github.com/SharanTech/my-app'
            }
        }
        stage("Compile"){
            steps{
                sh "mvn clean package"
                sh "mv target/myweb*.war target/newdock.war"
            }
        }
        stage("docker build"){
            steps{
                sh "docker build . -t sharan95/newdock:${Docker_Tag}"
            }
        }
        stage("Docker push"){
            steps{
                withCredentials([string(credentialsId: 'dockerPass', variable: 'DockerPassword')]) {
                sh "docker login -u sharan95 -p ${DockerPassword}"
        }
                sh "docker push sharan95/newdock:${Docker_Tag}"
            }
        }
        stage("Docker deploy"){
            steps{
                ansiblePlaybook become: true, credentialsId: 'Test', disableHostKeyChecking: true, extras: "-e Docker_Tag=${Docker_Tag}", installation: 'ansible', inventory: 'dev.inv', playbook: 'DeployDocker.yml', 
                vaultCredentialsId: 'dockerPass'
            }
        }
    }
    post{
      always {
       emailext attachLog: true, body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:

        Check console output at $BUILD_URL to view the results.''', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'sharankumar.sk21@gmail.com'
      }
    }  
}
def getVersion(){
        def CommitVer = sh returnStatus: true, script: 'git rev-parse --short HEAD'
        return CommitVer
    }
