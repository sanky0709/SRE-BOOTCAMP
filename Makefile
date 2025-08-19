.PHONY: db build run run-api stop clean logs lint test docker-build docker-push

db:
	@echo "Starting DB container..."
	docker compose up -d migrate

build:
	@echo "Building REST API image..."
	docker compose build api

run-api:
	@echo "Running API container..."
	docker compose up -d api

run: db build run-api

stop:
	docker compose down

clean:
	docker compose down -v

logs:
	docker compose logs -f

# ---- New targets for CI ----
lint:
	@echo "Running lint..."
	flake8 app tests run.py

test:
	@echo "Running tests..."
	PYTHONPATH=. pytest --maxfail=1 --disable-warnings -q

docker-build:
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE) .

docker-push:
	@echo "Pushing Docker image..."
	docker push $(DOCKER_IMAGE)
