#!make
include .env

prepare_local:
	minikube start

build_all_images:
	docker compose build

create_local_docker_registry:
	docker run -d -p $(DOCKER_REGISTRY_PORT):$(DOCKER_REGISTRY_PORT) --restart=always --name registry registry:2

push_images_to_docker_registry:
	docker login
	docker tag $(FASTAPI_DOCKER_IMAGE_NAME) $(DOCKER_REGISTRY_HOST_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker push $(DOCKER_REGISTRY_HOST_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker tag $(CELERY_DOCKER_IMAGE_NAME) $(DOCKER_REGISTRY_HOST_PORT)/$(CELERY_DOCKER_IMAGE_NAME)
	docker push $(DOCKER_REGISTRY_HOST_PORT)/$(CELERY_DOCKER_IMAGE_NAME)

apply_infra:
	kubectl apply -f k8s/$(ENVIRONMENT)/namespace.yml
	kubectl apply -f k8s/$(ENVIRONMENT)/secrets/secrets.yml
	kubectl apply -f k8s/$(ENVIRONMENT)/api/
	kubectl apply -f k8s/$(ENVIRONMENT)/celery/
	kubectl apply -f k8s/$(ENVIRONMENT)/celery-flower/
	kubectl apply -f k8s/$(ENVIRONMENT)/redis/

start_redis:
	minikube service redis start -n $(ENVIRONMENT)

start_fastapi:
	minikube service fastapi-app start -n $(ENVIRONMENT)

start_celery_flower:
	minikube service celery-flower start -n $(ENVIRONMENT)

apply_busybox:
	kubectl apply -f k8s/busybox.yml

purge_infra:
	kubectl delete -f k8s/$(ENVIRONMENT)/namespace.yml

purge_busybox:
	kubectl delete -f k8s/busybox.yml