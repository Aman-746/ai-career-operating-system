# AI Career OS — Phase-1 Assessment Blueprint

**Frozen architecture:** `Target Role → Topics → Questions → Topic Scores`. Topic-driven only. Resume skills stored but unused for selection/scoring. No adaptive difficulty, async processing, confidence scores, coding/mock features.

---

## 1. Shared topic vocabulary (single source of truth)

One enum, `AssessmentTopic` — imported by role config, question seed, scorer, gap analysis, roadmap. No topic string is ever a raw literal anywhere else. IDs are a permanent contract (never rename; deprecate + add).

| Enum ID | Display | Scope (key subtopics) |
|---|---|---|
| `DATA_STRUCTURES_ALGORITHMS` | Data Structures & Algorithms | arrays/strings, hashing, trees/graphs, recursion, sorting, DP, Big-O |
| `OBJECT_ORIENTED_DESIGN` | Object-Oriented Design | OOP pillars, SOLID, design patterns, low-level design |
| `SYSTEM_DESIGN` | System Design | scalability, **caching**, sharding-for-scale, queues, CAP, rate limiting |
| `DATABASES_AND_SQL` | Databases & SQL | modeling, SQL, **indexing**, transactions/ACID, SQL vs NoSQL |
| `API_AND_WEB_FUNDAMENTALS` | API & Web Fundamentals | HTTP, REST, auth concepts (JWT/OAuth), idempotency, versioning |
| `CONCURRENCY_AND_PARALLELISM` | Concurrency & Parallelism | threads, async/event loop, locks, races, deadlocks |
| `FRONTEND_ENGINEERING` | Frontend Engineering | DOM, CSS layout, rendering, component model, state, routing |
| `JAVASCRIPT_AND_TYPESCRIPT` | JavaScript & TypeScript | closures, prototypes, promises, TS types/generics |
| `TESTING_AND_CODE_QUALITY` | Testing & Code Quality | unit/integration/e2e, TDD, mocking, clean code, review |

**Boundary rules to enforce in authoring:** caching/sharding-for-scale → `SYSTEM_DESIGN`; indexing/transactions → `DATABASES_AND_SQL`; auth concepts → `API_AND_WEB_FUNDAMENTALS`; language → `JAVASCRIPT_AND_TYPESCRIPT`, platform/DOM → `FRONTEND_ENGINEERING`.

---

## 2. Role configuration

**Reuse rule: fixed 6 questions per topic.** Total questions = topic count × 6, so every topic carries the same weight and denominator across all roles.

`ROLE_CONFIGS` contains **only the 4 launch roles**. `TopicConfig.topics` is `List<AssessmentTopic>`.

| Role | Topics | Count | Total Q | Min |
|---|---|:--:|:--:|:--:|
| **Software Engineer** | DSA, OOD, System Design, DB & SQL, Concurrency | 5 | 30 | 20 |
| **Backend Engineer** | DSA, OOD, System Design, DB & SQL, API & Web, Concurrency | 6 | 36 | 24 |
| **Full Stack Engineer** | DSA, System Design, DB & SQL, API & Web, Frontend, JS/TS | 6 | 36 | 24 |
| **Frontend Engineer** | DSA, OOD, API & Web, Frontend, JS/TS, Testing | 6 | 36 | 24 |

**Availability via `Optional`, no `DEFAULT`:**
- `Optional<TopicConfig> getConfig(String role)` → `empty` *is* the "coming soon" signal.
- A role is assessable **iff** it's one of the 4 (present in `ROLE_CONFIGS`). Every other role string — known non-launch role or unexpected free text — resolves to coming-soon. One rule, no second list.
- The onboarding picker keeps all roles visible; that list lives in the frontend, decoupled from assessability. Adding an assessable role later = one config entry.

**Seed order** (by reuse payoff): DSA → System Design → DB & SQL → API & Web → OOD → Frontend → JS/TS → Concurrency → Testing.

---

## 3. Database schema (3 tables)

**`questions`**
- `id` BIGINT PK · `topic` VARCHAR(100) NOT NULL *(matches `AssessmentTopic` name)* · `difficulty` VARCHAR(10) NOT NULL `{EASY,MEDIUM,HARD}` · `stem` TEXT NOT NULL · `options` JSONB NOT NULL `[{id,text}]` · `correct_option_id` VARCHAR(8) NOT NULL *(never serialized to client)* · `explanation` TEXT · `active` BOOLEAN NOT NULL default true
- Index: `(topic, difficulty, active)`

