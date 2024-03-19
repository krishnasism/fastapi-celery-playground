from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()


@router.get("/health-check/")
async def health_check() -> JSONResponse:
    return JSONResponse(
        content={
            "message": "healthy",
        },
        status_code=200,
    )
