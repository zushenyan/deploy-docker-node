# docker compose
up:
	eval $$(minikube docker-env -u) && \
	eval $$(docker-machine env -u) && \
	docker-compose up -d --build

ssh:
	docker-compose exec app /bin/sh

down:
	docker-compose down

clean-db:
	rm -rf pgdata-development pgdata-test

# kubernetes
minikube:
	minikube addons enable ingress && \
	minikube start && \
	eval $$(minikube docker-env)

minikube-delete:
	make kube-delete; \
	eval $$(minikube docker-env -u) && \
	minikube stop && \
	minikube delete

kube:
	eval $$(minikube docker-env) && \
	make kube-delete; \
	make kube-create

kube-migrate:
	kubectl exec $(shell kubectl get pods -l app=job -o name --field-selector=status.phase==Running | sed 's/pods\///') yarn run seed

kube-create:
	docker build -t ddn . && \
	kubectl apply -f ./k8s

kube-delete:
	kubectl delete -f ./k8s
