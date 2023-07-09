node {
    stage('clonning repository') {
        checkout scm
        env.GITURL = scm.userRemoteConfigs[0].url
        env.GITBRANCH = (scm.branches[0].name).split("/")[1]
    }
    withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
        stage('test - terraform software check') {
            bat "terraform --version"
        }
        stage('terraform configuration refresh') {
            bat "terraform init"
        }
        stage('test - terraform syntax check') {
            bat "terraform validate"
        }
        stage('test - terraform plan') {
            bat "terraform plan"
        }
    }
}