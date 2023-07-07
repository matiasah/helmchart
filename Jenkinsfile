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
            """
        }
    }

    stages {

        stage ("Template: Plan") {

            steps {

                container ("helm") {

                    script {
    
                        sh "helm template nginx ./helmchart -n ${NAMESPACE} -f ${VALUES_YAML} ${env.DEBUG ? "--debug" : ""} > template.yaml"
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

                        sh "kubectl apply -f template.yaml"

                    }

                }

            }

        }

    }
    
}
