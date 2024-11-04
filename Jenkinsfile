pipeline {
    agent any

    environment {
        REPO_URL = "https://github.com/Stone-15/devops-build.git"
        BRANCH_NAME = "dev"
        EC2_HOST = "ubuntu@43.204.236.72"
        SSH_CREDENTIALS = 'ssh-key'             // Jenkins credentials ID for the EC2 SSH key
        DOCKER_CREDENTIALS = 'dockerhub'     // Jenkins credentials ID for Docker Hub
        DOCKER_USERNAME = 'joshdoc' // Docker Hub username
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
                    // Setting Img accordingly
                    if (env.BRANCH_NAME == 'dev') {
                        env.IMAGE_NAME = "dev/web-app"
                    } else if (env.BRANCH_NAME == 'main') {
                        env.IMAGE_NAME = "prod/web-app"
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
                        sh """
                        ssh ${EC2_HOST} << EOF
                            # Pull the Docker image
                            docker pull ${DOCKER_USERNAME}/${IMAGE_NAME}

                            # Stop existing containers and start new ones with the pulled image
                            docker-compose down
                            docker-compose up -d
                        EOF
                        """
                    }
                }
            }
        }
    }

       
}
