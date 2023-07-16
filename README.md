Hello,

This is personal pet project with intention to get some hands-on experience of Jenkins, Terraform and AWS.

Jenkins Dockerfile is presented in this repo.

To make this pipeline work there are few points required:
- Terraform should be installed on Jenkins node
- Terraform plugin should be installed on Jenkins
- Docker Pipeline plugin should be installed on Jenkins
- Docker should be installed on Jenkins machine
- AWS IAM user with necessary permissions should exist
- AWS IAM user should have an access key and security key
- access and security keys should be added to Jenkins credentials as secret text with "aws-access-key" and "aws-secret-key" IDs
- repository should be added as a "pipeline script from SCM" with a link to Jenkinsfile in the root of repository