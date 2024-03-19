import os

from celery import Celery

app = Celery(
    "my_celery_app",
    broker=os.getenv("CELERY_BROKER_URL"),
    backend=os.getenv("CELERY_BACKEND_URL"),
    include=["tasks"],
)

if __name__ == "__main__":
    app.start()
