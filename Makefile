#!make
include .env

# In case you want a local K8s cluster
prepare_local:
	minikube start
	minikube addons enable ingress
	minikube addons enable ingress-dns
	minikube tunnel

# Build all docker images
build_all_images:
	docker compose build

# Push images to your docker registry
# On Windows, login to docker hub through Docker Desktop
push_images_to_docker_registry:
	docker login
	docker tag $(FASTAPI_DOCKER_IMAGE_NAME) $(DOCKER_REGISTRY_HOST_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker push $(DOCKER_REGISTRY_HOST_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker tag $(CELERY_DOCKER_IMAGE_NAME) $(DOCKER_REGISTRY_HOST_PORT)/$(CELERY_DOCKER_IMAGE_NAME)
	docker push $(DOCKER_REGISTRY_HOST_PORT)/$(CELERY_DOCKER_IMAGE_NAME)

# Apply infra files
apply_infra:
	kubectl apply -f .k8s/$(ENVIRONMENT)/namespace.yml
	kubectl apply -f .k8s/$(ENVIRONMENT)/configs/
	kubectl apply -f .k8s/$(ENVIRONMENT)/redis/
	kubectl apply -f .k8s/$(ENVIRONMENT)/celery/
	kubectl apply -f .k8s/$(ENVIRONMENT)/celery-flower/
	kubectl apply -f .k8s/$(ENVIRONMENT)/api/

# Run the services after deployments have been created and are running

# Start services (do it in order)
start_redis:
	minikube service redis start -n $(ENVIRONMENT)

start_fastapi:
	minikube service fastapi-app start -n $(ENVIRONMENT)

start_celery_flower:
	minikube service celery-flower start -n $(ENVIRONMENT)

apply_ingress:
	kubectl apply -f .k8s/$(ENVIRONMENT)/ingress.yml

# In case you want to poke around your cluster
apply_busybox:
	kubectl apply -f .k8s/busybox.yml

# Drop infra
purge_infra:
	kubectl delete -f .k8s/$(ENVIRONMENT)/namespace.yml

purge_ingress:
	kubectl delete -f .k8s/$(ENVIRONMENT)/ingress.yml

purge_busybox:
	kubectl delete -f .k8s/busybox.yml