pipeline {
    agent any
    environment{
        GCR_CREDENTIALS_ID = 'renju-gcrkey' // The ID you provided in Jenkins credentials
        IMAGE_NAME = 'renju-lbgpyapi'
        GCR_URL = 'eu.gcr.io/lbg-mea-15'
        PROJECT_ID = 'lbg-mea-15'
        CLUSTER_NAME = 'renju-cluster'
        LOCATION = 'europe-west2-c'
        CREDENTIALS_ID = '8eafd413-c9cb-40e4-bf33-8b11f2ac97c4'

    }
     stages {
        stage('Build and Push to GCR') {
            steps {
                script {
                    // Authenticate with Google Cloud
                    withCredentials([file(credentialsId: GCR_CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    }
                    // Configure Docker to use gcloud as a credential helper
                    sh 'gcloud auth configure-docker --quiet'
                    // Build the Docker image
                    sh "docker build -t ${GCR_URL}/${IMAGE_NAME}:v15 ."
                    // Push the Docker image to GCR
                    sh "docker push ${GCR_URL}/${IMAGE_NAME}:v15"
                }
            }
        }
    stage('Deploy to staging GKE') {
            steps {
                script {
                    // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'kubernetes/deployment.yaml', credentialsId: env.CREDENTIALS_ID, namespace:'staging', verifyDeployments: true])
                }
            }
        }
    stage('Quality Check') {
            steps {
                sh '''
                sleep 50
                gcloud config set account renju-jenkins@lbg-mea-15.iam.gserviceaccount.com
                export STAGING_IP=\$(kubectl get svc -o json --namespace staging | jq '.items[] | select(.metadata.name == "flask-service") | .status.loadBalancer.ingress[0].ip' | tr -d '"')
                pip3 install requirements.txt
                '''
            }
        }
    stage('Prod Deploy') {
            steps {
                script {
                    // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'kubernetes/deployment.yaml', credentialsId: env.CREDENTIALS_ID, namespace:'prod', verifyDeployments: true])
                }
            }
        }
    }
}