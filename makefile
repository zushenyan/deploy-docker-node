# all:
# 	make build && \
# 	make clean; \
# 	make run

# ssh:
# 	kubectl exec -it $(shell kubectl get pods -l apps=ddn -o name --field-selector=status.phase==Running | sed 's/pods\///') sh

# build:
# 	docker build -t ddn .

# run:
# 	kubectl create -f kube-dev.yml

# clean:
# 	kubectl delete services,deployments ddn

# prune:
# 	yes | docker system prune -a && yes | docker volume prune

# docker compose
up:
	docker-compose up -d --build

ssh:
	docker-compose exec app /bin/sh

down:
	docker-compose down

clean-db:
	rm -rf pgdata-development pgdata-test

# kubernetes
kube:
	@eval $$(minikube docker-env) && \
	make kube-delete; \
	make kube-create

kube-migrate:
	kubectl exec $(shell kubectl get pods -l app=app -o name --field-selector=status.phase==Running | head -n 1 | sed 's/pods\///') yarn run seed

kube-create:
	docker build -t ddn . && \
	kubectl create -f ./k8s/deployments -f ./k8s/secrets -f ./k8s/configmaps

kube-delete:
	kubectl delete service app-service nginx-service pg-service; \
	kubectl delete deployment app nginx pg; \
	kubectl delete secrets nginx-ssl; \
	kubectl delete configmap nginx-conf

kube-url:
	minikube service nginx-service --url
