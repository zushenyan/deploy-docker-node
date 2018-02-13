CONFIG_FILE_DEV = docker-compose.dev.yml
CONFIG_FILE_TEST = docker-compose.test.yml

PROJECT_NAME_DEV = dev
PROJECT_NAME_TEST = test

APP_CONTAINER = deploydockernode_app_1

all: dev-log

cleandb:
	rm -rf pgdata-development pgdata-test

resetdb: dev-down cleandb dev-run
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) exec app \
		./wait-for pg:5432 -- \
			yarn run sequelize db:migrate && \
			yarn run sequelize db:seed:all

dev-run:
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) up -d --build

dev-log: dev-run
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) logs -f

dev-down:
	docker-compose -f $(CONFIG_FILE_DEV) -p $(PROJECT_NAME_DEV) down

test:
	docker-compose -f $(CONFIG_FILE_TEST) -p $(PROJECT_NAME_TEST) build && \
	docker-compose -f $(CONFIG_FILE_TEST) -p $(PROJECT_NAME_TEST) run app
