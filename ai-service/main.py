from fastapi import FastAPI

from routes.gap_analysis import router

app = FastAPI(title="AI Career OS — AI Service", version="1.0.0")
app.include_router(router)


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}
