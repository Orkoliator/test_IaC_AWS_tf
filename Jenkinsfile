node {
    withCredentials([string(credentialsId: 'aws-access-key', variable: 'ACCESSKEY'), string(credentialsId: 'aws-secret-key', variable: 'SECRETKEY')]) {
        stage('test - terraform check') {
            bat "terraform --version"
        }
        stage('clone repository') {
            git branch: 'main', url: 'https://github.com/Orkoliator/test_IaC_AWS_tf.git'
        }
        stage('terraform configuration refresh') {
            bat "terraform init"
        }
        stage('test - terraform plan') {
            bat "terraform plan -var=aws_access_key='$ACCESSKEY' -var=aws_secret_key='$SECRETKEY'"
        }
    }
}