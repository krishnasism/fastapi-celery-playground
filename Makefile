LOCAL_DOCKER_REGISTRY_PORT = 5000
FASTAPI_DOCKER_IMAGE_NAME = fastapi-celery-playground-fastapi:latest
CELERY_DOCKER_IMAGE_NAME = fastapi-celery-playground-celery_worker:latest
LOCAL_DOCKER_REGISTRY_HOST = localhost

build_all_images:
	docker compose build

create_local_docker_registry:
	docker run -d -p $(LOCAL_DOCKER_REGISTRY_PORT):$(LOCAL_DOCKER_REGISTRY_PORT) --restart=always --name registry registry:2

push_images_to_local_docker_registry:
	docker tag $(FASTAPI_DOCKER_IMAGE_NAME) $(LOCAL_DOCKER_REGISTRY_HOST):$(LOCAL_DOCKER_REGISTRY_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker push $(LOCAL_DOCKER_REGISTRY_HOST):$(LOCAL_DOCKER_REGISTRY_PORT)/$(FASTAPI_DOCKER_IMAGE_NAME)
	docker tag $(CELERY_DOCKER_IMAGE_NAME) $(LOCAL_DOCKER_REGISTRY_HOST):$(LOCAL_DOCKER_REGISTRY_PORT)/$(CELERY_DOCKER_IMAGE_NAME)
	docker push $(LOCAL_DOCKER_REGISTRY_HOST):$(LOCAL_DOCKER_REGISTRY_PORT)/$(CELERY_DOCKER_IMAGE_NAME)

create_infra:
	kubectl create -f k8s/local/namespace.yml --save-config
	kubectl create -f k8s/local/api/ --save-config
	kubectl create -f k8s/local/celery/ --save-config
	kubectl create -f k8s/local/celery-flower/ --save-config
	kubectl create -f k8s/local/redis/ --save-config

apply_infra:
	kubectl apply -f k8s/local/namespace.yml
	kubectl apply -f k8s/local/api/
	kubectl apply -f k8s/local/celery/
	kubectl apply -f k8s/local/celery-flower/
	kubectl apply -f k8s/local/redis/

start_services_minikube:
	minikube service fastapi-app start -n local
	minikube service celery-flower start -n local
	minikube service redis start -n local

apply_busybox:
	kubectl apply -f k8s/busybox.yml

purge_infra:
	kubectl delete -f k8s/local/namespace.yml
	kubectl delete -f k8s/local/api/
	kubectl delete -f k8s/local/celery/
	kubectl delete -f k8s/local/celery-flower/
	kubectl delete -f k8s/local/redis/

purge_busybox:
	kubectl delete -f k8s/busybox.yml