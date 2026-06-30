from typing import List, Literal
from pydantic import BaseModel


# --- Gemini response schema (no modelMeta — stamped server-side after the call) ---

class RoadmapItem(BaseModel):
    topicName: str
    category: Literal["DSA", "System Design", "Behavioral", "Language/Framework", "Other"]


class WeekPlan(BaseModel):
    weekNumber: int
    items: List[RoadmapItem]


class GeminiRoadmapOutput(BaseModel):
    """Passed as responseSchema to Gemini. Never exposed directly to Spring Boot."""
    weeks: List[WeekPlan]
    rationale: str


# --- Spring Boot ↔ Python contract ---

class ModelMeta(BaseModel):
    modelId: str
    generatedAt: str


class RoadmapResponse(BaseModel):
    """Returned to Spring Boot — includes modelMeta stamped by the Python service."""
    weeks: List[WeekPlan]
    rationale: str
    modelMeta: ModelMeta


class TopicScore(BaseModel):
    topic: str
    topicDisplayName: str
    asked: int
    correct: int
    score: int
    band: str


class GapSummary(BaseModel):
    area: str
    severity: Literal["CRITICAL", "MODERATE", "MINOR"]


class StrengthSummary(BaseModel):
    area: str
    evidence: str


class RoadmapRequest(BaseModel):
    """Context bundle sent from Spring Boot — all signals needed for roadmap generation."""
    targetRole: str
    totalWeeks: int
    experienceLevel: str
    yearsOfExperience: int
    resumeSkills: List[str]
    topicScores: List[TopicScore]
    gaps: List[GapSummary]
    strengths: List[StrengthSummary]
