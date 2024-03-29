/*
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins-slave
  namespace: jenkins
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-slave-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: jenkins-slave
  namespace: jenkins
*/

pipeline {

    parameters {
        choice(description: "Action", name: "Action", choices: ["Plan", "Apply"])
        string(description: "Kubernetes Namespace", name: "NAMESPACE", defaultValue: env.NAMESPACE ? env.NAMESPACE : "nginx-test")
        string(description: "Values YAML", name: "VALUES_YAML", defaultValue: env.VALUES_YAML ? env.VALUES_YAML : "nginx-values.yaml")
        booleanParam(description: "Debug", name: "DEBUG", defaultValue: env.DEBUG ? env.DEBUG : "false")
    }

    agent {
        kubernetes {
            yaml """
                apiVersion: "v1"
                kind: "Pod"
                spec:
                  securityContext:
                    runAsUser: 1001
                    runAsGroup: 1001
                    fsGroup: 1001
                  containers:
                  - command:
                    - "cat"
                    image: "alpine/helm:latest"
                    imagePullPolicy: "IfNotPresent"
                    name: "helm"
                    resources: {}
                    tty: true
                  - command:
                    - "cat"
                    image: "bitnami/kubectl:latest"
                    imagePullPolicy: "IfNotPresent"
                    name: "kubectl"
                    resources: {}
                    tty: true
                  serviceAccountName: jenkins-slave
            """
        }
    }

    stages {

        stage ("Template: Plan") {

            steps {

                container ("helm") {

                    script {

                        // Template Helm chart
                        sh "helm template nginx ./helmchart -n ${NAMESPACE} -f ${VALUES_YAML} ${env.DEBUG ? "--debug" : ""} > template.yaml"

                        // Log Helm chart manifest
                        sh "cat template.yaml"
        
                    }

                }

            }

        }

        stage ("Template: Apply") {

            when {
                
                expression {
                    return env.ACTION.equals("Apply")
                }
                
            }

            steps {

                container ("kubectl") {

                    script {

                        // Deploy manifest
                        sh "kubectl apply -f template.yaml"

                    }

                }

            }

        }

    }
    
}
