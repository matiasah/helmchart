pipeline {

    parameters {
        string(description: "Kubernetes Namespace", name: "NAMESPACE", defaultValue: env.NAMESPACE ? env.NAMESPACE : "nginx-test")
        string(description: "Values YAML", name: "VALUES_YAML", defaultValue: env.VALUES_YAML ? env.VALUES_YAML : "nginx-values.yaml")
        booleanParam(description: "Debug", name: "DEBUG", defaultValue: env.DEBUG ? env.DEBUG : "false")
    }

    agent {
        label "jenkins-jenkins-agent"
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

    }
    
}
