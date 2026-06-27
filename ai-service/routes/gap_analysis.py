from fastapi import APIRouter, HTTPException

from schemas.gap_analysis import GapAnalysisRequest, GapAnalysisResponse
from services.gap_analysis_service import generate_gap_analysis

router = APIRouter()


@router.post("/analyze/gap", response_model=GapAnalysisResponse)
def analyze_gap(request: GapAnalysisRequest) -> GapAnalysisResponse:
    try:
        return generate_gap_analysis(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Gap analysis failed: {str(e)}")
