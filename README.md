Hello,

This is personal pet project with intention to get some hands-on experience of Jenkins, Terraform and AWS.
This project includes scripted Jenkins Pipeline with instructions to deploy ECS container and Lambda application in AWS.
If you want to use this exact repo please make sure that you have replaced python application woth yours and this application should return an answer with html formatting including status code, headers and body.

To make this pipeline work there are few points required:

- Terraform should be installed on Jenkins node
- Docker should be installed on Jenkins machine (or environment variable DOCKER_HOST should be set with Docker host address)
- AWS IAM user with necessary permissions should exist
- AWS IAM user should have an access key and security key
- access and security keys should be added to Jenkins credentials as secret text with "aws-access-key" and "aws-secret-key" IDs
- repository might be added as a "pipeline script from SCM" with a link to Jenkinsfile in the root of repository

Required Jenkins plugins:
- Terraform plugin
- Docker Pipeline plugin