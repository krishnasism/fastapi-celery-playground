#!make
include .env

build_all_images:
	docker compose build

create_local_docker_registry:
	docker run -d -p $(DOCKER_REGISTRY_PORT):$(DOCKER_REGISTRY_PORT) --restart=always --name registry registry:2

push_images_to_docker_registry:
	docker tag $(FASTAPI_DOCKER_IMAGE_NAME) $(DOCKER_REGISTRY_HOST_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker push $(DOCKER_REGISTRY_HOST_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker tag $(CELERY_DOCKER_IMAGE_NAME) $(DOCKER_REGISTRY_HOST_PORT)/$(CELERY_DOCKER_IMAGE_NAME)
	docker push $(DOCKER_REGISTRY_HOST_PORT)/$(CELERY_DOCKER_IMAGE_NAME)

create_infra:
	kubectl create -f k8s/$(ENVIRONMENT)/namespace.yml --save-config
	kubectl create -f k8s/$(ENVIRONMENT)/api/ --save-config
	kubectl create -f k8s/$(ENVIRONMENT)/celery/ --save-config
	kubectl create -f k8s/$(ENVIRONMENT)/celery-flower/ --save-config
	kubectl create -f k8s/$(ENVIRONMENT)/redis/ --save-config

apply_infra:
	kubectl apply -f k8s/$(ENVIRONMENT)/namespace.yml
	kubectl apply -f k8s/$(ENVIRONMENT)/api/
	kubectl apply -f k8s/$(ENVIRONMENT)/celery/
	kubectl apply -f k8s/$(ENVIRONMENT)/celery-flower/
	kubectl apply -f k8s/$(ENVIRONMENT)/redis/

start_services_minikube:
	minikube service fastapi-app start -n $(ENVIRONMENT)
	minikube service celery-flower start -n $(ENVIRONMENT)
	minikube service redis start -n $(ENVIRONMENT)

apply_busybox:
	kubectl apply -f k8s/busybox.yml

purge_infra:
	kubectl delete -f k8s/$(ENVIRONMENT)/namespace.yml
	kubectl delete -f k8s/$(ENVIRONMENT)/api/
	kubectl delete -f k8s/$(ENVIRONMENT)/celery/
	kubectl delete -f k8s/$(ENVIRONMENT)/celery-flower/
	kubectl delete -f k8s/$(ENVIRONMENT)/redis/

purge_busybox:
	kubectl delete -f k8s/busybox.yml