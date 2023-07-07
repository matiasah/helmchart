pipeline {

    parameters {
        choice(description: "Action", name: "Action", choices: ["Plan", "Apply"])
        string(description: "Kubernetes Namespace", name: "NAMESPACE", defaultValue: env.NAMESPACE ? env.NAMESPACE : "nginx-test")
        string(description: "Values YAML", name: "VALUES_YAML", defaultValue: env.VALUES_YAML ? env.VALUES_YAML : "nginx-values.yaml")
        booleanParam(description: "Debug", name: "DEBUG", defaultValue: env.DEBUG ? env.DEBUG : "false")
    }

    agent {
        label "jenkins-jenkins-agent"
        /**
        kubernetes {
            containerTemplate {
                name 'helm'
                image 'lachlanevenson/k8s-helm:v3.1.1'
                ttyEnabled true
                command 'cat'
            }
        }
        **/
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

                container ("helm") {

                    script {

                        sh "kubectl apply -f template.yaml"

                    }

                }

            }

        }

    }
    
}
