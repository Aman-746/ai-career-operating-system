from typing import List, Literal, Optional
from pydantic import BaseModel


# --- Input from Spring Boot ---

class TopicSummary(BaseModel):
    topicName: str
    category: str
    hours: float


class UpdateSummary(BaseModel):
    date: str
    totalHours: float
    notes: Optional[str] = None
    topics: List[TopicSummary]


class RoadmapItemSummary(BaseModel):
    topicName: str
    category: str
    status: Literal["NOT_STARTED", "IN_PROGRESS", "COMPLETED"]


class GapSummary(BaseModel):
    area: str
    severity: str


class ProgressAnalysisRequest(BaseModel):
    targetRole: str
    roadmapRationale: str
    totalWeeks: int
    updates: List[UpdateSummary]
    roadmapItems: List[RoadmapItemSummary]
    gaps: List[GapSummary]


# --- Gemini response schema ---

class GeminiProgressOutput(BaseModel):
    """Passed as responseSchema to Gemini. Never exposed directly to Spring Boot."""
    summary: str
    strengths: List[str]
    areasToImprove: List[str]
    recommendedFocus: List[str]
    hoursPaceComment: str


# --- Spring Boot contract ---

class ModelMeta(BaseModel):
    modelId: str
    generatedAt: str


class AnalysisBody(BaseModel):
    summary: str
    strengths: List[str]
    areasToImprove: List[str]
    recommendedFocus: List[str]
    hoursPaceComment: str
    modelMeta: ModelMeta


class ProgressAnalysisResponse(BaseModel):
    analysis: AnalysisBody
    modelMeta: ModelMeta
