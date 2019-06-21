pipeline {
    agent any

    stages {

       stage('checkout') {
         steps {
            checkout scm
          }
        }

        stage('CI test') {
            steps {
                sh "test/test-terraform.sh"
            }
        }
    }
}
