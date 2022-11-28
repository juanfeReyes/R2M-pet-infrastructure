## Execution commands

### Strategy
1. First build all images that are required for the cluster
2. Run deployment script to allow helm to install charts
3. Run: `minikube tunnel` to expose ingress to windows local host

### Study notes:

#### Ingress

  - Nginx works as an ingress service to expose HTTP/HTTPS and TCP ports to external clients
  - Nginx value.yml file contains the TCP ports to expose, follow documentation
  - To expose ingress rules for services, add the IngressClassName: nginx, as required to update nginx ingress

#### Secrets

  - Secrets can be configured as a configMap which will be stored in pod volume

#### Volumes

  - Need to stody more to be honest

#### Services

  - Used as an entry point to a pod
