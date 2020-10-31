pipeline {
  agent any
  stages {      
    stage('git pull') {
        steps {
            // Please enter your git repository
            git url: '<Git URL>', branch: 'main'
        }
    }
    stage('k8s deploy'){
        steps {
            kubernetesDeploy(kubeconfigId: 'kubeconfig',
                 configs: '*.yaml')
        }
    }    
  }
}