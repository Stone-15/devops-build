pipeline {  
    agent any  

    environment {  
        REPO_URL = "https://github.com/Stone-15/devops-build.git"  
        BRANCH_NAME = "dev"  
        EC2_HOST = "ubuntu@13.201.230.133"  
        SSH_CREDENTIALS = 'ssh-key'             // Jenkins credentials ID for the EC2 SSH key  
        DOCKER_CREDENTIALS = 'dockerhub'       // Jenkins credentials ID for Docker Hub  
        DOCKER_USERNAME = 'joshdoc'             // Docker Hub username  
    }  

    stages {  
        stage('Clone Repository') {  
            steps {  
                git url: "${REPO_URL}", branch: "${BRANCH_NAME}"  
            }  
        }  

        stage('Determine Image Tag') {  
            steps {  
                script {  
                    // Setting Image name accordingly  
                    if (env.BRANCH_NAME == 'dev') {  
                        env.IMAGE_NAME = "dev"  
                    } else if (env.BRANCH_NAME == 'main') {  
                        env.IMAGE_NAME = "prod"  
                    } else {  
                        error("Branch not supported for deployment")  
                    }  
                    echo "Building Docker image as ${IMAGE_NAME}"  
                }  
            }  
        }  

        stage('Build Docker Image') {  
            steps {  
                script {  
                    sh "docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME} ."  
                }  
            }  
        }  

        stage('Push Docker Image to Docker Hub') {  
            steps {  
                script {  
                    docker.withRegistry('', "${DOCKER_CREDENTIALS}") {  
                        sh "docker push ${DOCKER_USERNAME}/${IMAGE_NAME}"  
                    }  
                }  
            }  
        }  

        stage('Deploy on EC2') {  
            steps {  
                script {  
                    sshagent([SSH_CREDENTIALS]) {  
                        // Define the command to be executed on the EC2 instance  
                        def command = """  
                        #!/bin/bash  
                        set -e  # Exit immediately on error  

                        echo 'Pulling Docker image...'  
                        docker pull ${DOCKER_USERNAME}/${IMAGE_NAME}  

                        echo 'Running Docker container...'  
                        docker run -d -p 80:80 ${DOCKER_USERNAME}/${IMAGE_NAME}  

                        echo 'Deployment completed successfully!'  
                        """  

                        // Execute the command on the remote EC2 instance  
                        sh "ssh -o StrictHostKeyChecking=no -t ${EC2_HOST} '${command}'"  
                    }  
                }  
            }  
        }  
    }  
}