**`assessment_sessions`**
- `id` BIGINT PK · `user_id` BIGINT FK NOT NULL · `target_role` VARCHAR(150) NOT NULL · `status` VARCHAR(15) NOT NULL `{IN_PROGRESS,COMPLETED}` · `question_ids` JSONB NOT NULL *(ordered, frozen plan)* · `topic_scores` JSONB · `result` JSONB *(reserved for later analysis)* · `created_at` TIMESTAMP NOT NULL · `completed_at` TIMESTAMP
- Index: `(user_id, status)` · **Partial unique:** `user_id WHERE status='IN_PROGRESS'` (one open session per user; hand-written SQL at startup)

**`assessment_responses`**
- `id` BIGINT PK · `session_id` BIGINT FK NOT NULL · `question_id` BIGINT FK NOT NULL · `topic` VARCHAR(100) NOT NULL *(denormalized — scoring groups on this, no join)* · `selected_option_id` VARCHAR(8) NOT NULL · `is_correct` BOOLEAN NOT NULL
- Index: `(session_id)` · Unique: `(session_id, question_id)`

All scores live in `topic_scores` JSONB — no separate score/result/instance tables.

---

## 4. API contracts (3 endpoints)

All under `/api/assessment`, JWT-secured, `@AuthenticationPrincipal User`. **`correct_option_id` and `explanation` never appear in any pre-submit response.**

### `GET /intro`
Personalized intro data with availability flag:
- `assessmentStatus: "AVAILABLE" | "COMING_SOON"` (derived from `getConfig(role).isPresent()`)
- `AVAILABLE` → full `assessmentConfig` (topics, questionCount, estimatedMinutes).
- `COMING_SOON` → `assessmentConfig: null`; hero (name, target role, detected skills) still populated.
- Response: `{ userName, currentRole, targetRole, targetCompany, yearsOfExperience, detectedSkills, experienceLevel, assessmentStatus, assessmentConfig }`

### `POST /start`
- Preconditions: profile COMPLETED + resume exists → else `400 {reason:"profile_missing"|"resume_missing"}`.
- **Coming-soon guard:** role not assessable → `409 {reason:"assessment_coming_soon"}` (server-side, independent of UI).
- Idempotent: existing IN_PROGRESS session is returned unchanged.
- Builds question set, creates session.
- `200: { sessionId, targetRole, estimatedMinutes, questions:[{questionId, topic, stem, options:[{id,text}]}] }`

### `POST /submit`
- Body: `{ sessionId, answers:[{questionId, selectedOptionId}] }`
- Validates: ownership, status IN_PROGRESS, `answers` covers `question_ids` exactly, each option valid. All questions required.
- Idempotent: already COMPLETED → return stored result.
- Scores, persists responses, flips to COMPLETED.
- `200: { sessionId, status:"COMPLETED", topicScores:[{topic,asked,correct,score,band}], gaps:[…], strengths:[…] }`

### `GET /result/{sessionId}`
- Ownership-checked. `404` if not owned; `409` if still IN_PROGRESS. Returns submit's shape.

---

## 5. Assessment session flow

```
NOT_STARTED ──/start──► IN_PROGRESS ──/submit──► COMPLETED
                            └─ /start again → same session (idempotent)
```
No ABANDONED, no TTL — `/start` resumes a stale session. Coming-soon roles never reach this flow (gated at intro + `/start`).

**Transactions:** `/start` = single tx (session insert; selection queries are read-only before write). `/submit` = single tx (response batch insert + session update). Concurrent double-`/start` → partial-unique-index violation, loser re-reads existing session.

---

## 6. Question selection logic (`/start`)

Pure function of `(targetRole, experienceLevel)`; no resume input.
1. `config = getConfig(role)` (guaranteed present — coming-soon already rejected).
2. `perTopic = 6`.
3. Difficulty mix by `ExperienceLevel`: JUNIOR 60/40 E/M · MID 25/55/20 E/M/H · SENIOR & STAFF 50/50 M/H.
4. Per topic: pull 6 ACTIVE questions across the difficulty buckets, `ORDER BY random()`.
5. **Backfill:** bucket short → borrow nearest difficulty → accept fewer; log a warning (signal to author more). Never throw.
6. Shuffle topic order; persist `question_ids`; return sanitized questions.
7. Total 0 across all topics → `409 {reason:"assessment_unavailable"}`.

---

## 7. Scoring logic (`/submit`)

