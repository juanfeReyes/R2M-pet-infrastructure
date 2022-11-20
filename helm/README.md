## Execution commands

### Strategy
1. First build all images that are required for the cluster
2. Run deployment script to allow helm to install charts


kubectl port-forward --address 0.0.0.0 service/mariadb-release 3306:3306
kubectl port-forward --address 0.0.0.0 ing/mariadb-ingress 8081:80
