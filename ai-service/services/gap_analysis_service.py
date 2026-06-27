from datetime import datetime, timezone

import google.generativeai as genai

from config import settings
from schemas.gap_analysis import (
    GapAnalysisRequest,
    GapAnalysisResponse,
    GeminiGapOutput,
    ModelMeta,
)

SYSTEM_INSTRUCTION = """You are a senior technical interviewer and career coach for the target role provided. \
You have personally interviewed hundreds of candidates for this role at top companies.

Your task: Analyze a candidate across three evidence sources — their resume skills, their target role's \
expected competencies, and their assessment performance including the specific questions they got wrong. \
Identify the gaps that would hurt them in an interview and explain why each gap matters to a hiring manager.

Rules:
- Ground every claim in the provided evidence. Never invent skills, scores, or experience not in the input.
- A gap is anything that would hurt the candidate in an interview: a topic they scored low on, an expected \
competency with no supporting evidence, or a credibility gap where they claim a skill on their resume but \
underperformed on it in the assessment. Flag credibility gaps as highest severity — interviewers probe exactly these.
- evidenceSource: use BOTH when the weakness appears in both resume (claimed skill) and assessment (poor score). \
Use RESUME_ONLY when a required competency has no resume evidence. \
Use ASSESSMENT_ONLY when the resume does not claim the skill but the assessment score was weak.
- Be specific and actionable. Cite the specific missed question topics to name the exact sub-skill gap.
- Calibrate to experience level. Hold senior candidates to a higher bar than juniors.
- Never contradict the numeric scores. A topic scored STRONG cannot be a gap.
- Limit to the 3–5 most impactful gaps for this specific role. Do not pad the list.

Score bands: STRONG ≥ 80%, PROFICIENT ≥ 60%, DEVELOPING ≥ 40%, WEAK < 40%. \
Treat WEAK and DEVELOPING as gap candidates; STRONG as strength candidates."""


def _build_user_prompt(req: GapAnalysisRequest) -> str:
    skills = ", ".join(req.resumeSkills) if req.resumeSkills else "None detected"
    expected = ", ".join(req.roleExpectedTopics)

    scores = "\n  ".join(
        f'<topic name="{s.topicDisplayName}" asked="{s.asked}" correct="{s.correct}" '
        f'score="{s.score}%" band="{s.band}"/>'
        for s in req.topicScores
    )

    missed = (
        "\n  ".join(
            f'<question topic="{m.topicDisplayName}" difficulty="{m.difficulty}">{m.stem}</question>'
            for m in req.missedQuestions
        )
        if req.missedQuestions
        else "<none/>"
    )

    return f"""<candidate>
  <target_role>{req.targetRole}</target_role>
  <experience_level>{req.experienceLevel} ({req.yearsOfExperience} years)</experience_level>
</candidate>

<resume_skills>
  {skills}
</resume_skills>

<role_expected_competencies>
  {expected}
</role_expected_competencies>

<assessment_scores>
  {scores}
</assessment_scores>

<missed_questions>
  {missed}
</missed_questions>

<instructions>
  Produce the gap analysis using the JSON schema provided. Prioritize credibility gaps \
(resume claims contradicted by weak assessment scores). Limit to the 3–5 most impactful \
gaps. Do not include a gap for any topic that scored STRONG.
</instructions>"""


def generate_gap_analysis(req: GapAnalysisRequest) -> GapAnalysisResponse:
    genai.configure(api_key=settings.gemini_api_key)

    model = genai.GenerativeModel(
        model_name=settings.gemini_model,
        system_instruction=SYSTEM_INSTRUCTION,
        generation_config=genai.GenerationConfig(
            temperature=settings.gemini_temperature,
            response_mime_type="application/json",
            response_schema=GeminiGapOutput,
        ),
    )

    response = model.generate_content(_build_user_prompt(req))
    parsed = GeminiGapOutput.model_validate_json(response.text)

    return GapAnalysisResponse(
        readinessLevel=parsed.readinessLevel,
        readinessSummary=parsed.readinessSummary,
        strengths=parsed.strengths,
        gaps=parsed.gaps,
        modelMeta=ModelMeta(
            modelId=settings.gemini_model,
            generatedAt=datetime.now(timezone.utc).isoformat(),
        ),
    )
