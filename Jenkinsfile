pipeline {
  agent any
  parameters {
      string(defaultValue: "main", description: 'Which Git Branch to clone?', name: 'BRANCH')
  }
  stages {
    stage("Clone") {
      steps {
        withCredentials([usernamePassword(credentialsId: 'git-token-credentials', usernameVariable: 'git_username', passwordVariable: 'git_password')]) {
            sh '''
               rm -rf ${WORKSPACE}/nginx_docker
               git clone https://\${git_username}:\${git_password}@github.com/subinmt/nginx_docker.git --branch=$BRANCH
            '''
         }
      }
    }

    stage("Docker Build and Push") { 
      steps {         
        echo "Build Started.!"
        sh'''
          cd ${WORKSPACE}/nginx_docker
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 676744278546.dkr.ecr.us-east-1.amazonaws.com
          docker build -t 676744278546.dkr.ecr.us-east-1.amazonaws.com/nginx_docker:$BUILD_NUMBER .
          docker push 676744278546.dkr.ecr.us-east-1.amazonaws.com/nginx_docker:$BUILD_NUMBER
        '''
      }
    }

   // Stopping Docker containers for cleaner Docker run
   stage('Stop Previous Containers') {
     steps {
            sh 'docker ps -f name=nginx_docker -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fname=nginx_docker -q | xargs -r docker container rm'
           }
    }

   stage("Deploy") {
     steps {       
     echo "Deploy Started.!"
     sh 'docker run -d -p 80:80 --name nginx_docker 676744278546.dkr.ecr.us-east-1.amazonaws.com/nginx_docker:$BUILD_NUMBER'
   }
   }
  }
} 
