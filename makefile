CONFIG_FILE_DEV = docker-compose.dev.yml
CONFIG_FILE_PROD = docker-compose.prod.yml

PROJECT_NAME_DEV = ddndev
PROJECT_NAME_PROD = ddn

all: up sh

prune:
	yes | docker system prune -a && yes | docker volume prune

cleandb:
	rm -rf pgdata-development pgdata-test

resetdb: down cleandb up
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) exec app \
		sh -c \
			"./scripts/wait-for pg:5432 -- \
			yarn run sequelize db:migrate && \
			yarn run sequelize db:seed:all"

up:
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) up -d --build

sh:
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) exec app /bin/sh

down:
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) down

push:
	docker-compose -f $(CONFIG_FILE_PROD) -p $(PROJECT_NAME_PROD) build && \
	docker-compose -f $(CONFIG_FILE_PROD) -p $(PROJECT_NAME_PROD) push

down-prod:
	docker-compose -f $(CONFIG_FILE_PROD) -p $(PROJECT_NAME_PROD) down
