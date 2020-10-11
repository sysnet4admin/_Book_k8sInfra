podTemplate(
  serviceAccount: 'jenkins',
  containers: [
    containerTemplate(
      name: 'maven',
      image: 'maven:3-jdk-8',
      resourceLimitMemory: '300Mi',
      ttyEnabled: true,
      command: 'cat'
    ),
    containerTemplate(
      name: 'kustomize',
      image: 'webfuel/kustomize:3.6.1',
      ttyEnabled: true,
      command: 'cat'
    )
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    hostPathVolume(mountPath: '/root/.m2', hostPath: '/tmp/.m2'),
    hostPathVolume(mountPath: '/bin/kubectl', hostPath: '/bin/kubectl'),
    hostPathVolume(mountPath: '/bin/docker', hostPath: '/bin/docker'),
  ]
)

{
    node(POD_LABEL) {
        stage('git scm update'){
                git 'https://github.com/prj4devops/echo-buildtime.git'
        }
        stage('packaing'){
            container('maven'){
                sh 'export MAVEN_OPTS=-Xmx300m; mvn package'
            }
        }
        stage('build docker container') {
            container('maven'){
                sh 'docker build -t 192.168.1.10:8443/echo-buildtime:$BUILD_NUMBER .'
                sh 'docker push 192.168.1.10:8443/echo-buildtime:$BUILD_NUMBER'
            }
        }
        stage('update pods'){
            container('kustomize'){
                sh 'kustomize edit set image 192.168.1.10:8443/echo-buildtime:$BUILD_NUMBER'
                sh 'kustomize build  | kubectl apply -f -'
            }
        }

    }
}
