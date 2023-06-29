node {
    withCredentials([string(credentialsId: '2d194efa-7550-4d01-8264-487205f7a095', variable: 'ACCESSKEY'), string(credentialsId: '438b1012-2fa6-4ca2-b7b5-db07a2de98e0', variable: 'SECRETKEY')]) {
        stage('test - terraform check') {
            bat "terraform --version"
        }
        stage('terraform configuration refresh') {
            bat "terraform init"
        }
        stage('test - terraform plan') {
            bat "terraform plan -var=aws_access_key='$ACCESSKEY' -var=aws_secret_key='$SECRETKEY'"
        }
    }
}