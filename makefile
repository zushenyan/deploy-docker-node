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
	kubectl apply -f ./k8s

kube-build:
	docker build -t ddn .

kube-create-configmaps:
	# kubectl create configmap nginx-conf --from-file ./nginx/prod/nginx.conf -o yaml | kubectl replace -f -

kube-create-secrets:
	# kubectl create secret tls tls-certificate \
	# 	--key ./nginx/prod/nginx-selfsigned.key \
	# 	--cert ./nginx/prod/nginx-selfsigned.crt; \
	# kubectl create secret generic tls-dhparam \
	# 	--from-file=./nginx/prod/dhparam.pem
	# kubectl create secret generic nginx-ssl \
	# 	--from-file=./nginx/prod/nginx-selfsigned.crt \
	# 	--from-file=./nginx/prod/nginx-selfsigned.key

kube-delete:
	kubectl delete -f ./k8s; \
	kubectl delete configmap nginx-conf config; \
	kubectl delete secrets tls-certificate tls-dhparam
	# kubectl delete secrets nginx-ssl; \

kube-url:
	minikube service nginx-service --url
