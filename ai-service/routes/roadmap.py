from fastapi import APIRouter, HTTPException

from schemas.roadmap import RoadmapRequest, RoadmapResponse
from services.roadmap_service import generate_roadmap

router = APIRouter()


@router.post("/generate/roadmap", response_model=RoadmapResponse)
def generate_roadmap_route(request: RoadmapRequest) -> RoadmapResponse:
    try:
        return generate_roadmap(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Roadmap generation failed: {str(e)}")
