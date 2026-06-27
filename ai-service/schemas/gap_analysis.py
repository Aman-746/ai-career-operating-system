from typing import List, Literal
from pydantic import BaseModel


# --- Gemini response schema (no modelMeta — stamped server-side after the call) ---

class Strength(BaseModel):
    area: str
    evidence: str


class Gap(BaseModel):
    area: str
    severity: Literal["CRITICAL", "MODERATE", "MINOR"]
    evidenceSource: Literal["RESUME_ONLY", "ASSESSMENT_ONLY", "BOTH"]
    insight: str
    recommendation: str


class GeminiGapOutput(BaseModel):
    """Passed as responseSchema to Gemini. Never exposed directly to Spring Boot."""
    readinessLevel: Literal["NOT_READY", "DEVELOPING", "INTERVIEW_READY"]
    readinessSummary: str
    strengths: List[Strength]
    gaps: List[Gap]


# --- Spring Boot ↔ Python contract ---

class ModelMeta(BaseModel):
    modelId: str
    generatedAt: str


class GapAnalysisResponse(BaseModel):
    """Returned to Spring Boot — includes modelMeta stamped by the Python service."""
    readinessLevel: str
    readinessSummary: str
    strengths: List[Strength]
    gaps: List[Gap]
    modelMeta: ModelMeta


class TopicScore(BaseModel):
    topic: str
    topicDisplayName: str
    asked: int
    correct: int
    score: int
    band: str


class MissedQuestion(BaseModel):
    topic: str
    topicDisplayName: str
    difficulty: str
    stem: str


class GapAnalysisRequest(BaseModel):
    """Context bundle sent from Spring Boot — all signals needed for gap analysis."""
    targetRole: str
    experienceLevel: str
    yearsOfExperience: int
    resumeSkills: List[str]
    roleExpectedTopics: List[str]
    topicScores: List[TopicScore]
    missedQuestions: List[MissedQuestion]
