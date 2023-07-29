properties(
    [
        parameters([
                booleanParam(
                    name: 'DESTROY',
                    defaultValue: false,
                    description: 'true to destroy staged infrastructure'
                ),
        ])   
    ]
)  

node {
    stage('clonning repository') {
        checkout scm
        env.GITURL = scm.userRemoteConfigs[0].url
        env.GITBRANCH = (scm.branches[0].name).split("/")[1]
    }
    stage('test - destruction check') {
        if (params.DESTROY) {
            echo 'State infrastructure will be destroyed'
        } else {
            echo 'State infrastructure won\'t be destroyed'
        }
    }
    withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
        stage('test - terraform software check') {
            sh "terraform --version"
        }
        stage('terraform configuration refresh') {
            sh "terraform init -no-color"
        }
        stage('test - terraform providers check') {
            sh "terraform providers -no-color"
        }
        stage('test - terraform syntax check') {
            sh "terraform validate -no-color"
        }
//        stage('test - terraform plan') {
//            if (env.DOCKER_HOST) {
//                sh "terraform plan -no-color -var='docker_host=${DOCKER_HOST}'"
//            } else {
//                sh "terraform plan -no-color"
//            }
//        }
        stage('terraform apply') {
            if (env.DOCKER_HOST) {
                sh "terraform apply -auto-approve -no-color -var='docker_host=${DOCKER_HOST}'"
            } else {
                sh "terraform apply -auto-approve -no-color"
            }
        }
        if (params.DESTROY) {
            stage('terraform destroy') {
                sh "terraform destroy -auto-approve -no-color"
            }
        }
    }
}