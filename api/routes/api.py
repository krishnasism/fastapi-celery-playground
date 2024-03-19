from fastapi import APIRouter

from .services import health_check, process

router = APIRouter()
router.include_router(health_check.router, tags=["health_check"])
router.include_router(process.router, tags=["process"])
