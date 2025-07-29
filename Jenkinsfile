pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: ci
    image: ci-agent:latest
    imagePullPolicy: IfNotPresent
    tty: true
    securityContext:
      privileged: true
"""
      defaultContainer 'ci'
    }
  }

  environment {
    NAMESPACE = 'monitoring'
    PROMETHEUS_VALUES_FILE = 'helm-chart/prometheus/values.yaml'
  }

  stages {
    stage('Checkout sources') {
      steps {
        checkout scm
      }
    }

    stage('Add Prometheus Helm repo') {
      steps {
        sh '''
          helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update
        '''
      }
    }

    stage('Deploy / Upgrade') {
      steps {
        sh """
          helm upgrade --install prom bitnami/prometheus \
            --namespace ${NAMESPACE} --create-namespace \
            -f ${PROMETHEUS_VALUES_FILE} \
            --wait --timeout 5m
        """
      }
    }

    stage('Smoke test') {
      steps {
        sh 'kubectl get pods -n ${NAMESPACE}'
      }
    }
  }

}
