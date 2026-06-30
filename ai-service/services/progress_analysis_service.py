from datetime import datetime, timezone

import google.generativeai as genai

from config import settings
from schemas.progress_analysis import (
    AnalysisBody,
    GeminiProgressOutput,
    ModelMeta,
    ProgressAnalysisRequest,
    ProgressAnalysisResponse,
)

SYSTEM_INSTRUCTION = """You are a senior software engineering career coach reviewing a candidate's study progress.

Your task: Analyze their recent daily study logs against their preparation roadmap and provide honest, actionable feedback.

Rules:
- Be specific. Reference actual topics the candidate studied or neglected.
- strengths: 2–4 bullet points on what they're doing well (consistency, topic coverage, hours).
- areasToImprove: 2–3 bullet points on gaps — topics in the roadmap that haven't been touched, or imbalanced focus.
- recommendedFocus: 2–3 specific roadmap topics (by name) they should prioritize next.
- hoursPaceComment: One sentence comparing their actual hours to the implied pace needed (totalWeeks × number of days → expected daily average). Be direct.
- summary: 2–3 sentences — overall assessment of this study window.
- Do not invent topics outside the roadmap. Reference only what you see in the data."""


def _build_prompt(req: ProgressAnalysisRequest) -> str:
    updates_xml = "\n  ".join(
        f'<update date="{u.date}" totalHours="{u.totalHours}">'
        + ("" if not u.notes else f'<notes>{u.notes}</notes>')
        + "".join(
            f'<topic name="{t.topicName}" category="{t.category}" hours="{t.hours}"/>'
            for t in u.topics
        )
        + "</update>"
        for u in req.updates
    )

    items_xml = "\n  ".join(
        f'<item topic="{i.topicName}" category="{i.category}" status="{i.status}"/>'
        for i in req.roadmapItems
    )

    total_hours = sum(u.totalHours for u in req.updates)
    days_count = len(req.updates)
    avg_daily = round(total_hours / days_count, 1) if days_count else 0

    return f"""<candidate>
  <target_role>{req.targetRole}</target_role>
  <total_weeks>{req.totalWeeks}</total_weeks>
  <roadmap_rationale>{req.roadmapRationale}</roadmap_rationale>
</candidate>

<study_window>
  <days_logged>{days_count}</days_logged>
  <total_hours>{total_hours}</total_hours>
  <avg_daily_hours>{avg_daily}</avg_daily_hours>
  {updates_xml}
</study_window>

<roadmap_status>
  {items_xml}
</roadmap_status>

<instructions>
  Analyze the study window above. Be specific about which topics were covered and which roadmap items
  remain untouched. Give honest, actionable feedback.
</instructions>"""


def generate_progress_analysis(req: ProgressAnalysisRequest) -> ProgressAnalysisResponse:
    genai.configure(api_key=settings.gemini_api_key)

    model = genai.GenerativeModel(
        model_name=settings.gemini_model,
        system_instruction=SYSTEM_INSTRUCTION,
        generation_config=genai.GenerationConfig(
            temperature=settings.gemini_temperature,
            response_mime_type="application/json",
            response_schema=GeminiProgressOutput,
        ),
    )

    response = model.generate_content(_build_prompt(req))
    parsed = GeminiProgressOutput.model_validate_json(response.text)

    meta = ModelMeta(
        modelId=settings.gemini_model,
        generatedAt=datetime.now(timezone.utc).isoformat(),
    )

    analysis = AnalysisBody(
        summary=parsed.summary,
        strengths=parsed.strengths,
        areasToImprove=parsed.areasToImprove,
        recommendedFocus=parsed.recommendedFocus,
        hoursPaceComment=parsed.hoursPaceComment,
        modelMeta=meta,
    )

    return ProgressAnalysisResponse(analysis=analysis, modelMeta=meta)
