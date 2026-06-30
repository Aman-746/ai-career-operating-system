-- Reference schema for the roadmap module.
--
-- This file is NOT executed automatically. Tables are created/updated by
-- Hibernate via `spring.jpa.hibernate.ddl-auto: update`. This file exists
-- as a human-readable reference and migration starting point.

CREATE TABLE roadmaps (
    id            UUID         PRIMARY KEY,
    user_id       UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    target_role   VARCHAR(100) NOT NULL,
    total_weeks   INT          NOT NULL,
    rationale     TEXT,                          -- AI one-paragraph "why this plan"
    status        VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',   -- ACTIVE | ARCHIVED
    model_id      VARCHAR(60),                   -- provenance, stamped server-side
    created_at    TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE INDEX idx_roadmaps_user_status ON roadmaps (user_id, status);

CREATE TABLE roadmap_items (
    id            UUID         PRIMARY KEY,
    roadmap_id    UUID         NOT NULL REFERENCES roadmaps (id) ON DELETE CASCADE,
    week_number   INT          NOT NULL,
    topic_name    VARCHAR(150) NOT NULL,
    category      VARCHAR(60)  NOT NULL,          -- DSA | System Design | Behavioral | Language/Framework | Other
    status        VARCHAR(20)  NOT NULL DEFAULT 'NOT_STARTED', -- NOT_STARTED | IN_PROGRESS | COMPLETED
    sort_order    INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE INDEX idx_roadmap_items_roadmap ON roadmap_items (roadmap_id, week_number);
