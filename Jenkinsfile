pipeline {
  agent any

  tools {
    maven 'Maven3'      // from Jenkins Tools config
  }

  environment {
    TOMCAT_HOST = 'tomcat:8080'   // Docker Compose service name + port
    MAVEN_OPTS = '-Xmx256m -Xms128m'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests clean package -T 1C'
      }
    }

    stage('Archive WAR') {
      steps {
        archiveArtifacts artifacts: 'target/*.war', fingerprint: true
      }
    }

    stage('Deploy to Tomcat') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'tomcat-creds', usernameVariable: 'TOMCAT_USER', passwordVariable: 'TOMCAT_PASS')]) {
          sh '''
            WAR_FILE=$(ls target/*.war | head -n1)
            APP_PATH=/myapp
            # Undeploy if exists to avoid 409 conflicts
            curl -sS -u "$TOMCAT_USER:$TOMCAT_PASS" "http://$TOMCAT_HOST/manager/text/undeploy?path=$APP_PATH" || true
            # Deploy/Update
            curl -sS -u "$TOMCAT_USER:$TOMCAT_PASS" --upload-file "$WAR_FILE" \
              "http://$TOMCAT_HOST/manager/text/deploy?path=$APP_PATH&update=true"
          '''
        }
      }
    }
  }

  post {
    always {
      junit testResults: '**/target/surefire-reports/*.xml', allowEmptyResults: true
    }
  }
}