Per answer: `is_correct = (selectedOptionId == correctOptionId)`.
Per topic (group on denormalized `topic`):
- `score = round(100.0 * correct / asked)` — flat percentage, no difficulty weighting.
- Band: `<50 → Gap` · `50–74 → Developing` · `≥75 → Proficient`.
Derive: `gaps` = Gap + Developing, score ascending; `strengths` = Proficient, score descending.
Write to `topic_scores`. Fully recomputable from `assessment_responses` — no hidden state. LLM analysis (later phase) interprets these; never computes them.

---

## 8. Development order

1. **`AssessmentTopic` enum** — the shared contract everything binds to.
2. **`AssessmentRoleConfig`** rewrite — 4 roles, `Optional getConfig`, no DEFAULT.
3. **3 entities + repositories** — JSONB mappings (`@JdbcTypeCode(SqlTypes.JSON)`), partial unique index SQL. Verify Hibernate creates tables.
4. **Question seeding** (long pole — start in parallel; seed by reuse order). LLM-draft, human-verify keys.
5. **`GET /intro`** + `assessmentStatus`.
6. **`POST /start`** + selection + coming-soon guard — curl-test counts, mix, idempotency, no key leakage.
7. **`POST /submit`** + scoring — curl a full submission; verify bands, idempotent re-submit.
8. **`GET /result`**.
9. **React** — intro (with coming-soon branch), assessment (local pagination + progress), analyzing loader, results (topic bars + gaps/strengths).
10. **Coming-soon UX** + capture which coming-soon roles users select (demand-ranked build order for future topic families).

Backend provable end-to-end via curl at step 8.

---

## 9. Key design decisions & trade-offs

| Decision | Trade-off accepted |
|---|---|
| Topic-driven; resume skills unused for selection | Coarser than skill-level; clean vocabulary match, zero mapping table |
| Fixed 6 Q/topic | Length driven by topic count; uniform weight + maximum bank reuse + comparable scores |
| `Optional getConfig`, no DEFAULT | No silent fallback; an honest "coming soon" beats a misleading generic assessment |
| Freeze `question_ids` on session | Minor storage; reproducible scoring as bank evolves |
| Denormalize `topic` onto responses | Slight duplication; scoring is single-table group-by |
| All scores in JSONB, 3 tables | No cross-session topic querying yet; minimal schema for a solo MVP |
| Fetch-all / submit-once | No per-question server state; loses fine-grained timing/resume |
| `ORDER BY random()` | Slow past ~10k questions; trivial at MVP scale |
| Flat percentage scoring | No difficulty weighting; fully explainable |
| Partial unique index for one-open-session | Hand-written SQL; hard DB guarantee vs racy app check |
| Answer keys server-only | Needs a sanitized DTO distinct from entity; non-negotiable |

**Two failure modes to guard in code:** (1) topic-string drift — enforce the enum everywhere + a startup check that every topic used by a launch role has ≥1 active question; (2) answer-key leakage — never reuse the `Question` entity as a response DTO.

---

## Future expansion (recommendations only — not designed)

Non-launch roles cannot be accurately represented by the 9-topic vocabulary and resolve to "coming soon" until their topic families exist. Reserve these family namespaces:

| Role group | Roles it unlocks | Candidate topic families |
|---|---|---|
| **Infrastructure & Operations** | DevOps/Platform, Cloud, SRE, Solutions Architect | Containerization & Orchestration · CI/CD & Automation · Infrastructure as Code · Cloud Architecture · Observability & Reliability · Networking & IAM |
| **Data & ML** | Data Engineer, Data Scientist, ML/AI Engineer | Data Pipelines & ETL · Data Warehousing & Modeling · Statistics & Experimentation · Machine Learning Fundamentals · Deep Learning & LLMs · MLOps |
| **Security** | Security Engineer | Application Security (OWASP) · Network Security · Threat Modeling · Cryptography & IAM · Security Compliance |
| **Product & Analysis** | Product Manager, Business Analyst | Product Strategy · User Research & Discovery · Data-Driven Decision Making · Stakeholder Management · Go-to-Market |
| **Leadership & Management** | Engineering Manager, Tech Lead | People Management · Technical Leadership · Delivery & Planning · Hiring & Culture · Cross-Functional Communication |
| **Mobile Engineering** | Android, iOS | Mobile Architecture · Mobile UI (Compose/SwiftUI) · Platform & Lifecycle · App Performance · App Distribution |
| **Quality Engineering** | QA Engineer | Test Strategy · Test Automation · Performance & Load Testing (also reuses `TESTING_AND_CODE_QUALITY`) |

The 9 core topics keep getting reused as families grow (DSA anchors ML/AI; System Design anchors Solutions Architect/SRE; Databases anchors Data Engineer) — future families *extend* the core vocabulary rather than replace it.
