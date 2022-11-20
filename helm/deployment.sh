echo "Seeting roles for deployment"
#kubectl apply -f shared/roles/job-watch-roles.yml

echo "Starting deployment"
if !(  kubectl get pods -o jsonpath='{range .items[*]}{.status.containerStatuses[*].ready.true}{.metadata.name}{ "\n"}{end}' | grep -q mariadb-release )
then
  echo "Installing MariaDB"
  mariadb_path=$(find . -type d -iname "mariadb")
  helm install -f "${mariadb_path}/values.yml" mariadb-release bitnami/mariadb
  sleep 60s
fi

if !(  kubectl get pods -n ingress-nginx -o jsonpath='{range .items[*]}{.status.containerStatuses[*].ready.true}{.metadata.name}{ "\n"}{end}' | grep -q nginx-controller-release )
then
  echo "Intalling Nginx ingress controller"
  ingress_controller_path=$(find . -type d -iname "nginx-controller")
  helm upgrade nginx-controller-release ingress-nginx --install --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace -f "${ingress_controller_path}/values.yml"
  kubectl apply -f "${ingress_controller_path}/tcp-services-configmap.yml" -n ingress-nginx
  sleep 60s
fi

if !(  kubectl get pods -o jsonpath='{range .items[*]}{.status.containerStatuses[*].ready.true}{.metadata.name}{ "\n"}{end}' | grep -q keycloak-release )
then
  echo "Installing Keycloak"
  keycloak_path=$(find . -type d -iname "keycloak")
  ## Run job to provision keycloak user info
  helm delete pre-keycloak-job
  helm upgrade -i pre-keycloak-job "${keycloak_path}/pre-install" -f "${keycloak_path}/pre-install/values.yml" 
  # TODO: Add init container to wait for pre-job
  # Create secret with Realm information
  kubectl create secret generic keycloak-realm-secret --from-file=shared/keycloak/pet-realm.json
  helm install -f "${keycloak_path}/values.yml" keycloak-release codecentric/keycloak
  # Add ingress rule for keycloak
fi

