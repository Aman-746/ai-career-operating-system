-- Reference schema for the assessment module.
--
-- This file is NOT executed automatically. Tables are created/updated by
-- Hibernate via `spring.jpa.hibernate.ddl-auto: update`. This file exists
-- as a human-readable reference and migration starting point.
--
-- IMPORTANT: The partial unique index on assessment_sessions cannot be
-- expressed as a JPA @Index annotation. It must be created manually once
-- against the target database (dev or prod) after Hibernate has created
-- the table on first boot:
--
--   CREATE UNIQUE INDEX IF NOT EXISTS uq_one_open_session_per_user
--       ON assessment_sessions (user_id)
--       WHERE status = 'IN_PROGRESS';
--
-- This enforces the invariant that a user can have at most one open
-- (IN_PROGRESS) session at any time, at the database level.

CREATE TABLE questions (
    id                UUID PRIMARY KEY,
    topic             VARCHAR(100)  NOT NULL,  -- AssessmentTopic enum name
    difficulty        VARCHAR(10)   NOT NULL,  -- EASY | MEDIUM | HARD
    stem              TEXT          NOT NULL,
    options           JSONB         NOT NULL,  -- [{id: "a", text: "..."}, ...]
    correct_option_id VARCHAR(8)    NOT NULL,  -- never sent to the client
    explanation       TEXT,
    active            BOOLEAN       NOT NULL DEFAULT true
);

CREATE INDEX idx_questions_topic_difficulty_active
    ON questions (topic, difficulty, active);


CREATE TABLE assessment_sessions (
    id            UUID         PRIMARY KEY,
    user_id       UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    target_role   VARCHAR(150) NOT NULL,
    status        VARCHAR(15)  NOT NULL,  -- IN_PROGRESS | COMPLETED
    question_ids  JSONB        NOT NULL,  -- ordered list of served question UUIDs (frozen plan)
    topic_scores  JSONB,                  -- null until /submit; [{topic, asked, correct, score, band}]
    result        JSONB,                  -- reserved for future LLM analysis + roadmap data
    created_at    TIMESTAMP    NOT NULL DEFAULT now(),
    completed_at  TIMESTAMP
);

CREATE INDEX idx_assessment_sessions_user_status
    ON assessment_sessions (user_id, status);

-- Apply this manually after Hibernate creates the table on first boot:
-- CREATE UNIQUE INDEX IF NOT EXISTS uq_one_open_session_per_user
--     ON assessment_sessions (user_id)
--     WHERE status = 'IN_PROGRESS';


CREATE TABLE assessment_responses (
    id                 UUID        PRIMARY KEY,
    session_id         UUID        NOT NULL REFERENCES assessment_sessions (id) ON DELETE CASCADE,
    question_id        UUID        NOT NULL REFERENCES questions (id),
    topic              VARCHAR(100) NOT NULL,  -- denormalized from Question; scoring groups on this
    selected_option_id VARCHAR(8)  NOT NULL,
    is_correct         BOOLEAN     NOT NULL
);

CREATE INDEX idx_assessment_responses_session
    ON assessment_responses (session_id);

CREATE UNIQUE INDEX uq_response_session_question
    ON assessment_responses (session_id, question_id);
