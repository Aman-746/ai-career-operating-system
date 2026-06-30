from fastapi import FastAPI

from routes.gap_analysis import router as gap_analysis_router
from routes.progress_analysis import router as progress_analysis_router
from routes.roadmap import router as roadmap_router

app = FastAPI(title="AI Career OS — AI Service", version="1.0.0")
app.include_router(gap_analysis_router)
app.include_router(roadmap_router)
app.include_router(progress_analysis_router)


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}
