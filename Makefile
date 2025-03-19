APP_VERSION ?= v1.0
IMAGE_REGISTRY ?= krithikasharma
IMAGE_NAME ?= salary-api

# Build salary api
build:
	mvn clean package

# Run checkstyle against code
fmt:
	mvn checkstyle:checkstyle

# Run jacoco test cases for coverage
test:
	mvn test

docker-build:
	docker build -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${APP_VERSION} -f Dockerfile .

docker-push:
	docker push ${IMAGE_REGISTRY}/${IMAGE_NAME}:${APP_VERSION}

create-keyspace:
	docker exec  scylladb cqlsh -e "CREATE KEYSPACE IF NOT EXISTS employee_db WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"

run-migrations: create-keyspace
	migrate -source file://migration -database "$(shell cat migration.json | jq -r '.database')" up

deploy:
	docker run -d --name salary  -p 8010:8080 ${IMAGE_REGISTRY}/${IMAGE_NAME}:${APP_VERSION}
