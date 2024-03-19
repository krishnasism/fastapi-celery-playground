from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse
from helpers.celery_helper import CeleryClient, get_celery_client

router = APIRouter()


@router.get("/process/")
async def process(celery_client: CeleryClient = Depends(get_celery_client)) -> JSONResponse:
    await celery_client.send_message(
        task_name="tasks.process_numbers",
        params={
            "numbers": [1, 2, 3, 4, 5],
        },
    )
    return JSONResponse(
        content={
            "message": "submitted",
        },
        status_code=201,
    )
