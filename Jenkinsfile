node {
    try{
        checkout scm
        env.GITURL = scm.userRemoteConfigs[0].url
        env.GITBRANCH = scm.branches[0].name
    }
    catch(err){
        throw err
        error "Colud not find any Git repository for the pipeline"
    }
    step('git_debug') {
        echo "git url: ${GITURL} | branch: ${GITBRANCH}"
    }
    withCredentials([string(credentialsId: 'aws-access-key', variable: 'ACCESSKEY'), string(credentialsId: 'aws-secret-key', variable: 'SECRETKEY')]) {
        stage('test - terraform check') {
            bat "terraform --version"
        }
        stage('clone repository') {
            git branch: "${GITBRANCH}", url: "${GITURL}"
        }
        stage('terraform configuration refresh') {
            bat "terraform init"
        }
        stage('test - terraform plan') {
            bat "terraform plan -var=aws_access_key='$ACCESSKEY' -var=aws_secret_key='$SECRETKEY'"
        }
    }
}