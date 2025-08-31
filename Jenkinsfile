pipeline {
  agent any

  tools {
    maven 'Maven3'      // from Jenkins Tools config
  }

  environment {
    TOMCAT_HOST = 'tomcat-local:8080'   // Docker Compose service name + port
    MAVEN_OPTS = '-Xmx512m -Xms256m'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests clean package -T 1C -Dmaven.repo.local=/var/jenkins_home/.m2/repository'
      }
    }

    stage('Archive WAR') {
      steps {
        archiveArtifacts artifacts: 'target/*.war', fingerprint: true
      }
    }

    stage('Deploy to Tomcat') {
      steps {
        sh '''
          WAR_FILE=$(ls target/*.war | head -n1)
          echo "Deploying $WAR_FILE to Tomcat..."
          cp "$WAR_FILE" /shared/webapps/myapp.war
          echo "Deployment complete!"
        '''
      }
    }
  }

  post {
    always {
      junit testResults: '**/target/surefire-reports/*.xml', allowEmptyResults: true
    }
  }
}
