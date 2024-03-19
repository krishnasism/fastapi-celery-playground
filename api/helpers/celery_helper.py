import os
from typing import Any

from celery import Celery


class CeleryClient:
    _instance = None

    def __new__(cls, *args, **kwargs) -> "CeleryClient":
        if not cls._instance:
            cls._instance = super().__new__(cls)
            cls._instance.app = Celery(broker=os.getenv("CELERY_BROKER_URL"), backend=os.getenv("CELERY_BACKEND_URL"))
        return cls._instance

    def __init__(self) -> None:
        pass

    async def send_message(self, task_name: str, params: dict[str, Any]) -> None:
        if not self._instance:
            raise Exception("Celery not initialised")

        self._instance.app.send_task(
            task_name,
            kwargs=params,
        )


async def get_celery_client() -> CeleryClient:
    return CeleryClient()
