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
        stage('terraform provider fix') {
            bat "terraform state replace-provider hashicorp/docker kreuzwerker/docker -no-color"
        }
        stage('test - terraform providers check') {
            bat "terraform providers -no-color"
        }
        stage('terraform configuration refresh') {
            bat "terraform init -no-color"
        }
        stage('test - terraform syntax check') {
            bat "terraform validate -no-color"
        }
        stage('test - terraform plan') {
            bat "terraform plan -no-color"
        }
    }
}