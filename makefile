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
	kubectl exec $(shell kubectl get pods -l app=job -o name --field-selector=status.phase==Running | sed 's/pods\///') yarn run seed

kube-create:
	make kube-build && \
	make kube-create-configmaps; \
	make kube-create-secrets; \
	kubectl create \
		-f ./k8s/deployments \
		-f ./k8s/config-maps \
		-f ./k8s/persistent-volume \
		-f ./k8s/persistent-volume-claim \

kube-build:
	docker build -t ddn .

kube-create-configmaps:
	kubectl create configmap nginx-conf --from-file ./nginx/prod/nginx.conf -o yaml | kubectl replace -f -

kube-create-secrets:
	kubectl create secret generic nginx-ssl \
		--from-file=./nginx/prod/nginx-selfsigned.crt \
		--from-file=./nginx/prod/nginx-selfsigned.key

kube-delete:
	kubectl delete service app-service nginx-service pg-service; \
	kubectl delete deployment app nginx pg job; \
	kubectl delete secrets nginx-ssl; \
	kubectl delete configmap nginx-conf config; \
	kubectl delete pv pg-data; \
	kubectl delete pvc pg-data-claim

kube-url:
	minikube service nginx-service --url
