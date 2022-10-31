helm template nginx ./helmchart -n nginx-test -f nginx-values.yaml --debug > nginx-template.yaml
kubectl apply -f nginx-template.yaml