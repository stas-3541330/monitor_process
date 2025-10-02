pipeline {
  agent any

  environment {
    MONITOR_IMAGE = "stas3541330/monitor-process:latest"
    TEST_POD_FILE = "test-pod.yaml"
    MONITOR_DEPLOY_FILE = "deployment.yaml"
  }

  stages {
    stage('Deploy test process') {
      steps {
        script {
          writeFile file: TEST_POD_FILE, text: '''
apiVersion: v1
kind: Pod
metadata:
  name: test-process
spec:
  containers:
  - name: test
    image: debian:12-slim
    command: ["bash", "-c", "while true; do sleep 10; done"]
'''
          sh "kubectl apply -f ${TEST_POD_FILE}"
        }
      }
    }

    stage('Deploy monitor process') {
      steps {
        sh "kubectl apply -f ${MONITOR_DEPLOY_FILE}"
      }
    }

    stage('Verify deployment') {
      steps {
        sh '''
          echo "Checking test-process pod..."
          kubectl wait --for=condition=Ready pod/test-process --timeout=30s

          echo "Checking monitor-process deployment..."
          kubectl rollout status deployment/monitor_process --timeout=30s
        '''
      }
    }
  }
}

