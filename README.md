# fastapi-celery-playground
Simple boilerplate fastapi + celery playground to get started.

I created this while trying to learn it myself and keep it as a reference for future use.

## Getting Started
Firstly clone the repo
```bash
git clone https://github.com/krishnasism/fastapi-celery-playground.git
cd fastapi-celery-playground
```

### Setup environment variables
Copy the `.env.example` file values into a new `.env` file to have the environment variables correctly set.

### Run services
After that, simply run

```bash
docker compose up --build
```

### Use it
- Do a GET request to `http://localhost:8000/api/v1/process/` to trigger the example task.
- Navigate to `http://localhost:5556/` to view the Flower Dashboard.

## Local Development
To install the dependencies locally, use poetry
```bash
pip install poetry
```
Clone the repo and install the dependencies
```
poetry install
```

We also have a couple of pre-commit hooks
```
pre-commit install
```

## Purpose

I am using this as a playground to play around with FastAPI, Celery, and some other concepts. This is not meant to be a production project, but a simple playground to experiment and learn, but can serve as a good starting point.

Things to do:

- [x] FastAPI
- [x] Celery
- [x] Docker
- [x] Linting
- [ ] Tests
- [ ] Kubernetes
- [ ] Terraform
- [ ] Observability
- [ ] Type Checking

## References:
- CeleryDocs: https://docs.celeryq.dev/
- FastAPI Docs: https://fastapi.tiangolo.com/
