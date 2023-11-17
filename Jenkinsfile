pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t renjubino/proj2-app .
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push renjubino/proj2-app
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
                docker run -d --name project2-app -p 80:8080 renjubino/proj2-app
                '''
            }
        }
    }
}
