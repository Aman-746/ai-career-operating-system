from datetime import datetime, timezone

import google.generativeai as genai

from config import settings
from schemas.roadmap import (
    GeminiRoadmapOutput,
    ModelMeta,
    RoadmapRequest,
    RoadmapResponse,
)

# Built by hand instead of passing the GeminiRoadmapOutput class directly:
# google-generativeai's automatic Pydantic -> Gemini schema conversion
# (content_types.add_object_type) strips the "required" array from every
# nested object, so Gemini is never told that `items` is mandatory on a
# week and sometimes returns a week with only `weekNumber`. A plain dict
# schema skips that lossy conversion and keeps "required" intact.
ROADMAP_RESPONSE_SCHEMA = {
    "type": "object",
    "properties": {
        "weeks": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "weekNumber": {"type": "integer"},
                    "items": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "topicName": {"type": "string"},
                                "category": {
                                    "type": "string",
                                    "enum": [
                                        "DSA",
                                        "System Design",
                                        "Behavioral",
                                        "Language/Framework",
                                        "Other",
                                    ],
                                },
                            },
                            "required": ["topicName", "category"],
                        },
                    },
                },
                "required": ["weekNumber", "items"],
            },
        },
        "rationale": {"type": "string"},
    },
    "required": ["weeks", "rationale"],
}

SYSTEM_INSTRUCTION = """You are a senior software engineering interview coach and curriculum designer.

Your task: Create a week-by-week study roadmap for a software engineer preparing for a specific target role.

Rules:
- Cover ALL major topic areas required for the target role. Never drop a topic, even if the candidate is already strong in it.
- Use the gaps and topicScores to PRIORITIZE: CRITICAL and MODERATE gaps should appear in earlier weeks with more items.
- Strong areas (in strengths) and topics with high scores appear later in the plan as lighter review.
- Each week should have 2–5 study items. Do not overload any single week.
- Distribute topics across the full timeline; interleave different categories — do not block all DSA into consecutive weeks.
- Keep topic names specific and actionable (e.g. "Arrays & Hashing", "Binary Search Trees", "SQL Joins & Indexes", "System Design: Caching", "STAR Behavioral Storytelling").
- category must be exactly one of: DSA, System Design, Behavioral, Language/Framework, Other.
- The rationale must be 2–3 sentences explaining the overall strategy: which areas are prioritized and why.
- Do not add padding. Every item must represent real, meaningful study work.
- The response MUST strictly conform to the provided JSON schema.
- Return exactly `total_weeks` week objects in the `weeks` array.
- Every week object MUST contain both:
 - `weekNumber`
 - `items`
- The `items` field MUST always be present and MUST be an array.
- Every week must contain between 2 and 5 items. Never return an empty week.
- Never omit required fields, even if a week has fewer recommended topics.
 Each item MUST contain:
  - `topicName`
  - `category`
- `category` must be exactly one of: `DSA`, `System Design`, `Behavioral`, `Language/Framework`, `Other`.
- Ensure all week numbers are sequential starting from 1.
- Before finalizing the response, verify that every week contains an `items` array with 2–5 valid study items.
- CRITICAL: Do not output a week object containing only weekNumber. Every week must include a non-empty items array.
"""


def _build_user_prompt(req: RoadmapRequest) -> str:
    skills = ", ".join(req.resumeSkills) if req.resumeSkills else "None detected"

    scores = "\n  ".join(
        f'<topic name="{s.topicDisplayName}" score="{s.score}%" band="{s.band}"/>'
        for s in req.topicScores
    ) if req.topicScores else "<none/>"

    gaps = "\n  ".join(
        f'<gap area="{g.area}" severity="{g.severity}"/>'
        for g in req.gaps
    ) if req.gaps else "<none/>"

    strengths = "\n  ".join(
        f'<strength area="{s.area}"/>'
        for s in req.strengths
    ) if req.strengths else "<none/>"

    return f"""<candidate>
  <target_role>{req.targetRole}</target_role>
  <experience_level>{req.experienceLevel} ({req.yearsOfExperience} years)</experience_level>
  <total_weeks>{req.totalWeeks}</total_weeks>
</candidate>

<resume_skills>
  {skills}
</resume_skills>

<assessment_scores>
  {scores}
</assessment_scores>

<gaps>
  {gaps}
</gaps>

<strengths>
  {strengths}
</strengths>

<instructions>
  Generate a {req.totalWeeks}-week study roadmap. Prioritize CRITICAL and MODERATE gaps in early weeks. \
Schedule strong areas as brief review passes in later weeks. Cover all topics required for {req.targetRole}. \
Each week must have 2–5 items. Return the roadmap and a 2–3 sentence rationale.
</instructions>"""


def generate_roadmap(req: RoadmapRequest) -> RoadmapResponse:
    genai.configure(api_key=settings.gemini_api_key)

    model = genai.GenerativeModel(
        model_name=settings.gemini_model,
        system_instruction=SYSTEM_INSTRUCTION,
        generation_config=genai.GenerationConfig(
            temperature=settings.gemini_temperature,
            response_mime_type="application/json",
            response_schema=ROADMAP_RESPONSE_SCHEMA,
        ),
    )

    response = model.generate_content(_build_user_prompt(req))
    print("RAW GEMINI RESPONSE")
    print(response.candidates[0].finish_reason)

    parsed = GeminiRoadmapOutput.model_validate_json(response.text)

    return RoadmapResponse(
        weeks=parsed.weeks,
        rationale=parsed.rationale,
        modelMeta=ModelMeta(
            modelId=settings.gemini_model,
            generatedAt=datetime.now(timezone.utc).isoformat(),
        ),
    )
