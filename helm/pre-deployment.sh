# Build Images required for cluster deployment

# repositories
# helm repo add codecentric https://codecentric.github.io/helm-charts
# helm repo add bitnami https://charts.bitnami.com/bitnami


echo "Build images process started"

if [-d "tmp"]; then rm -rf /tmp; fi
mkdir tmp

docker build --no-cache -t pets-infra/keycloak-provisioning ./shared/keycloak/pre-install
docker pull quay.io/keycloak/keycloak:17.0.1-legacy

# If cluster in minikube then load images
minikube image load pets-infra/keycloak-provisioning --overwrite
minikube image load quay.io/keycloak/keycloak
