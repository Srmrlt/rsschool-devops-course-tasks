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
    GRAFANA_VALUES_FILE = 'helm-chart/grafana/values.yaml'
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

    stage('Deploy/Upgrade Prometheus') {
      steps {
        sh """
          helm upgrade --install prom bitnami/prometheus \
            --namespace ${NAMESPACE} --create-namespace \
            -f ${PROMETHEUS_VALUES_FILE} \
            --wait --timeout 5m
        """
      }
    }

    stage('Add Grafana Helm repo') {
      steps {
        sh '''
          helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update
        '''
      }
    }

    stage('Deploy/Upgrade Grafana') {
      steps {
        withCredentials([string(credentialsId: 'grafana-admin-pass', variable: 'GF_PASS')]) {
          sh '''
            kubectl create secret generic grafana-admin \
              --from-literal=admin-user='admin'
              --from-literal=admin-password=$GF_PASS \
              --namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
          '''
      }
        sh """
          helm upgrade --install grafana bitnami/grafana \
            --namespace ${NAMESPACE} --create-namespace \
            -f ${GRAFANA_VALUES_FILE} \
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
