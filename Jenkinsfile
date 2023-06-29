node {
    withCredentials([string(credentialsId: 'aws-access-key', variable: 'ACCESSKEY'), string(credentialsId: 'aws-secret-key', variable: 'SECRETKEY')]) {
        stage('test - terraform check') {
            bat "terraform --version"
        }
        withEnv(['GITURL=scm.userRemoteConfigs[0].url', 'GITBRANCH=scm.branches[0].name']) {
            stage('clone repository') {
                git branch: '${env.BRANCH_NAME}', url: '${env.REPO_URL}'
            }
        }
        stage('terraform configuration refresh') {
            bat "terraform init"
        }
        stage('test - terraform plan') {
            bat "terraform plan -var=aws_access_key='$ACCESSKEY' -var=aws_secret_key='$SECRETKEY'"
        }
    }
}