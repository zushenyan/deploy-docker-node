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
	docker build -t ddn . && \
	kubectl apply -f ./deployment