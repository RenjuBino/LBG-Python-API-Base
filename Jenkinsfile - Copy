pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t renjubino/proj2-app .
                docker build -t renjubino/proj2-nginx nginx
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push renjubino/proj2-app
                docker push renjubino/proj2-nginx
                '''
           }
        }
        stage('Deploy') {
            steps {
                sh '''
                ssh jenkins@renju-project2 << EOF
                docker stop project2-app && echo "project2-app is stopped" | echo "project2-app is not running"
                docker rm project2-app && echo "project2-app is removed" | echo "project2-app is not available"
                docker pull renjubino/proj2-app
                docker stop project2-nginx && echo "project2-nginx is stopped" | echo "project2-nginx is not running"
                docker rm project2-nginx && echo "project2-nginx is removed" | echo "project2-nginx is not available"
                docker pull renjubino/proj2-nginx
                docker network rm proj2-net && echo "project2-net is removed" | echo "project2-net is not available"
                docker network create proj2-net
                docker run -d --name project2-app --network proj2-net renjubino/proj2-app
                docker run -d --name project2-nginx --network proj2-net -p 80:80 renjubino/proj2-nginx
                '''
            }
        }
    }
}
