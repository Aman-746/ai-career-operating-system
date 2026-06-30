from fastapi import APIRouter

from schemas.progress_analysis import ProgressAnalysisRequest, ProgressAnalysisResponse
from services.progress_analysis_service import generate_progress_analysis

router = APIRouter()


@router.post("/generate/progress-analysis", response_model=ProgressAnalysisResponse)
def progress_analysis(request: ProgressAnalysisRequest) -> ProgressAnalysisResponse:
    return generate_progress_analysis(request)
