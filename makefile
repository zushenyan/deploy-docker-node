CONFIG_FILE_DEV = docker-compose.dev.yml
CONFIG_FILE_TEST = docker-compose.test.yml

PROJECT_NAME_DEV = dev
PROJECT_NAME_TEST = test

all: dev

cleandb:
	rm -rf pgdata-development pgdata-test

resetdb: dev-down cleandb dev-build
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) exec app \
		sh -c \
			"./scripts/wait-for pg:5432 -- \
			yarn run sequelize db:migrate && \
			yarn run sequelize db:seed:all"

dev-build:
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) up -d --build

dev: dev-build
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) exec app /bin/sh

dev-down:
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) down

test:
	docker-compose -f $(CONFIG_FILE_TEST) -p $(PROJECT_NAME_TEST) build && \
	docker-compose -f $(CONFIG_FILE_TEST) -p $(PROJECT_NAME_TEST) run app
