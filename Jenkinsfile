pipeline {  
    agent any  

    environment {  
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub') // Replace with your Docker Hub creds ID  
        GITHUB_CREDENTIALS = credentials('github-id') // Replace with your GitHub creds ID  
    }  

    stages {  
        stage('Checkout') {  
            steps {  
                checkout scm  
            }  
        }  

        stage('Build Image') {  
            steps {  
                script {  
                    // Ensure build.sh does indeed build the Docker image and exposes the correct name.  
                    sh './build_new.sh'   
                    sh 'ls -l'
                }  
            }  
        }  

        stage('Build Image for Dev') {  
            when {  
                branch 'dev'  
            }  
            steps {  
                script {  
                    sh 'docker tag proj-image dev:latest' // Replace 'your-image' with the actual image name.  
                    withDockerRegistry([credentialsId: DOCKER_HUB_CREDENTIALS, url: 'https://index.docker.io/v1/']) {  
                        sh 'docker push joshdoc/dev:latest'  
                    }  
                }  
            }  
        }  

        stage('Build Image for Prod') {  
            when {  
                branch 'master'  
            }  
            steps {  
                script {  
                    sh 'docker tag proj-image prod:latest' // Ensure the same for the prod version.  
                    withDockerRegistry([credentialsId: DOCKER_HUB_CREDENTIALS, url: 'https://index.docker.io/v1/']) {  
                        sh 'docker push joshdoc/prod:latest'  
                    }  
                }  
            }  
        }  

        stage('Deploy') {  
            steps {  
                script {  
                    // Ensure deploy.sh is set up to handle deployment properly.  
                    sh './deploy.sh'  
                }  
            }  
        }  
    }  

    post {  
        success {  
            notify('Success')  
        }  
        failure {  
            notify('Failure')  
        }  
    }  
}  

void notify(String msg) {  
    // Custom notification function (could be an email or Slack notification)  
    echo msg  
}